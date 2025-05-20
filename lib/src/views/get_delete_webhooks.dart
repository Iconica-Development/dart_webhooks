import "dart:io";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";
import "package:dart_webhooks/src/service/webhook_auth_service.dart";
import "package:dart_webhooks/src/service/webhook_service.dart";

/// Function that returns the delete webhooks view.
Future<Response> getDeleteWebhooks(
  RequestContext context,
  String appId,
  String webhookId,
) async {
  var webhookAuthService = context.read<WebhookAuthService>();
  return methodRequest(
    requestContext: await webhookAuthService.authenticateApp(context, appId),
    delete: (context) => _deleteWebhook(context, appId, webhookId),
    get: (context) => _getWebhook(context, appId, webhookId),
  );
}

Future<Response> _deleteWebhook(
  RequestContext context,
  String appId,
  String webhookId,
) async {
  var service = context.read<WebhookService>();

  var webhook = await service.getWebhook(appId, webhookId);

  await service.deleteWebhook(webhook);

  return Response(
    statusCode: HttpStatus.noContent,
  );
}

Future<Response> _getWebhook(
  RequestContext context,
  String appId,
  String webhookId,
) async {
  var service = context.read<WebhookService>();

  var webhook = await service.getWebhook(appId, webhookId);

  return Response.json(
    body: webhook.toMap(),
  );
}
