import 'package:hive_ce/hive.dart';

part 'notification_item.g.dart';

@HiveType(typeId: 3)
class NotificationItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String type; // e.g., 'billing', 'reading', 'dispute'

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  final bool isUrgent;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.isUrgent = false,
  });
}
