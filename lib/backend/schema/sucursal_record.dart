import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SucursalRecord extends FirestoreRecord {
  SucursalRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "manager" field.
  String? _manager;
  String get manager => _manager ?? '';
  bool hasManager() => _manager != null;

  // "manager_phone" field.
  String? _managerPhone;
  String get managerPhone => _managerPhone ?? '';
  bool hasManagerPhone() => _managerPhone != null;

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

  // "id_manual" field.
  String? _idManual;
  String get idManual => _idManual ?? '';
  bool hasIdManual() => _idManual != null;

  // "clientRef" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  bool hasClientRef() => _clientRef != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "password_manual" field.
  String? _passwordManual;
  String get passwordManual => _passwordManual ?? '';
  bool hasPasswordManual() => _passwordManual != null;

  // "zip" field.
  String? _zip;
  String get zip => _zip ?? '';
  bool hasZip() => _zip != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _manager = snapshotData['manager'] as String?;
    _managerPhone = snapshotData['manager_phone'] as String?;
    _address = snapshotData['address'] as String?;
    _city = snapshotData['city'] as String?;
    _state = snapshotData['state'] as String?;
    _idManual = snapshotData['id_manual'] as String?;
    _clientRef = snapshotData['clientRef'] as DocumentReference?;
    _country = snapshotData['country'] as String?;
    _passwordManual = snapshotData['password_manual'] as String?;
    _zip = snapshotData['zip'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sucursal');

  static Stream<SucursalRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => SucursalRecord.fromSnapshot(s));

  static Future<SucursalRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => SucursalRecord.fromSnapshot(s));

  static SucursalRecord fromSnapshot(DocumentSnapshot snapshot) =>
      SucursalRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static SucursalRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      SucursalRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'SucursalRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is SucursalRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createSucursalRecordData({
  String? name,
  String? manager,
  String? managerPhone,
  String? address,
  String? city,
  String? state,
  String? idManual,
  DocumentReference? clientRef,
  String? country,
  String? passwordManual,
  String? zip,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'manager': manager,
      'manager_phone': managerPhone,
      'address': address,
      'city': city,
      'state': state,
      'id_manual': idManual,
      'clientRef': clientRef,
      'country': country,
      'password_manual': passwordManual,
      'zip': zip,
    }.withoutNulls,
  );

  return firestoreData;
}

class SucursalRecordDocumentEquality implements Equality<SucursalRecord> {
  const SucursalRecordDocumentEquality();

  @override
  bool equals(SucursalRecord? e1, SucursalRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.manager == e2?.manager &&
        e1?.managerPhone == e2?.managerPhone &&
        e1?.address == e2?.address &&
        e1?.city == e2?.city &&
        e1?.state == e2?.state &&
        e1?.idManual == e2?.idManual &&
        e1?.clientRef == e2?.clientRef &&
        e1?.country == e2?.country &&
        e1?.passwordManual == e2?.passwordManual &&
        e1?.zip == e2?.zip;
  }

  @override
  int hash(SucursalRecord? e) => const ListEquality().hash([
        e?.name,
        e?.manager,
        e?.managerPhone,
        e?.address,
        e?.city,
        e?.state,
        e?.idManual,
        e?.clientRef,
        e?.country,
        e?.passwordManual,
        e?.zip
      ]);

  @override
  bool isValidKey(Object? o) => o is SucursalRecord;
}
