import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ClientsRecord extends FirestoreRecord {
  ClientsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "bussiness_type" field.
  String? _bussinessType;
  String get bussinessType => _bussinessType ?? '';
  bool hasBussinessType() => _bussinessType != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  bool hasState() => _state != null;

  // "zip" field.
  int? _zip;
  int get zip => _zip ?? 0;
  bool hasZip() => _zip != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "phone_1" field.
  String? _phone1;
  String get phone1 => _phone1 ?? '';
  bool hasPhone1() => _phone1 != null;

  // "phone_2" field.
  String? _phone2;
  String get phone2 => _phone2 ?? '';
  bool hasPhone2() => _phone2 != null;

  // "notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  bool hasNotes() => _notes != null;

  // "photo" field.
  String? _photo;
  String get photo => _photo ?? '';
  bool hasPhoto() => _photo != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _bussinessType = snapshotData['bussiness_type'] as String?;
    _address = snapshotData['address'] as String?;
    _city = snapshotData['city'] as String?;
    _state = snapshotData['state'] as String?;
    _zip = castToType<int>(snapshotData['zip']);
    _email = snapshotData['email'] as String?;
    _phone1 = snapshotData['phone_1'] as String?;
    _phone2 = snapshotData['phone_2'] as String?;
    _notes = snapshotData['notes'] as String?;
    _photo = snapshotData['photo'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('clients');

  static Stream<ClientsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ClientsRecord.fromSnapshot(s));

  static Future<ClientsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ClientsRecord.fromSnapshot(s));

  static ClientsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ClientsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ClientsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ClientsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ClientsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ClientsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createClientsRecordData({
  String? name,
  String? bussinessType,
  String? address,
  String? city,
  String? state,
  int? zip,
  String? email,
  String? phone1,
  String? phone2,
  String? notes,
  String? photo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'bussiness_type': bussinessType,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'email': email,
      'phone_1': phone1,
      'phone_2': phone2,
      'notes': notes,
      'photo': photo,
    }.withoutNulls,
  );

  return firestoreData;
}

class ClientsRecordDocumentEquality implements Equality<ClientsRecord> {
  const ClientsRecordDocumentEquality();

  @override
  bool equals(ClientsRecord? e1, ClientsRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.bussinessType == e2?.bussinessType &&
        e1?.address == e2?.address &&
        e1?.city == e2?.city &&
        e1?.state == e2?.state &&
        e1?.zip == e2?.zip &&
        e1?.email == e2?.email &&
        e1?.phone1 == e2?.phone1 &&
        e1?.phone2 == e2?.phone2 &&
        e1?.notes == e2?.notes &&
        e1?.photo == e2?.photo;
  }

  @override
  int hash(ClientsRecord? e) => const ListEquality().hash([
        e?.name,
        e?.bussinessType,
        e?.address,
        e?.city,
        e?.state,
        e?.zip,
        e?.email,
        e?.phone1,
        e?.phone2,
        e?.notes,
        e?.photo
      ]);

  @override
  bool isValidKey(Object? o) => o is ClientsRecord;
}
