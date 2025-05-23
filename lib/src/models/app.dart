import "package:dart_webhooks/src/models/webhook.dart";

/// An webhook app.
class WebhookApp {
  /// [WebhookApp] constructor
  const WebhookApp({
    required this.id,
    required this.name,
    required this.types,
    required this.scopes,
  });

  /// Factory to construct a [WebhookApp] from a [Map]
  factory WebhookApp.fromMap(Map<String, dynamic> map) => WebhookApp(
        id: map[keys.id] != null ? map[keys.id] as String : null,
        name: (map[keys.name] ?? "") as String,
        types: List<String>.from(
          (map[keys.types] as List? ?? const <String>[]).whereType<String>(),
        ),
        scopes: List<String>.from(
          (map[keys.scopes] as List? ?? const <String>[]).whereType<String>(),
        ),
      );

  /// The webhook app identifier
  final String? id;

  /// The webhook app name
  final String name;

  /// The webhook app allowed types
  final List<String> types;

  /// The webhook app scopes
  final List<String> scopes;

  /// Map keys used by [WebhookApp] `fromMap` and `toMap`.
  static const keys = (
    id: "id",
    name: "name",
    types: "types",
    scopes: "scopes",
  );

  Iterable<RegExp> get _scopesAsExpressions => scopes.map((scope) {
        var preparedScope =
            scope.replaceAll(".", r"\.").replaceAll("*", "[a-z]*");
        return RegExp(preparedScope);
      });

  /// Serializer function.
  Map<String, dynamic> toMap() => {
        keys.id: id,
        keys.name: name,
        keys.types: types,
        keys.scopes: scopes,
      };

  /// Create a new [WebhookApp] containing the old and updates values.
  WebhookApp copyWith({
    String? id,
    String? name,
    List<String>? types,
    List<String>? scopes,
  }) =>
      WebhookApp(
        id: id ?? this.id,
        name: name ?? this.name,
        types: types ?? this.types,
        scopes: scopes ?? this.scopes,
      );

  /// Check if [Webhook] is allowed inside this [WebhookApp]
  bool isWebhookAllowed(Webhook webhook) => webhook.types.every(types.contains);

  /// Method for checking if any of the scopes matches the [WebhookApp] scopes.
  bool matchesScope(List<String> scopes) =>
      scopes.any((scope) => _scopeMatches(scope, _scopesAsExpressions));

  bool _scopeMatches(String scope, Iterable<RegExp> scopeExpressions) =>
      _scopesAsExpressions.any((appScope) => scope.startsWith(appScope));
}
