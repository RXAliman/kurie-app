import 'package:hive_ce/hive.dart';

part 'reading.g.dart';

@HiveType(typeId: 1)
class Reading extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String submeterId;

  @HiveField(2)
  final double value;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(5)
  final double balance;

  Reading({
    required this.id,
    required this.submeterId,
    required this.value,
    required this.timestamp,
    this.balance = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'submeterId': submeterId,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
      'balance': balance,
    };
  }

  factory Reading.fromMap(Map<String, dynamic> map) {
    return Reading(
      id: map['id'] ?? '',
      submeterId: map['submeterId'] ?? '',
      value: (map['value'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      balance: (map['balance'] ?? 0.0).toDouble(),
    );
  }
}
