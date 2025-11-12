import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChannelsBranchRecord extends FirestoreRecord {
  ChannelsBranchRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "client_ref" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  bool hasClientRef() => _clientRef != null;

  // "branch_ref" field.
  DocumentReference? _branchRef;
  DocumentReference? get branchRef => _branchRef;
  bool hasBranchRef() => _branchRef != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _clientRef = snapshotData['client_ref'] as DocumentReference?;
    _branchRef = snapshotData['branch_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('channels_branch');

  static Stream<ChannelsBranchRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChannelsBranchRecord.fromSnapshot(s));

  static Future<ChannelsBranchRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChannelsBranchRecord.fromSnapshot(s));

  static ChannelsBranchRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChannelsBranchRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChannelsBranchRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChannelsBranchRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChannelsBranchRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChannelsBranchRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChannelsBranchRecordData({
  String? name,
  DocumentReference? clientRef,
  DocumentReference? branchRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'client_ref': clientRef,
      'branch_ref': branchRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChannelsBranchRecordDocumentEquality
    implements Equality<ChannelsBranchRecord> {
  const ChannelsBranchRecordDocumentEquality();

  @override
  bool equals(ChannelsBranchRecord? e1, ChannelsBranchRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.clientRef == e2?.clientRef &&
        e1?.branchRef == e2?.branchRef;
  }

  @override
  int hash(ChannelsBranchRecord? e) =>
      const ListEquality().hash([e?.name, e?.clientRef, e?.branchRef]);

  @override
  bool isValidKey(Object? o) => o is ChannelsBranchRecord;
}
