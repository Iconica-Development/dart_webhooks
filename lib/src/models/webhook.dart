/// A webhook
class Webhook {
  /// [Webhook] constructor.
  const Webhook({
    required this.id,
    required this.url,
    required this.appId,
    required this.headers,
    required this.types,
  });

  /// Factory for deserializing [Webhook] from [Map].
  factory Webhook.fromMap(Map<String, dynamic> map) => Webhook(
        id: map[keys.id] != null ? map[keys.id] as String : null,
        url: Uri.parse(map[keys.url] as String),
        appId: (map[keys.appId] ?? "") as String,
        headers: Map<String, String>.from(
          (map[keys.headers] as Map? ?? const {}).cast<String, String>(),
        ),
        types: List<String>.from(
          (map[keys.types] as List? ?? const []).whereType<String>(),
        ),
      );

  /// Webhook identifier
  final String? id;

  /// The url that should be notified
  final Uri url;

  /// The app id for this webhook
  final String appId;

  /// The request headers the notification should contain.
  final Map<String, String> headers;

  /// The types used.
  final List<String> types;

  /// The map keys used by `toMap` and `fromMap`
  static const keys = (
    id: "id",
    url: "url",
    appId: "appId",
    headers: "headers",
    types: "types",
  );

  /// The serializer function
  Map<String, dynamic> toMap() => <String, dynamic>{
        keys.id: id,
        keys.url: url.toString(),
        keys.appId: appId,
        keys.headers: headers,
        keys.types: types,
      };

  /// Returns a new [Webhook] with the old and updated values.
  Webhook copyWith({
    String? id,
    Uri? url,
    String? appId,
    Map<String, String>? headers,
    List<String>? types,
  }) =>
      Webhook(
        id: id ?? this.id,
        url: url ?? this.url,
        appId: appId ?? this.appId,
        headers: headers ?? this.headers,
        types: types ?? this.types,
      );
}
