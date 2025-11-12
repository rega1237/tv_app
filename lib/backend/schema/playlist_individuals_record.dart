import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaylistIndividualsRecord extends FirestoreRecord {
  PlaylistIndividualsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "startHour" field.
  int? _startHour;
  int get startHour => _startHour ?? 0;
  bool hasStartHour() => _startHour != null;

  // "endHour" field.
  int? _endHour;
  int get endHour => _endHour ?? 0;
  bool hasEndHour() => _endHour != null;

  // "filesRefs" field.
  List<DocumentReference>? _filesRefs;
  List<DocumentReference> get filesRefs => _filesRefs ?? const [];
  bool hasFilesRefs() => _filesRefs != null;

  // "activeDays" field.
  List<int>? _activeDays;
  List<int> get activeDays => _activeDays ?? const [];
  bool hasActiveDays() => _activeDays != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _startHour = castToType<int>(snapshotData['startHour']);
    _endHour = castToType<int>(snapshotData['endHour']);
    _filesRefs = getDataList(snapshotData['filesRefs']);
    _activeDays = getDataList(snapshotData['activeDays']);
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('playlistIndividuals')
          : FirebaseFirestore.instance.collectionGroup('playlistIndividuals');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('playlistIndividuals').doc(id);

  static Stream<PlaylistIndividualsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlaylistIndividualsRecord.fromSnapshot(s));

  static Future<PlaylistIndividualsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PlaylistIndividualsRecord.fromSnapshot(s));

  static PlaylistIndividualsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlaylistIndividualsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlaylistIndividualsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlaylistIndividualsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlaylistIndividualsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlaylistIndividualsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlaylistIndividualsRecordData({
  String? name,
  int? startHour,
  int? endHour,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'startHour': startHour,
      'endHour': endHour,
    }.withoutNulls,
  );

  return firestoreData;
}

class PlaylistIndividualsRecordDocumentEquality
    implements Equality<PlaylistIndividualsRecord> {
  const PlaylistIndividualsRecordDocumentEquality();

  @override
  bool equals(PlaylistIndividualsRecord? e1, PlaylistIndividualsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.startHour == e2?.startHour &&
        e1?.endHour == e2?.endHour &&
        listEquality.equals(e1?.filesRefs, e2?.filesRefs) &&
        listEquality.equals(e1?.activeDays, e2?.activeDays);
  }

  @override
  int hash(PlaylistIndividualsRecord? e) => const ListEquality()
      .hash([e?.name, e?.startHour, e?.endHour, e?.filesRefs, e?.activeDays]);

  @override
  bool isValidKey(Object? o) => o is PlaylistIndividualsRecord;
}
