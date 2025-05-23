import "dart:io";

import "package:dart_frog/dart_frog.dart";
import "package:dart_frog_utils/dart_frog_utils.dart";

import "package:dart_webhooks/dart_webhooks.dart";

/// Handles [AppDoesNotExistException]  which is thrown
/// when the webhook app does not exist.
Response webhookAppDoesNotExistExceptionHandler(
  RequestContext context,
  AppDoesNotExistException exception,
) =>
    Response.json(
      statusCode: HttpStatus.notFound,
      body: {"error": "The requested app does not exist"},
    );

/// Handles [WebhookDoesNotExistException]  which is thrown
/// when the webhook does not exist.
Response webhookDoesNotExistExceptionHandler(
  RequestContext context,
  WebhookDoesNotExistException exception,
) =>
    Response.json(
      statusCode: HttpStatus.notFound,
      body: {"error": "The requested webhook does not exist"},
    );

/// Handles [WebhookTypeNotAllowedException]  which is thrown
/// when the webhook type is disallowed.
Response webhookTypeNotAllowedExceptionHandler(
  RequestContext context,
  WebhookTypeNotAllowedException exception,
) =>
    Response.json(
      statusCode: HttpStatus.badRequest,
      body: {"error": "The webhook type provided is not allowed"},
    );

/// Handles [WebhookEventForbiddenForAppException]  which is thrown
/// when the key provided does not grant access to this event type.
Response webhookEventForbiddenForAppExceptionHandler(
  RequestContext context,
  WebhookEventForbiddenForAppException exception,
) =>
    Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {"error": "The given app key is incorrect for this app"},
    );

/// Registration function for all exception handlers of this package.
void registerWebhookExceptionHandlers(ExceptionHandlerMiddleware middleware) {
  middleware
    ..addExceptionHandler(webhookAppDoesNotExistExceptionHandler)
    ..addExceptionHandler(webhookDoesNotExistExceptionHandler)
    ..addExceptionHandler(webhookTypeNotAllowedExceptionHandler)
    ..addExceptionHandler(webhookEventForbiddenForAppExceptionHandler);
}

const _registerHandlers = registerWebhookExceptionHandlers;

/// Extension on [ExceptionHandlerMiddleware] for providing
/// the webhook handlers.
extension RegisterWebhookExceptionHandlers on ExceptionHandlerMiddleware {
  /// Method that registers the webhook exception handlers.
  void registerWebhookExceptionHandlers() {
    _registerHandlers(this);
  }
}
