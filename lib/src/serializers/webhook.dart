import "package:dart_frog_utils/dart_frog_utils.dart";

import "package:dart_webhooks/dart_webhooks.dart";

const _keys = Webhook.keys;

/// Serializer for [Webhook].
final webhookSerializer = <String, ValueValidator>{
  _keys.url: ValueValidator.string(
    validator: (value) {
      var uri = Uri.tryParse(value as String);
      if (uri == null) {
        return "the url needs to be a valid uri";
      }
    },
  ),
  _keys.headers: ValueValidator.map(optional: true, validator: (value) {}),
  _keys.types: ValueValidator.list(childValidator: ValueValidator.string()),
};
