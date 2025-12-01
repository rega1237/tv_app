import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  // El método initializePersistedState es el correcto para cargar datos.
  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _loggedSucursal =
          prefs.getString('ff_loggedSucursal')?.ref ?? _loggedSucursal;
      _rotationAngle = prefs.getDouble('ff_rotationAngle') ?? _rotationAngle;
      
      // --- LÓGICA DE CARGA AÑADIDA AQUÍ ---
      final lastChannelPath = prefs.getString('ff_lastChannelRef');
      if (lastChannelPath != null && lastChannelPath.isNotEmpty) {
        _lastChannelRef = FirebaseFirestore.instance.doc(lastChannelPath);
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  DocumentReference? _loggedSucursal;
  DocumentReference? get loggedSucursal => _loggedSucursal;
  set loggedSucursal(DocumentReference? value) {
    _loggedSucursal = value;
    value != null
        ? prefs.setString('ff_loggedSucursal', value.path)
        : prefs.remove('ff_loggedSucursal');
  }

  double _rotationAngle = 0.0;
  double get rotationAngle => _rotationAngle;
  set rotationAngle(double value) {
    _rotationAngle = value;
    // --- CORREGIDO para usar 'prefs' ---
    prefs.setDouble('ff_rotationAngle', value);
  }

  DocumentReference? _lastChannelRef;
  DocumentReference? get lastChannelRef => _lastChannelRef;
  set lastChannelRef(DocumentReference? value) {
    _lastChannelRef = value;
    // --- CORREGIDO para usar 'prefs' ---
    if (value != null) {
      prefs.setString('ff_lastChannelRef', value.path);
    } else {
      prefs.remove('ff_lastChannelRef');
    }
  }

  bool _isSubscriptionActive = true;
  bool get isSubscriptionActive => _isSubscriptionActive;
  set isSubscriptionActive(bool value) {
    _isSubscriptionActive = value;
    notifyListeners();
  }

  List<dynamic> _channelsData = [];
  List<dynamic> get channelsData => _channelsData;
  set channelsData(List<dynamic> value) {
    _channelsData = value;
  }

  void addToChannelsData(dynamic value) {
    channelsData.add(value);
  }

  void removeFromChannelsData(dynamic value) {
    channelsData.remove(value);
  }

  void removeAtIndexFromChannelsData(int index) {
    channelsData.removeAt(index);
  }

  void updateChannelsDataAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    channelsData[index] = updateFn(_channelsData[index]);
  }

  void insertAtIndexInChannelsData(int index, dynamic value) {
    channelsData.insert(index, value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}