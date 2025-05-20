import "package:dart_firebase_admin/firestore.dart";

import "package:dart_webhooks/src/models/app.dart";
import "package:dart_webhooks/src/models/webhook.dart";
import "package:dart_webhooks/src/models/webhook_event.dart";
import "package:dart_webhooks/src/repository/webhook_repository.dart";

// ignore: avoid_classes_with_only_static_members
/// A helper class for firebase serialization.
abstract class FirebaseSerialization {
  /// A method that strips timestamps from a map
  /// and turns them into iso8601 strings
  static Map<String, dynamic> stripTimestamps(
    Map<String, dynamic> fromFirestore,
  ) {
    dynamic transform(value) {
      if (value is Timestamp) {
        return DateTime.fromMicrosecondsSinceEpoch(
          value.seconds * Duration.microsecondsPerSecond +
              value.nanoseconds ~/ 1000,
        ).toIso8601String();
      }
      if (value is Map<String, dynamic>) {
        return stripTimestamps(value);
      }
      return value;
    }

    return {
      for (final entry in fromFirestore.entries) ...{
        entry.key: transform(entry.value),
      },
    };
  }
}

/// Firebase based implementation of [WebhookRepository].
class FirebaseWebhookRepository implements WebhookRepository {
  /// [FirebaseWebhookRepository] constructor
  const FirebaseWebhookRepository({
    required Firestore firestore,
  }) : _firestore = firestore;

  final Firestore _firestore;

  CollectionReference<WebhookApp> get _appCollection =>
      _firestore.collection("webhook_apps").withConverter(
            fromFirestore: (document) =>
                WebhookApp.fromMap({...document.data(), "id": document.id}),
            toFirestore: (app) => app.toMap()..remove("id"),
          );

  CollectionReference<Webhook> _getWebhookCollectionForApp(String appId) =>
      _appCollection.doc(appId).collection("webhooks").withConverter(
            fromFirestore: (document) =>
                Webhook.fromMap({...document.data(), "id": document.id}),
            toFirestore: (webhook) => webhook.toMap()..remove("id"),
          );

  CollectionReference<WebhookEvent> _getWebhookEventCollection(
    String appId,
    String webhookId,
  ) =>
      _getWebhookCollectionForApp(appId)
          .doc(webhookId)
          .collection("webhook_events")
          .withConverter(
            fromFirestore: (doc) => WebhookEvent.fromMap({
              ...FirebaseSerialization.stripTimestamps(doc.data()),
              "id": doc.id,
            }),
            toFirestore: (event) =>
                {...event.toMap()..remove("id"), "timestamp": event.timestamp},
          );

  @override
  Future<WebhookApp> createApp(WebhookApp app) async {
    var appDoc = _appCollection.doc();

    await appDoc.create(app);

    return app.copyWith(id: appDoc.id);
  }

  @override
  Future<Webhook> createWebhook(Webhook webhook) async {
    var webhookDoc = _getWebhookCollectionForApp(webhook.appId).doc();
    await webhookDoc.create(webhook);

    return webhook.copyWith(id: webhookDoc.id);
  }

  @override
  Future<void> deleteApp(WebhookApp app) async {
    await _appCollection.doc(app.id).delete();
  }

  @override
  Future<void> deleteWebhook(Webhook webhook) async {
    await _getWebhookCollectionForApp(webhook.appId).doc(webhook.id).delete();
  }

  @override
  Future<Webhook> getWebhook(String appId, String webhookId) async {
    var webhookDoc =
        await _getWebhookCollectionForApp(appId).doc(webhookId).get();

    if (webhookDoc.exists) {
      return webhookDoc.data()!;
    }

    throw WebhookDoesNotExistException();
  }

  @override
  Future<List<Webhook>> getWebhooksForApp(String appId) async {
    var snapshots = await _getWebhookCollectionForApp(appId).get();
    return snapshots.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<WebhookApp> updateApp(WebhookApp app) async {
    var appDoc = _appCollection.doc(app.id);

    var snapshot = await appDoc.get();

    if (!snapshot.exists) {
      throw AppDoesNotExistException();
    }

    await appDoc.set(app);

    return app;
  }

  @override
  Future<WebhookApp> getApp(String appId) async {
    var appDoc = await _appCollection.doc(appId).get();

    if (!appDoc.exists) {
      throw AppDoesNotExistException();
    }

    return appDoc.data()!;
  }

  @override
  Future<List<WebhookApp>> getApps() async {
    var appSnapshots = await _appCollection.get();

    return appSnapshots.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<WebhookEvent> createEventForWebhook(
    Webhook webhook,
    WebhookEvent event,
  ) async {
    var eventCollection = _getWebhookEventCollection(
      webhook.appId,
      webhook.id!,
    );

    var document = await eventCollection.add(event);

    return event.copyWith(id: document.id);
  }

  @override
  Future<List<WebhookEvent>> getEventsForWebhook(
    Webhook webhook, {
    DateTime? since,
  }) async {
    var eventCollection = _getWebhookEventCollection(
      webhook.appId,
      webhook.id!,
    );

    var events = await switch (since) {
      DateTime since => eventCollection
          .where("timestamp", WhereFilter.greaterThan, since)
          .get(),
      _ => eventCollection.get(),
    };

    return events.docs.map((doc) => doc.data()).toList();
  }
}
