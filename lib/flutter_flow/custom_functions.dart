import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/custom_auth/auth_util.dart';

DocumentReference stringToSucursalRef(String sucursalId) {
  // Construye y devuelve la DocumentReference
  return FirebaseFirestore.instance.doc('sucursal/$sucursalId');
}

int? daysUntilSubscriptionEnds(DateTime endDate) {
  // Obtiene la fecha y hora actual del dispositivo.
  final DateTime now = DateTime.now();

  // Calcula la diferencia entre la fecha final y la fecha actual.
  final Duration difference = endDate.difference(now);

  // Si la diferencia es negativa (la fecha ya pasó), devuelve 0.
  if (difference.isNegative) {
    return 0;
  }

  // Devuelve la diferencia total en días.
  return difference.inDays;
}
