import "package:dart_api_service/dart_api_service.dart";
import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/models/webhook.dart";
import "package:dart_webhooks/src/models/webhook_event.dart";
import "package:dart_webhooks/src/repository/webhook_repository.dart";
import "package:logger/logger.dart";

/// Exception thrown when a webhook type is disallowed.
class WebhookTypeNotAllowedException implements Exception {}

/// Exception thrown when an event is forbidden for an app.
class WebhookEventForbiddenForAppException implements Exception {}

/// Service used for handling all things webhook related.
class WebhookService {
  /// [WebhookService] constructor
  const WebhookService({
    required WebhookRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final WebhookRepository _repository;
  final Logger _logger;

  /// Method for creating a [Webhook].
  Future<Webhook> createWebhook(Webhook webhook) async {
    var app = await _repository.getApp(webhook.appId);

    if (!app.isWebhookAllowed(webhook)) {
      throw WebhookTypeNotAllowedException();
    }

    return _repository.createWebhook(webhook);
  }

  /// Method for creating a [WebhookApp].
  Future<WebhookApp> createApp(WebhookApp app) async =>
      _repository.createApp(app);

  /// Method for calling a [Webhook] forwards calls to apps.
  Future<void> callWebhooks(WebhookEvent event) async {
    var apps = await _repository.getApps();
    var allowedApps = apps.where((app) => app.matchesScope(event.scopes));

    await Future.wait(
      allowedApps.map((app) => callWebhooksForApp(app, event)),
    );
  }

  /// Method that calls all webhooks for a certain app.
  Future<void> callWebhooksForApp(WebhookApp app, WebhookEvent event) async {
    if (!app.matchesScope(event.scopes)) {
      throw WebhookEventForbiddenForAppException();
    }

    var webhooks = await _repository.getWebhooksForApp(app.id!);

    var typedWebhooks = webhooks.where(
      (webhook) => webhook.types.contains(event.type),
    );

    await Future.wait(
      typedWebhooks.map((webhook) => callWebhook(webhook, event)),
    );
  }

  /// Method that calls a [Webhook].
  Future<void> callWebhook(
    Webhook webhook,
    WebhookEvent event,
  ) async {
    var apiService = HttpApiService(baseUrl: webhook.url);

    var endpoint = apiService
        .endpoint(webhook.url.path)
        .withConverter(MapJsonResponseConverter());

    var createdEvent = await _repository.createEventForWebhook(webhook, event);

    try {
      await endpoint.post(
        headers: webhook.headers,
        requestModel: createdEvent.toMap(),
      );
    } on ApiException {
      _logger.e("Something went wrong with calling the webhook");
    }
  }

  /// Method that deletes a [Webhook].
  Future<void> deleteWebhook(Webhook webhook) async =>
      _repository.deleteWebhook(webhook);

  /// Method that retrieves a list of [Webhook].
  Future<List<Webhook>> getWebhooks(String appId) async =>
      _repository.getWebhooksForApp(appId);

  /// Method that returns a [WebhookApp].
  Future<WebhookApp> getApp(String appId) => _repository.getApp(appId);

  /// Method that returns a [Webhook].
  Future<Webhook> getWebhook(String appId, String webhookId) =>
      _repository.getWebhook(appId, webhookId);

  /// Method that returns a list of [WebhookEvent]
  Future<List<WebhookEvent>> getWebhookEvents(
    String appId,
    String webhookId, {
    DateTime? since,
  }) async {
    var webhook = await _repository.getWebhook(appId, webhookId);
    return _repository.getEventsForWebhook(webhook, since: since);
  }
}
