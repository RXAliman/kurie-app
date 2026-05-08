import 'package:hive_ce/hive.dart';

part 'dispute.g.dart';

@HiveType(typeId: 4)
class Dispute extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String submeterId;

  @HiveField(2)
  final String tenantName;

  @HiveField(3)
  final String billCycle;

  @HiveField(4)
  final double amount;

  @HiveField(5)
  final double usage;

  @HiveField(6)
  final String status; // 'Pending', 'Resolved'

  @HiveField(7)
  final DateTime timestamp;

  Dispute({
    required this.id,
    required this.submeterId,
    required this.tenantName,
    required this.billCycle,
    required this.amount,
    required this.usage,
    required this.status,
    required this.timestamp,
  });
}
