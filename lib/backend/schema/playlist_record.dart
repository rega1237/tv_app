import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PlaylistRecord extends FirestoreRecord {
  PlaylistRecord._(
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

  // "sucursal_ref" field.
  DocumentReference? _sucursalRef;
  DocumentReference? get sucursalRef => _sucursalRef;
  bool hasSucursalRef() => _sucursalRef != null;

  // "is_in_channel" field.
  bool? _isInChannel;
  bool get isInChannel => _isInChannel ?? false;
  bool hasIsInChannel() => _isInChannel != null;

  // "created_by" field.
  DocumentReference? _createdBy;
  DocumentReference? get createdBy => _createdBy;
  bool hasCreatedBy() => _createdBy != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "schedule" field.
  ScheduleStruct? _schedule;
  ScheduleStruct get schedule => _schedule ?? ScheduleStruct();
  bool hasSchedule() => _schedule != null;

  // "playlist_branch_ref" field.
  DocumentReference? _playlistBranchRef;
  DocumentReference? get playlistBranchRef => _playlistBranchRef;
  bool hasPlaylistBranchRef() => _playlistBranchRef != null;

  // "is_schedule" field.
  bool? _isSchedule;
  bool get isSchedule => _isSchedule ?? false;
  bool hasIsSchedule() => _isSchedule != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _clientRef = snapshotData['client_ref'] as DocumentReference?;
    _sucursalRef = snapshotData['sucursal_ref'] as DocumentReference?;
    _isInChannel = snapshotData['is_in_channel'] as bool?;
    _createdBy = snapshotData['created_by'] as DocumentReference?;
    _createdAt = snapshotData['created_at'] as DateTime?;
    _schedule = snapshotData['schedule'] is ScheduleStruct
        ? snapshotData['schedule']
        : ScheduleStruct.maybeFromMap(snapshotData['schedule']);
    _playlistBranchRef =
        snapshotData['playlist_branch_ref'] as DocumentReference?;
    _isSchedule = snapshotData['is_schedule'] as bool?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Playlist');

  static Stream<PlaylistRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PlaylistRecord.fromSnapshot(s));

  static Future<PlaylistRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PlaylistRecord.fromSnapshot(s));

  static PlaylistRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PlaylistRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PlaylistRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PlaylistRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PlaylistRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PlaylistRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPlaylistRecordData({
  String? name,
  DocumentReference? clientRef,
  DocumentReference? sucursalRef,
  bool? isInChannel,
  DocumentReference? createdBy,
  DateTime? createdAt,
  ScheduleStruct? schedule,
  DocumentReference? playlistBranchRef,
  bool? isSchedule,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'client_ref': clientRef,
      'sucursal_ref': sucursalRef,
      'is_in_channel': isInChannel,
      'created_by': createdBy,
      'created_at': createdAt,
      'schedule': ScheduleStruct().toMap(),
      'playlist_branch_ref': playlistBranchRef,
      'is_schedule': isSchedule,
    }.withoutNulls,
  );

  // Handle nested data for "schedule" field.
  addScheduleStructData(firestoreData, schedule, 'schedule');

  return firestoreData;
}

class PlaylistRecordDocumentEquality implements Equality<PlaylistRecord> {
  const PlaylistRecordDocumentEquality();

  @override
  bool equals(PlaylistRecord? e1, PlaylistRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.clientRef == e2?.clientRef &&
        e1?.sucursalRef == e2?.sucursalRef &&
        e1?.isInChannel == e2?.isInChannel &&
        e1?.createdBy == e2?.createdBy &&
        e1?.createdAt == e2?.createdAt &&
        e1?.schedule == e2?.schedule &&
        e1?.playlistBranchRef == e2?.playlistBranchRef &&
        e1?.isSchedule == e2?.isSchedule;
  }

  @override
  int hash(PlaylistRecord? e) => const ListEquality().hash([
        e?.name,
        e?.clientRef,
        e?.sucursalRef,
        e?.isInChannel,
        e?.createdBy,
        e?.createdAt,
        e?.schedule,
        e?.playlistBranchRef,
        e?.isSchedule
      ]);

  @override
  bool isValidKey(Object? o) => o is PlaylistRecord;
}
