/// A webhook event.
class WebhookEvent {
  /// [WebhookEvent] constructor
  WebhookEvent({
    required this.type,
    required this.scopes,
    required this.payload,
    this.id,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// factory for deserializer [WebhookEvent] from a map
  factory WebhookEvent.fromMap(Map<String, dynamic> map) => WebhookEvent(
        id: map[keys.id] as String?,
        type: (map[keys.type] ?? "") as String,
        scopes: List<String>.from(
          (map[keys.scopes] as List? ?? const <String>[]).whereType<String>(),
        ),
        payload: Map<String, dynamic>.from(
          (map[keys.payload] ?? const <Map<String, dynamic>>{})
              as Map<String, dynamic>,
        ),
        timestamp: DateTime.tryParse(map[keys.timestamp] as String),
      );

  /// The type of event being sent
  final String type;

  /// If an app has access to any of the scopes in this event,
  /// it's webhooks need to be considered.
  final List<String> scopes;

  /// The payload being sent to all webhooks, the schema should be consistent
  /// with the type of webhook event being sent.
  final Map<String, dynamic> payload;

  /// The point at which this event was created
  final DateTime timestamp;

  /// The identifier of the document
  final String? id;

  /// The map keys used in `toMap` and `fromMap`
  static const keys = (
    id: "id",
    timestamp: "timestamp",
    type: "type",
    scopes: "scopes",
    payload: "payload",
  );

  /// Serializer function
  Map<String, dynamic> toMap() => <String, dynamic>{
        keys.id: id,
        keys.timestamp: timestamp.toIso8601String(),
        keys.type: type,
        keys.scopes: scopes,
        keys.payload: payload,
      };

  /// Serializer function that excludes the scope, used when
  /// a response is returned.
  Map<String, dynamic> toResponse() => <String, dynamic>{
        keys.id: id,
        keys.type: type,
        keys.payload: payload,
        keys.timestamp: timestamp.toIso8601String(),
      };

  /// Creates a new [WebhookEvent] containing the old and updates values.
  WebhookEvent copyWith({
    String? id,
    String? type,
    List<String>? scopes,
    Map<String, dynamic>? payload,
  }) =>
      WebhookEvent(
        id: id ?? this.id,
        type: type ?? this.type,
        scopes: scopes ?? this.scopes,
        payload: payload ?? this.payload,
      );
}
