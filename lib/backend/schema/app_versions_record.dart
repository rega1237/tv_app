import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppVersionsRecord extends FirestoreRecord {
  AppVersionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "platform" field.
  String? _platform;
  String get platform => _platform ?? '';
  bool hasPlatform() => _platform != null;

  // "latest_version" field.
  String? _latestVersion;
  String get latestVersion => _latestVersion ?? '';
  bool hasLatestVersion() => _latestVersion != null;

  // "build_number" field.
  int? _buildNumber;
  int get buildNumber => _buildNumber ?? 0;
  bool hasBuildNumber() => _buildNumber != null;

  // "force_update" field.
  bool? _forceUpdate;
  bool get forceUpdate => _forceUpdate ?? false;
  bool hasForceUpdate() => _forceUpdate != null;

  // "store_url" field.
  String? _storeUrl;
  String get storeUrl => _storeUrl ?? '';
  bool hasStoreUrl() => _storeUrl != null;

  void _initializeFields() {
    _platform = snapshotData['platform'] as String?;
    _latestVersion = snapshotData['latest_version'] as String?;
    _buildNumber = castToType<int>(snapshotData['build_number']);
    _forceUpdate = snapshotData['force_update'] as bool?;
    _storeUrl = snapshotData['store_url'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('app_versions');

  static Stream<AppVersionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AppVersionsRecord.fromSnapshot(s));

  static Future<AppVersionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AppVersionsRecord.fromSnapshot(s));

  static AppVersionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AppVersionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static AppVersionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AppVersionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'AppVersionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AppVersionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createAppVersionsRecordData({
  String? platform,
  String? latestVersion,
  int? buildNumber,
  bool? forceUpdate,
  String? storeUrl,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'platform': platform,
      'latest_version': latestVersion,
      'build_number': buildNumber,
      'force_update': forceUpdate,
      'store_url': storeUrl,
    }.withoutNulls,
  );

  return firestoreData;
}

class AppVersionsRecordDocumentEquality implements Equality<AppVersionsRecord> {
  const AppVersionsRecordDocumentEquality();

  @override
  bool equals(AppVersionsRecord? e1, AppVersionsRecord? e2) {
    return e1?.platform == e2?.platform &&
        e1?.latestVersion == e2?.latestVersion &&
        e1?.buildNumber == e2?.buildNumber &&
        e1?.forceUpdate == e2?.forceUpdate &&
        e1?.storeUrl == e2?.storeUrl;
  }

  @override
  int hash(AppVersionsRecord? e) => const ListEquality().hash([
        e?.platform,
        e?.latestVersion,
        e?.buildNumber,
        e?.forceUpdate,
        e?.storeUrl
      ]);

  @override
  bool isValidKey(Object? o) => o is AppVersionsRecord;
}
