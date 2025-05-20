import "dart:io";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

import "package:dart_webhooks/src/models/webhook.dart";
import "package:dart_webhooks/src/serializers/webhook.dart";
import "package:dart_webhooks/src/service/webhook_auth_service.dart";
import "package:dart_webhooks/src/service/webhook_service.dart";

/// Function that returns the list create view for webhooks.
Future<Response> listCreateWebhookView(
  RequestContext context,
  String appId,
) async {
  var webhookAuthService = context.read<WebhookAuthService>();
  return methodRequest(
    requestContext: await webhookAuthService.authenticateApp(context, appId),
    post: (context) => _createWebhook(context, appId),
    get: (context) => _getWebhooks(context, appId),
  );
}

Future<Response> _createWebhook(RequestContext context, String appId) async {
  var service = context.read<WebhookService>();

  var webhook = await context.loadValidatedObject(
    webhookSerializer,
    Webhook.fromMap,
  );

  var webhookWithAppId = webhook.copyWith(
    appId: appId,
  );

  var createdWebhook = await service.createWebhook(webhookWithAppId);

  return Response.json(
    statusCode: HttpStatus.created,
    body: createdWebhook.toMap(),
  );
}

Future<Response> _getWebhooks(RequestContext context, String appId) async {
  var service = context.read<WebhookService>();

  var webhooks = await service.getWebhooks(appId);

  return Response.json(
    body: webhooks.map((webhook) => webhook.toMap()).toList(),
  );
}
