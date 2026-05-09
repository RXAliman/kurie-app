import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/submeter.dart';
import '../models/reading.dart';
import '../models/notification_item.dart';
import '../services/database_service.dart';
import '../models/dispute.dart';
import '../models/bill.dart';

class AppRepository extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();

  List<Submeter> _submeters = [];
  List<NotificationItem> _notifications = [];
  List<Reading> _readings = [];
  List<Dispute> _disputes = [];
  List<Bill> _bills = [];

  List<Submeter> get submeters => _submeters;
  List<NotificationItem> get notifications => _notifications;
  List<Reading> get readings => _readings;
  List<Dispute> get disputes => _disputes;
  List<Bill> get bills => _bills;

  Future<void> init() async {
    await _db.init();
    _loadData();
  }

  void _loadData() {
    _submeters = _db.getAllSubmeters();
    _notifications = _db.getAllNotifications();
    _readings = _db.getAllReadings();
    _disputes = _db.getAllDisputes();
    _bills = _db.getAllBills();
    notifyListeners();
  }

  Future<void> addSubmeter(Submeter submeter) async {
    await _db.addSubmeter(submeter);
    _loadData();
  }

  Future<void> updateSubmeter(Submeter submeter) async {
    await _db.updateSubmeter(submeter);
    _loadData();
  }

  Future<void> addReading(Reading reading) async {
    // Get the previous reading for this submeter before adding the new one
    final meterReadings = _readings.where((r) => r.submeterId == reading.submeterId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    await _db.addReading(reading);
    
    // If there was a previous reading, generate a Bill
    if (meterReadings.isNotEmpty) {
      final prev = meterReadings.first;
      final usage = reading.value - prev.value;
      
      if (usage > 0) {
        final bill = Bill(
          id: 'BILL-${DateTime.now().millisecondsSinceEpoch}',
          submeterId: reading.submeterId,
          month: DateFormat('MMMM yyyy').format(reading.timestamp),
          amount: usage * 12.0, // Default rate
          kwh: usage,
          status: 'Pending',
          timestamp: DateTime.now(),
          previousReading: prev.value,
          currentReading: reading.value,
        );
        await _db.addBill(bill);
      }
    }
    
    // Update the submeter's last reading
    final submeterIndex = _submeters.indexWhere((s) => s.id == reading.submeterId);
    if (submeterIndex != -1) {
      final submeter = _submeters[submeterIndex];
      final updatedSubmeter = Submeter(
        id: submeter.id,
        name: submeter.name,
        unit: submeter.unit,
        tenantId: submeter.tenantId,
        lastReading: reading.value.toStringAsFixed(2),
        status: submeter.status,
      );
      await _db.updateSubmeter(updatedSubmeter);
    }
    
    _loadData();
  }

  Future<void> addNotification(NotificationItem notification) async {
    await _db.addNotification(notification);
    _loadData();
  }

  Future<void> addBill(Bill bill) async {
    await _db.addBill(bill);
    _loadData();
  }

  Future<void> markNotificationAsRead(String id) async {
    await _db.markNotificationAsRead(id);
    _loadData();
  }

  Future<void> markAllNotificationsAsRead() async {
    await _db.markAllNotificationsAsRead();
    _loadData();
  }

  Future<void> clearAllData() async {
    await _db.clearAllData();
    _loadData();
  }

  // Refresh data explicitly if needed
  void refresh() {
    _loadData();
  }
}
