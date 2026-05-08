import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../models/submeter.dart';
import '../models/reading.dart';
import '../models/bill.dart';
import '../models/notification_item.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String submetersBoxName = 'submeters';
  static const String readingsBoxName = 'readings';
  static const String billsBoxName = 'bills';
  static const String notificationsBoxName = 'notifications';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(SubmeterAdapter());
    Hive.registerAdapter(ReadingAdapter());
    Hive.registerAdapter(BillAdapter());
    Hive.registerAdapter(NotificationItemAdapter());

    // Open Boxes
    await Hive.openBox<Submeter>(submetersBoxName);
    await Hive.openBox<Reading>(readingsBoxName);
    await Hive.openBox<Bill>(billsBoxName);
    await Hive.openBox<NotificationItem>(notificationsBoxName);
    
    // Seed initial data if empty
    await _seedIfEmpty();
  }

  Box<Submeter> get submetersBox => Hive.box<Submeter>(submetersBoxName);
  Box<Reading> get readingsBox => Hive.box<Reading>(readingsBoxName);
  Box<Bill> get billsBox => Hive.box<Bill>(billsBoxName);
  Box<NotificationItem> get notificationsBox => Hive.box<NotificationItem>(notificationsBoxName);

  Future<void> _seedIfEmpty() async {
    if (submetersBox.isEmpty) {
      await submetersBox.addAll([
        Submeter(id: '1', name: 'Unit 4A', unit: 'Main Floor', tenantId: 't1', lastReading: '1,240', status: 'Active'),
        Submeter(id: '2', name: 'Unit 4B', unit: 'Upper Floor', tenantId: 't2', lastReading: '892', status: 'Active'),
        Submeter(id: '3', name: 'Unit 4C', unit: 'Basement', tenantId: 't3', lastReading: '450', status: 'Inactive'),
      ]);
    }

    if (notificationsBox.isEmpty) {
      final now = DateTime.now();
      await notificationsBox.addAll([
        NotificationItem(
          id: 'n1',
          title: 'Urgent: Disputed Reading',
          description: 'Alice Johnson (Unit 4B) flagged Oct reading.',
          type: 'dispute',
          timestamp: now.subtract(const Duration(minutes: 15)),
          isUrgent: true,
        ),
        NotificationItem(
          id: 'n2',
          title: 'System Update',
          description: 'Tiered rates updated for Nov cycle.',
          type: 'billing',
          timestamp: now.subtract(const Duration(hours: 2)),
          isRead: true,
        ),
      ]);
    }
  }

  // Helper methods
  List<Submeter> getAllSubmeters() => submetersBox.values.toList();
  List<NotificationItem> getAllNotifications() => notificationsBox.values.toList();
  
  Future<void> addSubmeter(Submeter submeter) async {
    await submetersBox.add(submeter);
  }

  Future<void> addNotification(NotificationItem notification) async {
    await notificationsBox.add(notification);
  }
}
