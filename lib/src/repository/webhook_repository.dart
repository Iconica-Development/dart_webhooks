import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/models/webhook.dart";
import "package:dart_webhooks/src/models/webhook_event.dart";

/// The webhook repository interface
abstract interface class WebhookRepository {
  /// A method for creating a [Webhook].
  Future<Webhook> createWebhook(Webhook webhook);

  /// A method for retrieving a [Webhook].
  Future<Webhook> getWebhook(String appId, String webhookId);

  /// A method for creating a [WebhookEvent].
  Future<WebhookEvent> createEventForWebhook(
    Webhook webhook,
    WebhookEvent event,
  );

  /// A method for retrieving a list of [WebhookEvent].
  Future<List<WebhookEvent>> getEventsForWebhook(
    Webhook webhook, {
    DateTime? since,
  });

  /// A method for retrieving a list of [Webhook] for a certain appId.
  Future<List<Webhook>> getWebhooksForApp(String appId);

  /// A method for deleting a [Webhook].
  Future<void> deleteWebhook(Webhook webhook);

  /// A method for creating a [WebhookApp].
  Future<WebhookApp> createApp(WebhookApp app);

  /// A method for deleting a [WebhookApp].
  Future<void> deleteApp(WebhookApp app);

  /// A method for updating a [WebhookApp].
  Future<WebhookApp> updateApp(WebhookApp app);

  /// A method for retrieving a [WebhookApp].
  Future<WebhookApp> getApp(String appId);

  /// A method for retrieving all [WebhookApp]s.
  Future<List<WebhookApp>> getApps();
}

/// Exception thrown when a [WebhookApp] does not exist.
class AppDoesNotExistException implements Exception {}

/// Exception thrown when a [Webhook] does not exist.
class WebhookDoesNotExistException implements Exception {}
