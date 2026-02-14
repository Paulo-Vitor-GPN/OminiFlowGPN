import 'package:flutter/material.dart';

enum AppointmentStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class Appointment {
  final String id;
  final String customerName;
  final String serviceName;
  final DateTime dateTime;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.dateTime,
    this.status = AppointmentStatus.pending,
  });

  Appointment copyWith({
    String? id,
    String? customerName,
    String? serviceName,
    DateTime? dateTime,
    AppointmentStatus? status,
  }) {
    return Appointment(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      serviceName: serviceName ?? this.serviceName,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}
