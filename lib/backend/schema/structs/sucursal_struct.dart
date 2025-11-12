// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SucursalStruct extends FFFirebaseStruct {
  SucursalStruct({
    String? name,
    String? manager,
    String? managerPhone,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? idManual,
    DocumentReference? clientRef,
    List<DocumentReference>? subscriptionsRef,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _name = name,
        _manager = manager,
        _managerPhone = managerPhone,
        _address = address,
        _city = city,
        _state = state,
        _zip = zip,
        _country = country,
        _idManual = idManual,
        _clientRef = clientRef,
        _subscriptionsRef = subscriptionsRef,
        super(firestoreUtilData);

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "manager" field.
  String? _manager;
  String get manager => _manager ?? '';
  set manager(String? val) => _manager = val;

  bool hasManager() => _manager != null;

  // "manager_phone" field.
  String? _managerPhone;
  String get managerPhone => _managerPhone ?? '';
  set managerPhone(String? val) => _managerPhone = val;

  bool hasManagerPhone() => _managerPhone != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "zip" field.
  String? _zip;
  String get zip => _zip ?? '';
  set zip(String? val) => _zip = val;

  bool hasZip() => _zip != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "id_manual" field.
  String? _idManual;
  String get idManual => _idManual ?? '';
  set idManual(String? val) => _idManual = val;

  bool hasIdManual() => _idManual != null;

  // "clientRef" field.
  DocumentReference? _clientRef;
  DocumentReference? get clientRef => _clientRef;
  set clientRef(DocumentReference? val) => _clientRef = val;

  bool hasClientRef() => _clientRef != null;

  // "subscriptionsRef" field.
  List<DocumentReference>? _subscriptionsRef;
  List<DocumentReference> get subscriptionsRef => _subscriptionsRef ?? const [];
  set subscriptionsRef(List<DocumentReference>? val) => _subscriptionsRef = val;

  void updateSubscriptionsRef(Function(List<DocumentReference>) updateFn) {
    updateFn(_subscriptionsRef ??= []);
  }

  bool hasSubscriptionsRef() => _subscriptionsRef != null;

  static SucursalStruct fromMap(Map<String, dynamic> data) => SucursalStruct(
        name: data['name'] as String?,
        manager: data['manager'] as String?,
        managerPhone: data['manager_phone'] as String?,
        address: data['address'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        zip: data['zip'] as String?,
        country: data['country'] as String?,
        idManual: data['id_manual'] as String?,
        clientRef: data['clientRef'] as DocumentReference?,
        subscriptionsRef: getDataList(data['subscriptionsRef']),
      );

  static SucursalStruct? maybeFromMap(dynamic data) =>
      data is Map ? SucursalStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'manager': _manager,
        'manager_phone': _managerPhone,
        'address': _address,
        'city': _city,
        'state': _state,
        'zip': _zip,
        'country': _country,
        'id_manual': _idManual,
        'clientRef': _clientRef,
        'subscriptionsRef': _subscriptionsRef,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'manager': serializeParam(
          _manager,
          ParamType.String,
        ),
        'manager_phone': serializeParam(
          _managerPhone,
          ParamType.String,
        ),
        'address': serializeParam(
          _address,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'zip': serializeParam(
          _zip,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'id_manual': serializeParam(
          _idManual,
          ParamType.String,
        ),
        'clientRef': serializeParam(
          _clientRef,
          ParamType.DocumentReference,
        ),
        'subscriptionsRef': serializeParam(
          _subscriptionsRef,
          ParamType.DocumentReference,
          isList: true,
        ),
      }.withoutNulls;

  static SucursalStruct fromSerializableMap(Map<String, dynamic> data) =>
      SucursalStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        manager: deserializeParam(
          data['manager'],
          ParamType.String,
          false,
        ),
        managerPhone: deserializeParam(
          data['manager_phone'],
          ParamType.String,
          false,
        ),
        address: deserializeParam(
          data['address'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        zip: deserializeParam(
          data['zip'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        idManual: deserializeParam(
          data['id_manual'],
          ParamType.String,
          false,
        ),
        clientRef: deserializeParam(
          data['clientRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['clients'],
        ),
        subscriptionsRef: deserializeParam<DocumentReference>(
          data['subscriptionsRef'],
          ParamType.DocumentReference,
          true,
          collectionNamePath: ['subscription'],
        ),
      );

  @override
  String toString() => 'SucursalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SucursalStruct &&
        name == other.name &&
        manager == other.manager &&
        managerPhone == other.managerPhone &&
        address == other.address &&
        city == other.city &&
        state == other.state &&
        zip == other.zip &&
        country == other.country &&
        idManual == other.idManual &&
        clientRef == other.clientRef &&
        listEquality.equals(subscriptionsRef, other.subscriptionsRef);
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        manager,
        managerPhone,
        address,
        city,
        state,
        zip,
        country,
        idManual,
        clientRef,
        subscriptionsRef
      ]);
}

SucursalStruct createSucursalStruct({
  String? name,
  String? manager,
  String? managerPhone,
  String? address,
  String? city,
  String? state,
  String? zip,
  String? country,
  String? idManual,
  DocumentReference? clientRef,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    SucursalStruct(
      name: name,
      manager: manager,
      managerPhone: managerPhone,
      address: address,
      city: city,
      state: state,
      zip: zip,
      country: country,
      idManual: idManual,
      clientRef: clientRef,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

SucursalStruct? updateSucursalStruct(
  SucursalStruct? sucursal, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    sucursal
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addSucursalStructData(
  Map<String, dynamic> firestoreData,
  SucursalStruct? sucursal,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (sucursal == null) {
    return;
  }
  if (sucursal.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && sucursal.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final sucursalData = getSucursalFirestoreData(sucursal, forFieldValue);
  final nestedData = sucursalData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = sucursal.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getSucursalFirestoreData(
  SucursalStruct? sucursal, [
  bool forFieldValue = false,
]) {
  if (sucursal == null) {
    return {};
  }
  final firestoreData = mapToFirestore(sucursal.toMap());

  // Add any Firestore field values
  sucursal.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getSucursalListFirestoreData(
  List<SucursalStruct>? sucursals,
) =>
    sucursals?.map((e) => getSucursalFirestoreData(e, true)).toList() ?? [];
