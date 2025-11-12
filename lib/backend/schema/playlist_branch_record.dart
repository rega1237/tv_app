import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaylistBranchRecord extends FirestoreRecord {
  PlaylistBranchRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "playlist_ref" field.
  List<DocumentReference>? _playlistRef;
  List<DocumentReference> get playlistRef => _playlistRef ?? const [];
  bool hasPlaylistRef() => _playlistRef != null;

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
    _playlistRef = getDataList(snapshotData['playlist_ref']);
    _name = snapshotData['name'] as String?;
    _clientRef = snapshotData['client_ref'] as DocumentReference?;
    _branchRef = snapshotData['branch_ref'] as DocumentReference?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('PlaylistBranch');

  static Stream<PlaylistBranchRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlaylistBranchRecord.fromSnapshot(s));

  static Future<PlaylistBranchRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlaylistBranchRecord.fromSnapshot(s));

  static PlaylistBranchRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlaylistBranchRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlaylistBranchRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlaylistBranchRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlaylistBranchRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlaylistBranchRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlaylistBranchRecordData({
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

class PlaylistBranchRecordDocumentEquality
    implements Equality<PlaylistBranchRecord> {
  const PlaylistBranchRecordDocumentEquality();

  @override
  bool equals(PlaylistBranchRecord? e1, PlaylistBranchRecord? e2) {
    const listEquality = ListEquality();
    return listEquality.equals(e1?.playlistRef, e2?.playlistRef) &&
        e1?.name == e2?.name &&
        e1?.clientRef == e2?.clientRef &&
        e1?.branchRef == e2?.branchRef;
  }

  @override
  int hash(PlaylistBranchRecord? e) => const ListEquality()
      .hash([e?.playlistRef, e?.name, e?.clientRef, e?.branchRef]);

  @override
  bool isValidKey(Object? o) => o is PlaylistBranchRecord;
}
