import "package:dart_frog/dart_frog.dart";
import "package:dart_webhooks/dart_webhooks.dart";
import "package:logger/logger.dart";

final _authServiceProvider = provider(
  (context) =>
      WebhookAuthService(webhookService: context.read<WebhookService>()),
);
final _webhookServiceProvider = provider(
  (context) => WebhookService(
    repository: context.read<WebhookRepository>(),
    logger: context.read<Logger>(),
  ),
);

/// Provides all webhook dependencies.
Middleware getWebhookDependencies([
  WebhookRepository Function(RequestContext context)? builder,
]) =>
    (Handler handler) {
      var repositoryProvider = provider<WebhookRepository>(
        builder ?? (context) => const MockedWebhookRepository(),
      );

      return handler
          .use(_authServiceProvider)
          .use(_webhookServiceProvider)
          .use(repositoryProvider);
    };
