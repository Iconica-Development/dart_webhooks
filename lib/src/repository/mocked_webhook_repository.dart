import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/models/webhook.dart";
import "package:dart_webhooks/src/models/webhook_event.dart";
import "package:dart_webhooks/src/repository/webhook_repository.dart";

/// Mocked implementation of [WebhookRepository].
class MockedWebhookRepository implements WebhookRepository {
  /// [MockedWebhookRepository] constructor
  const MockedWebhookRepository();

  @override
  Future<WebhookApp> createApp(WebhookApp app) async => app.copyWith(id: "1");

  @override
  Future<Webhook> createWebhook(Webhook webhook) async =>
      webhook.copyWith(id: "1");

  @override
  Future<void> deleteApp(WebhookApp app) async {}

  @override
  Future<void> deleteWebhook(Webhook webhook) async {}

  @override
  Future<WebhookApp> getApp(String appId) async => WebhookApp(
        id: appId,
        name: "App",
        types: ["test"],
        scopes: ["testscope"],
      );

  @override
  Future<Webhook> getWebhook(String appId, String webhookId) async => Webhook(
        id: webhookId,
        url: Uri.parse("http://localhost:8080/api/webhook-mock"),
        appId: appId,
        headers: {},
        types: ["test"],
      );

  @override
  Future<List<Webhook>> getWebhooksForApp(String appId) async => [
        Webhook(
          id: "1",
          url: Uri.parse("http://localhost:8080/api/webhook-mock"),
          appId: appId,
          headers: {},
          types: ["test"],
        ),
      ];

  @override
  Future<WebhookApp> updateApp(WebhookApp app) async => app;

  @override
  Future<List<WebhookApp>> getApps() async => [
        const WebhookApp(
          id: "1",
          name: "App",
          types: ["test"],
          scopes: ["testscope"],
        ),
      ];

  @override
  Future<WebhookEvent> createEventForWebhook(
    Webhook webhook,
    WebhookEvent event,
  ) async =>
      event;

  @override
  Future<List<WebhookEvent>> getEventsForWebhook(
    Webhook webhook, {
    DateTime? since,
  }) async =>
      [
        WebhookEvent(
          id: "1",
          type: "",
          scopes: [""],
          payload: {},
        ),
      ];
}
