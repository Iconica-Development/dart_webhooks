import "dart:io";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/serializers/app.dart";
import "package:dart_webhooks/src/service/webhook_service.dart";

/// Function that returns the view required for creating an app.
Future<Response> createAppView(RequestContext context) async => methodRequest(
      requestContext: context,
      post: _createApp,
    );

Future<Response> _createApp(RequestContext context) async {
  var webhookService = context.read<WebhookService>();

  var app = await context.loadValidatedObject(
    webhookAppSerializer,
    WebhookApp.fromMap,
  );

  var createdApp = await webhookService.createApp(app);

  return Response.json(
    statusCode: HttpStatus.created,
    body: createdApp.toMap(),
  );
}
