import "package:dart_frog/dart_frog.dart";

import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/service/webhook_service.dart";

/// Exception thrown when authentication failed
class WebhookAuthenticationFailedException implements Exception {}

/// Service which attempts to retrieve the X-APP-KEY from the request headers
/// for the relevant app.
class WebhookAuthService {
  /// [WebhookAuthService] constructor
  WebhookAuthService({required WebhookService webhookService})
      : _webhookService = webhookService;

  final WebhookService _webhookService;

  /// Attempts to authenticate the request for the given `appId`.
  Future<RequestContext> authenticateApp(
    RequestContext context,
    String appId,
  ) async {
    var app = await _webhookService.getApp(appId);
    var key = context.request.headers["x-app-key"];

    if (app.key != key) {
      throw WebhookAuthenticationFailedException();
    }

    return context.provide<WebhookApp>(() => app);
  }
}
