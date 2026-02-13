
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
