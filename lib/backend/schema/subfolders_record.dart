import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubfoldersRecord extends FirestoreRecord {
  SubfoldersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "subfolder_name" field.
  String? _subfolderName;
  String get subfolderName => _subfolderName ?? '';
  bool hasSubfolderName() => _subfolderName != null;

  // "branch_ref" field.
  DocumentReference? _branchRef;
  DocumentReference? get branchRef => _branchRef;
  bool hasBranchRef() => _branchRef != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "folder_ref" field.
  DocumentReference? _folderRef;
  DocumentReference? get folderRef => _folderRef;
  bool hasFolderRef() => _folderRef != null;

  void _initializeFields() {
    _subfolderName = snapshotData['subfolder_name'] as String?;
    _branchRef = snapshotData['branch_ref'] as DocumentReference?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _folderRef = snapshotData['folder_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('subfolders');

  static Stream<SubfoldersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SubfoldersRecord.fromSnapshot(s));

  static Future<SubfoldersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SubfoldersRecord.fromSnapshot(s));

  static SubfoldersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SubfoldersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SubfoldersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SubfoldersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SubfoldersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SubfoldersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSubfoldersRecordData({
  String? subfolderName,
  DocumentReference? branchRef,
  DateTime? createdAt,
  DocumentReference? folderRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'subfolder_name': subfolderName,
      'branch_ref': branchRef,
      'createdAt': createdAt,
      'folder_ref': folderRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class SubfoldersRecordDocumentEquality implements Equality<SubfoldersRecord> {
  const SubfoldersRecordDocumentEquality();

  @override
  bool equals(SubfoldersRecord? e1, SubfoldersRecord? e2) {
    return e1?.subfolderName == e2?.subfolderName &&
        e1?.branchRef == e2?.branchRef &&
        e1?.createdAt == e2?.createdAt &&
        e1?.folderRef == e2?.folderRef;
  }

  @override
  int hash(SubfoldersRecord? e) => const ListEquality()
      .hash([e?.subfolderName, e?.branchRef, e?.createdAt, e?.folderRef]);

  @override
  bool isValidKey(Object? o) => o is SubfoldersRecord;
}
