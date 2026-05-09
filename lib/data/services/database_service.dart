import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../models/submeter.dart';
import '../models/reading.dart';
import '../models/bill.dart';
import '../models/notification_item.dart';

import '../models/dispute.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String submetersBoxName = 'submeters';
  static const String readingsBoxName = 'readings';
  static const String billsBoxName = 'bills';
  static const String notificationsBoxName = 'notifications';
  static const String disputesBoxName = 'disputes';

  Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(SubmeterAdapter());
    Hive.registerAdapter(ReadingAdapter());
    Hive.registerAdapter(BillAdapter());
    Hive.registerAdapter(NotificationItemAdapter());
    Hive.registerAdapter(DisputeAdapter());

    // Open Boxes
    await Hive.openBox<Submeter>(submetersBoxName);
    await Hive.openBox<Reading>(readingsBoxName);
    await Hive.openBox<Bill>(billsBoxName);
    await Hive.openBox<NotificationItem>(notificationsBoxName);
    await Hive.openBox<Dispute>(disputesBoxName);
  }

  Box<Submeter> get submetersBox => Hive.box<Submeter>(submetersBoxName);
  Box<Reading> get readingsBox => Hive.box<Reading>(readingsBoxName);
  Box<Bill> get billsBox => Hive.box<Bill>(billsBoxName);
  Box<NotificationItem> get notificationsBox =>
      Hive.box<NotificationItem>(notificationsBoxName);
  Box<Dispute> get disputesBox => Hive.box<Dispute>(disputesBoxName);

  Future<void> clearAllData() async {
    await submetersBox.clear();
    await readingsBox.clear();
    await billsBox.clear();
    await notificationsBox.clear();
    await disputesBox.clear();
  }

  // Helper methods
  List<Submeter> getAllSubmeters() => submetersBox.values.toList();
  List<NotificationItem> getAllNotifications() =>
      notificationsBox.values.toList();
  List<Reading> getAllReadings() => readingsBox.values.toList();
  List<Dispute> getAllDisputes() => disputesBox.values.toList();
  List<Bill> getAllBills() => billsBox.values.toList();

  Future<void> addSubmeter(Submeter submeter) async {
    await submetersBox.put(submeter.id, submeter);
  }

  Future<void> updateSubmeter(Submeter submeter) async {
    await submetersBox.put(submeter.id, submeter);
  }

  Future<void> addReading(Reading reading) async {
    await readingsBox.put(reading.id, reading);
  }

  Future<void> addNotification(NotificationItem notification) async {
    await notificationsBox.add(notification);
  }

  Future<void> markNotificationAsRead(String id) async {
    final index = notificationsBox.values.toList().indexWhere(
      (n) => n.id == id,
    );
    if (index != -1) {
      final notification = notificationsBox.getAt(index);
      if (notification != null) {
        notification.isRead = true;
        await notification.save();
      }
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    for (var i = 0; i < notificationsBox.length; i++) {
      final notification = notificationsBox.getAt(i);
      if (notification != null && !notification.isRead) {
        notification.isRead = true;
        await notification.save();
      }
    }
  }

  Future<void> addDispute(Dispute dispute) async {
    await disputesBox.put(dispute.id, dispute);
  }

  Future<void> addBill(Bill bill) async {
    await billsBox.put(bill.id, bill);
  }
}
