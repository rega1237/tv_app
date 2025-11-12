import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FilesRecord extends FirestoreRecord {
  FilesRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "file_name" field.
  String? _fileName;
  String get fileName => _fileName ?? '';
  bool hasFileName() => _fileName != null;

  // "storage_path" field.
  String? _storagePath;
  String get storagePath => _storagePath ?? '';
  bool hasStoragePath() => _storagePath != null;

  // "file_type" field.
  String? _fileType;
  String get fileType => _fileType ?? '';
  bool hasFileType() => _fileType != null;

  // "uploaded_at" field.
  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _uploadedAt;
  bool hasUploadedAt() => _uploadedAt != null;

  // "uploaded_by" field.
  DocumentReference? _uploadedBy;
  DocumentReference? get uploadedBy => _uploadedBy;
  bool hasUploadedBy() => _uploadedBy != null;

  // "file_url" field.
  String? _fileUrl;
  String get fileUrl => _fileUrl ?? '';
  bool hasFileUrl() => _fileUrl != null;

  // "file_url_video" field.
  String? _fileUrlVideo;
  String get fileUrlVideo => _fileUrlVideo ?? '';
  bool hasFileUrlVideo() => _fileUrlVideo != null;

  // "file_url_generic" field.
  String? _fileUrlGeneric;
  String get fileUrlGeneric => _fileUrlGeneric ?? '';
  bool hasFileUrlGeneric() => _fileUrlGeneric != null;

  // "in_use" field.
  bool? _inUse;
  bool get inUse => _inUse ?? false;
  bool hasInUse() => _inUse != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _fileName = snapshotData['file_name'] as String?;
    _storagePath = snapshotData['storage_path'] as String?;
    _fileType = snapshotData['file_type'] as String?;
    _uploadedAt = snapshotData['uploaded_at'] as DateTime?;
    _uploadedBy = snapshotData['uploaded_by'] as DocumentReference?;
    _fileUrl = snapshotData['file_url'] as String?;
    _fileUrlVideo = snapshotData['file_url_video'] as String?;
    _fileUrlGeneric = snapshotData['file_url_generic'] as String?;
    _inUse = snapshotData['in_use'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('files')
          : FirebaseFirestore.instance.collectionGroup('files');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('files').doc(id);

  static Stream<FilesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => FilesRecord.fromSnapshot(s));

  static Future<FilesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => FilesRecord.fromSnapshot(s));

  static FilesRecord fromSnapshot(DocumentSnapshot snapshot) => FilesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static FilesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      FilesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'FilesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is FilesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createFilesRecordData({
  String? fileName,
  String? storagePath,
  String? fileType,
  DateTime? uploadedAt,
  DocumentReference? uploadedBy,
  String? fileUrl,
  String? fileUrlVideo,
  String? fileUrlGeneric,
  bool? inUse,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'file_name': fileName,
      'storage_path': storagePath,
      'file_type': fileType,
      'uploaded_at': uploadedAt,
      'uploaded_by': uploadedBy,
      'file_url': fileUrl,
      'file_url_video': fileUrlVideo,
      'file_url_generic': fileUrlGeneric,
      'in_use': inUse,
    }.withoutNulls,
  );

  return firestoreData;
}

class FilesRecordDocumentEquality implements Equality<FilesRecord> {
  const FilesRecordDocumentEquality();

  @override
  bool equals(FilesRecord? e1, FilesRecord? e2) {
    return e1?.fileName == e2?.fileName &&
        e1?.storagePath == e2?.storagePath &&
        e1?.fileType == e2?.fileType &&
        e1?.uploadedAt == e2?.uploadedAt &&
        e1?.uploadedBy == e2?.uploadedBy &&
        e1?.fileUrl == e2?.fileUrl &&
        e1?.fileUrlVideo == e2?.fileUrlVideo &&
        e1?.fileUrlGeneric == e2?.fileUrlGeneric &&
        e1?.inUse == e2?.inUse;
  }

  @override
  int hash(FilesRecord? e) => const ListEquality().hash([
        e?.fileName,
        e?.storagePath,
        e?.fileType,
        e?.uploadedAt,
        e?.uploadedBy,
        e?.fileUrl,
        e?.fileUrlVideo,
        e?.fileUrlGeneric,
        e?.inUse
      ]);

  @override
  bool isValidKey(Object? o) => o is FilesRecord;
}
