import 'package:hive_ce/hive.dart';

part 'bill.g.dart';

@HiveType(typeId: 2)
class Bill extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String submeterId;

  @HiveField(2)
  final String month;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final double kwh;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final double? previousReading;

  @HiveField(8)
  final double? currentReading;

  @HiveField(9)
  final double balance;

  Bill({
    required this.id,
    required this.submeterId,
    required this.month,
    required this.amount,
    required this.kwh,
    required this.status,
    required this.timestamp,
    this.previousReading,
    this.currentReading,
    this.balance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'submeterId': submeterId,
      'month': month,
      'amount': amount,
      'kwh': kwh,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'previousReading': previousReading,
      'currentReading': currentReading,
      'balance': balance,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'] ?? '',
      submeterId: map['submeterId'] ?? '',
      month: map['month'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      kwh: (map['kwh'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Pending',
      timestamp: DateTime.parse(map['timestamp']),
      previousReading: (map['previousReading'] as num?)?.toDouble(),
      currentReading: (map['currentReading'] as num?)?.toDouble(),
      balance: (map['balance'] ?? 0.0).toDouble(),
    );
  }
}
