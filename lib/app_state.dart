import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _loggedSucursal =
          prefs.getString('ff_loggedSucursal')?.ref ?? _loggedSucursal;
      _rotationAngle = prefs.getDouble('ff_rotationAngle') ?? _rotationAngle;
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
    prefs.setDouble('ff_rotationAngle', value);
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
