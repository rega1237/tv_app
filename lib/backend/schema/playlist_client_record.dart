import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaylistClientRecord extends FirestoreRecord {
  PlaylistClientRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "client_ref" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  bool hasClientRef() => _clientRef != null;

  // "playlist_branch_ref" field.
  List<DocumentReference>? _playlistBranchRef;
  List<DocumentReference> get playlistBranchRef =>
      _playlistBranchRef ?? const [];
  bool hasPlaylistBranchRef() => _playlistBranchRef != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  void _initializeFields() {
    _clientRef = snapshotData['client_ref'] as DocumentReference?;
    _playlistBranchRef = getDataList(snapshotData['playlist_branch_ref']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _name = snapshotData['name'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PlaylistClient');

  static Stream<PlaylistClientRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlaylistClientRecord.fromSnapshot(s));

  static Future<PlaylistClientRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlaylistClientRecord.fromSnapshot(s));

  static PlaylistClientRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlaylistClientRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlaylistClientRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlaylistClientRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlaylistClientRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlaylistClientRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlaylistClientRecordData({
  DocumentReference? clientRef,
  DateTime? createdAt,
  String? name,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'client_ref': clientRef,
      'created_at': createdAt,
      'name': name,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlaylistClientRecordDocumentEquality
    implements Equality<PlaylistClientRecord> {
  const PlaylistClientRecordDocumentEquality();

  @override
  bool equals(PlaylistClientRecord? e1, PlaylistClientRecord? e2) {
    const listEquality = ListEquality();
    return e1?.clientRef == e2?.clientRef &&
        listEquality.equals(e1?.playlistBranchRef, e2?.playlistBranchRef) &&
        e1?.createdAt == e2?.createdAt &&
        e1?.name == e2?.name;
  }

  @override
  int hash(PlaylistClientRecord? e) => const ListEquality()
      .hash([e?.clientRef, e?.playlistBranchRef, e?.createdAt, e?.name]);

  @override
  bool isValidKey(Object? o) => o is PlaylistClientRecord;
}
