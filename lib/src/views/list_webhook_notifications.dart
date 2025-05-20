import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";
import "package:dart_webhooks/dart_webhooks.dart";

/// Function that returns the webhook events list view.
Future<Response> listWebhookEventsView(
  RequestContext context,
  String appId,
  String webhookId,
) async {
  var webhookAuthService = context.read<WebhookAuthService>();

  return methodRequest(
    requestContext: await webhookAuthService.authenticateApp(context, appId),
    get: (context) => _listWebhookEvents(context, appId, webhookId),
  );
}

Future<Response> _listWebhookEvents(
  RequestContext context,
  String appId,
  String webhookId,
) async {
  var webhookService = context.read<WebhookService>();

  var sinceString = context.request.uri.queryParameters["since"];
  var since = switch (sinceString) {
    String since => DateTime.tryParse(since),
    _ => null,
  };

  var webhookEvents = await webhookService.getWebhookEvents(
    appId,
    webhookId,
    since: since,
  );

  return Response.json(
    body: webhookEvents.map((events) => events.toResponse()).toList(),
  );
}
