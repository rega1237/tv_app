import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoldersRecord extends FirestoreRecord {
  FoldersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "folder_name" field.
  String? _folderName;
  String get folderName => _folderName ?? '';
  bool hasFolderName() => _folderName != null;

  // "client_ref" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  bool hasClientRef() => _clientRef != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "sufolder_ref" field.
  List<DocumentReference>? _sufolderRef;
  List<DocumentReference> get sufolderRef => _sufolderRef ?? const [];
  bool hasSufolderRef() => _sufolderRef != null;

  void _initializeFields() {
    _folderName = snapshotData['folder_name'] as String?;
    _clientRef = snapshotData['client_ref'] as DocumentReference?;
    _createdAt = snapshotData['createdAt'] as DateTime?;
    _sufolderRef = getDataList(snapshotData['sufolder_ref']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Folders');

  static Stream<FoldersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FoldersRecord.fromSnapshot(s));

  static Future<FoldersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FoldersRecord.fromSnapshot(s));

  static FoldersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      FoldersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FoldersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FoldersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FoldersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FoldersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFoldersRecordData({
  String? folderName,
  DocumentReference? clientRef,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'folder_name': folderName,
      'client_ref': clientRef,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class FoldersRecordDocumentEquality implements Equality<FoldersRecord> {
  const FoldersRecordDocumentEquality();

  @override
  bool equals(FoldersRecord? e1, FoldersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.folderName == e2?.folderName &&
        e1?.clientRef == e2?.clientRef &&
        e1?.createdAt == e2?.createdAt &&
        listEquality.equals(e1?.sufolderRef, e2?.sufolderRef);
  }

  @override
  int hash(FoldersRecord? e) => const ListEquality()
      .hash([e?.folderName, e?.clientRef, e?.createdAt, e?.sufolderRef]);

  @override
  bool isValidKey(Object? o) => o is FoldersRecord;
}
