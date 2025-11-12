import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubscriptionRecord extends FirestoreRecord {
  SubscriptionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "sucursalRef" field.
  DocumentReference? _sucursalRef;
  DocumentReference? get sucursalRef => _sucursalRef;
  bool hasSucursalRef() => _sucursalRef != null;

  // "clientRef" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  bool hasClientRef() => _clientRef != null;

  // "startDate" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  bool hasStartDate() => _startDate != null;

  // "endDate" field.
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  bool hasEndDate() => _endDate != null;

  // "planName" field.
  String? _planName;
  String get planName => _planName ?? '';
  bool hasPlanName() => _planName != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "branchName" field.
  String? _branchName;
  String get branchName => _branchName ?? '';
  bool hasBranchName() => _branchName != null;

  // "customID" field.
  String? _customID;
  String get customID => _customID ?? '';
  bool hasCustomID() => _customID != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  bool hasIsActive() => _isActive != null;

  void _initializeFields() {
    _sucursalRef = snapshotData['sucursalRef'] as DocumentReference?;
    _clientRef = snapshotData['clientRef'] as DocumentReference?;
    _startDate = snapshotData['startDate'] as DateTime?;
    _endDate = snapshotData['endDate'] as DateTime?;
    _planName = snapshotData['planName'] as String?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _branchName = snapshotData['branchName'] as String?;
    _customID = snapshotData['customID'] as String?;
    _isActive = snapshotData['isActive'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('subscription');

  static Stream<SubscriptionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SubscriptionRecord.fromSnapshot(s));

  static Future<SubscriptionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SubscriptionRecord.fromSnapshot(s));

  static SubscriptionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SubscriptionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SubscriptionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SubscriptionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SubscriptionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SubscriptionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSubscriptionRecordData({
  DocumentReference? sucursalRef,
  DocumentReference? clientRef,
  DateTime? startDate,
  DateTime? endDate,
  String? planName,
  DateTime? createdAt,
  String? branchName,
  String? customID,
  bool? isActive,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sucursalRef': sucursalRef,
      'clientRef': clientRef,
      'startDate': startDate,
      'endDate': endDate,
      'planName': planName,
      'createdAt': createdAt,
      'branchName': branchName,
      'customID': customID,
      'isActive': isActive,
    }.withoutNulls,
  );

  return firestoreData;
}

class SubscriptionRecordDocumentEquality
    implements Equality<SubscriptionRecord> {
  const SubscriptionRecordDocumentEquality();

  @override
  bool equals(SubscriptionRecord? e1, SubscriptionRecord? e2) {
    return e1?.sucursalRef == e2?.sucursalRef &&
        e1?.clientRef == e2?.clientRef &&
        e1?.startDate == e2?.startDate &&
        e1?.endDate == e2?.endDate &&
        e1?.planName == e2?.planName &&
        e1?.createdAt == e2?.createdAt &&
        e1?.branchName == e2?.branchName &&
        e1?.customID == e2?.customID &&
        e1?.isActive == e2?.isActive;
  }

  @override
  int hash(SubscriptionRecord? e) => const ListEquality().hash([
        e?.sucursalRef,
        e?.clientRef,
        e?.startDate,
        e?.endDate,
        e?.planName,
        e?.createdAt,
        e?.branchName,
        e?.customID,
        e?.isActive
      ]);

  @override
  bool isValidKey(Object? o) => o is SubscriptionRecord;
}
