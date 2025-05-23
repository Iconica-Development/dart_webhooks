import "package:dart_frog_utils/dart_frog_utils.dart";

import "package:dart_webhooks/dart_webhooks.dart";

const _appKeys = WebhookApp.keys;

/// A serializer for [WebhookApp]
final webhookAppSerializer = <String, ValueValidator>{
  _appKeys.name: ValueValidator.string(),
  _appKeys.scopes: ValueValidator.list(childValidator: ValueValidator.string()),
  _appKeys.types: ValueValidator.list(childValidator: ValueValidator.string()),
};
