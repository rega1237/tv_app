import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChannelsRecord extends FirestoreRecord {
  ChannelsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "playlist_ref" field.
  List<DocumentReference>? _playlistRef;
  List<DocumentReference> get playlistRef => _playlistRef ?? const [];
  bool hasPlaylistRef() => _playlistRef != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  // "vertical" field.
  bool? _vertical;
  bool get vertical => _vertical ?? false;
  bool hasVertical() => _vertical != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _playlistRef = getDataList(snapshotData['playlist_ref']);
    _createdAt = snapshotData['created_at'] as DateTime?;
    _vertical = snapshotData['vertical'] as bool?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('channels')
          : FirebaseFirestore.instance.collectionGroup('channels');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('channels').doc(id);

  static Stream<ChannelsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ChannelsRecord.fromSnapshot(s));

  static Future<ChannelsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ChannelsRecord.fromSnapshot(s));

  static ChannelsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ChannelsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ChannelsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ChannelsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ChannelsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ChannelsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createChannelsRecordData({
  String? name,
  DateTime? createdAt,
  bool? vertical,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'created_at': createdAt,
      'vertical': vertical,
    }.withoutNulls,
  );

  return firestoreData;
}

class ChannelsRecordDocumentEquality implements Equality<ChannelsRecord> {
  const ChannelsRecordDocumentEquality();

  @override
  bool equals(ChannelsRecord? e1, ChannelsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        listEquality.equals(e1?.playlistRef, e2?.playlistRef) &&
        e1?.createdAt == e2?.createdAt &&
        e1?.vertical == e2?.vertical;
  }

  @override
  int hash(ChannelsRecord? e) => const ListEquality()
      .hash([e?.name, e?.playlistRef, e?.createdAt, e?.vertical]);

  @override
  bool isValidKey(Object? o) => o is ChannelsRecord;
}
