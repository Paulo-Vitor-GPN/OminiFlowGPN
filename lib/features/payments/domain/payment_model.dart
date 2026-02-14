import 'package:flutter/material.dart';

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

enum PaymentMethod {
  pix,
  creditCard,
  subscription,
}

class Payment {
  final String id;
  final String description;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final DateTime date;

  Payment({
    required this.id,
    required this.description,
    required this.amount,
    required this.method,
    this.status = PaymentStatus.pending,
    required this.date,
  });

  Payment copyWith({
    String? id,
    String? description,
    double? amount,
    PaymentMethod? method,
    PaymentStatus? status,
    DateTime? date,
  }) {
    return Payment(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}

class Subscription {
  final String id;
  final String planName;
  final double amount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;

  Subscription({
    required this.id,
    required this.planName,
    required this.amount,
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  Subscription copyWith({
    String? id,
    String? planName,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return Subscription(
      id: id ?? this.id,
      planName: planName ?? this.planName,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
