import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/submeter.dart';
import '../models/reading.dart';
import '../models/notification_item.dart';
import '../services/database_service.dart';
import '../models/bill.dart';
import '../services/notification_service.dart';
import '../services/firestore_sync_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SyncStatus { offline, syncing, synced }

class AppRepository extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final FirestoreSyncService _sync = FirestoreSyncService();

  List<Submeter> _submeters = [];
  List<NotificationItem> _notifications = [];
  List<Reading> _readings = [];
  List<Bill> _bills = [];

  // Billing Configuration
  double _totalBill = 4500;
  double _masterUsage = 390;
  double _baseFee = 300;
  bool _splitBaseFeeEqually = true;
  bool _useProRata = true;
  double _flatRate = 12.0;

  bool _readingRemindersEnabled = true;
  String _reminderFrequency = 'Monthly';
  int _reminderDay = 1;

  ThemeMode _themeMode = ThemeMode.system;
  DateTime? _lastSynced;
  SyncStatus _syncStatus = SyncStatus.synced;

  List<Submeter> get submeters => _submeters;
  List<NotificationItem> get notifications => _notifications;
  List<Reading> get readings => _readings;
  List<Bill> get bills => _bills;
  ThemeMode get themeMode => _themeMode;
  DateTime? get lastSynced => _lastSynced;
  SyncStatus get syncStatus => _syncStatus;

  double get totalBill => _totalBill;
  double get masterUsage => _masterUsage;
  double get baseFee => _baseFee;
  bool get splitBaseFeeEqually => _splitBaseFeeEqually;
  bool get useProRata => _useProRata;
  double get flatRate => _flatRate;
  bool get readingRemindersEnabled => _readingRemindersEnabled;
  String get reminderFrequency => _reminderFrequency;
  int get reminderDay => _reminderDay;

  double get currentRate {
    if (!_useProRata) return _flatRate;
    if (_masterUsage == 0) return 12.0;
    return (_totalBill - (_splitBaseFeeEqually ? 0 : _baseFee)) / _masterUsage;
  }

  Future<void> init() async {
    await _db.init();
    _loadData();
    // Try to sync with cloud if logged in
    if (FirebaseAuth.instance.currentUser != null) {
      await syncWithCloud();
    }
  }

  Future<void> syncWithCloud() async {
    if (FirebaseAuth.instance.currentUser == null) {
      _syncStatus = SyncStatus.offline;
      notifyListeners();
      return;
    }

    _syncStatus = SyncStatus.syncing;
    notifyListeners();

    try {
      // 1. Sync Settings
      final cloudSettings = await _sync.getSettings();
      if (cloudSettings != null) {
        if (cloudSettings.containsKey('totalBill')) {
          await _db.settingsBox.put('totalBill', cloudSettings['totalBill']);
        }
        if (cloudSettings.containsKey('masterUsage')) {
          await _db.settingsBox.put(
            'masterUsage',
            cloudSettings['masterUsage'],
          );
        }
        if (cloudSettings.containsKey('baseFee')) {
          await _db.settingsBox.put('baseFee', cloudSettings['baseFee']);
        }
        if (cloudSettings.containsKey('splitBaseFeeEqually')) {
          await _db.settingsBox.put(
            'splitBaseFeeEqually',
            cloudSettings['splitBaseFeeEqually'],
          );
        }
        if (cloudSettings.containsKey('useProRata')) {
          await _db.settingsBox.put('useProRata', cloudSettings['useProRata']);
        }
        if (cloudSettings.containsKey('flatRate')) {
          await _db.settingsBox.put('flatRate', cloudSettings['flatRate']);
        }
        if (cloudSettings.containsKey('readingRemindersEnabled')) {
          await _db.settingsBox.put(
            'readingRemindersEnabled',
            cloudSettings['readingRemindersEnabled'],
          );
        }
        if (cloudSettings.containsKey('reminderFrequency')) {
          await _db.settingsBox.put(
            'reminderFrequency',
            cloudSettings['reminderFrequency'],
          );
        }
        if (cloudSettings.containsKey('reminderDay')) {
          await _db.settingsBox.put(
            'reminderDay',
            cloudSettings['reminderDay'],
          );
        }
        if (cloudSettings.containsKey('theme')) {
          await _db.settingsBox.put('theme', cloudSettings['theme']);
        }
      }

      // 2. Sync Collections
      final cloudData = await _sync.fetchAllData();
      if (cloudData.isNotEmpty) {
        for (final item in cloudData['submeters'] as List<Submeter>) {
          await _db.addSubmeter(item);
        }
        for (final item in cloudData['readings'] as List<Reading>) {
          await _db.addReading(item);
        }
        for (final item in cloudData['bills'] as List<Bill>) {
          await _db.addBill(item);
        }
        for (final item
            in cloudData['notifications'] as List<NotificationItem>) {
          await _db.addNotification(item);
        }
      }

      _loadData();
      _syncStatus = SyncStatus.synced;
      _lastSynced = DateTime.now();
      notifyListeners();
    } catch (e) {
      debugPrint('Sync failed: $e');
      _syncStatus = SyncStatus.offline;
      notifyListeners();
    }
  }

   Future<void> uploadLocalData() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    
    try {
      // 1. Sync Settings
      final settingsPromise = _sync.saveSettings({
        'totalBill': _totalBill,
        'masterUsage': _masterUsage,
        'baseFee': _baseFee,
        'splitBaseFeeEqually': _splitBaseFeeEqually,
        'useProRata': _useProRata,
        'flatRate': _flatRate,
        'readingRemindersEnabled': _readingRemindersEnabled,
        'reminderFrequency': _reminderFrequency,
        'reminderDay': _reminderDay,
        'theme': _themeMode == ThemeMode.light
            ? 'Light'
            : (_themeMode == ThemeMode.dark ? 'Dark' : 'System'),
      });

      // 2. Sync Collections in parallel batches
      final submeterPromises = _submeters.map((item) => _sync.saveSubmeter(item));
      final readingPromises = _readings.map((item) => _sync.saveReading(item));
      final billPromises = _bills.map((item) => _sync.saveBill(item));
      final notificationPromises = _notifications.map((item) => _sync.saveNotification(item));

      await Future.wait([
        settingsPromise,
        ...submeterPromises,
        ...readingPromises,
        ...billPromises,
        ...notificationPromises,
      ]);
    } catch (e) {
      debugPrint('Upload failed: $e');
      rethrow;
    }
  }

  Future<void> performManualSync() async {
    _syncStatus = SyncStatus.syncing;
    notifyListeners();
    
    try {
      await uploadLocalData();
      await syncWithCloud();
    } catch (e) {
      _syncStatus = SyncStatus.offline;
      notifyListeners();
    }
  }

  void _loadData() {
    _submeters = _db.getAllSubmeters();
    _notifications = _db.getAllNotifications();
    _readings = _db.getAllReadings();
    _bills = _db.getAllBills();

    _totalBill = _db.settingsBox.get('totalBill', defaultValue: 4500.0);
    _masterUsage = _db.settingsBox.get('masterUsage', defaultValue: 390.0);
    _baseFee = _db.settingsBox.get('baseFee', defaultValue: 300.0);
    _splitBaseFeeEqually = _db.settingsBox.get(
      'splitBaseFeeEqually',
      defaultValue: true,
    );
    _useProRata = _db.settingsBox.get('useProRata', defaultValue: true);
    _flatRate = _db.settingsBox.get('flatRate', defaultValue: 12.0);
    _readingRemindersEnabled = _db.settingsBox.get(
      'readingRemindersEnabled',
      defaultValue: true,
    );
    _reminderFrequency = _db.settingsBox.get(
      'reminderFrequency',
      defaultValue: 'Monthly',
    );
    _reminderDay = _db.settingsBox.get('reminderDay', defaultValue: 1);

    final themeStr = _db.settingsBox.get('theme', defaultValue: 'System');
    _themeMode = _parseThemeMode(themeStr);

    notifyListeners();
  }

  ThemeMode _parseThemeMode(String themeStr) {
    switch (themeStr) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(String themeStr) async {
    await _db.settingsBox.put('theme', themeStr);
    _themeMode = _parseThemeMode(themeStr);

    // Sync to Firestore
    await _sync.saveSettings({'theme': themeStr});

    notifyListeners();
  }

  Future<void> addSubmeter(Submeter submeter) async {
    await _db.addSubmeter(submeter);
    await _sync.saveSubmeter(submeter);
    _loadData();
  }

  Future<void> updateSubmeter(Submeter submeter) async {
    await _db.updateSubmeter(submeter);
    await _sync.saveSubmeter(submeter);
    _loadData();
  }

  Future<void> deleteSubmeter(String id) async {
    await _db.deleteSubmeter(id);
    await _sync.deleteSubmeter(id);
    _loadData();
  }

  Future<void> addReading(Reading reading) async {
    // Get the previous reading for this submeter before adding the new one
    final meterReadings =
        _readings.where((r) => r.submeterId == reading.submeterId).toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    await _db.addReading(reading);
    await _sync.saveReading(reading);

    // If there was a previous reading, generate a Bill
    if (meterReadings.isNotEmpty) {
      final prev = meterReadings.first;
      final usage = double.parse(
        (reading.value - prev.value).toStringAsFixed(2),
      );

      if (usage > 0) {
        final bill = Bill(
          id: 'BILL-${DateTime.now().millisecondsSinceEpoch}',
          submeterId: reading.submeterId,
          month: DateFormat('MMMM yyyy').format(reading.timestamp),
          amount: (usage * currentRate) + reading.balance,
          kwh: usage,
          status: 'Pending',
          timestamp: DateTime.now(),
          previousReading: prev.value,
          currentReading: reading.value,
          balance: reading.balance,
        );
        await _db.addBill(bill);
        await _sync.saveBill(bill);
      }
    }

    // Update the submeter's last reading
    final submeterIndex = _submeters.indexWhere(
      (s) => s.id == reading.submeterId,
    );
    if (submeterIndex != -1) {
      final submeter = _submeters[submeterIndex];
      final updatedSubmeter = Submeter(
        id: submeter.id,
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
    await _sync.saveNotification(notification);
    _loadData();
  }

  Future<void> addBill(Bill bill) async {
    await _db.addBill(bill);
    await _sync.saveBill(bill);
    _loadData();
  }

  Future<void> markBillAsPaid(String billId) async {
    final billIndex = _bills.indexWhere((b) => b.id == billId);
    if (billIndex != -1) {
      final bill = _bills[billIndex];
      final updatedBill = Bill(
        id: bill.id,
        submeterId: bill.submeterId,
        month: bill.month,
        amount: bill.amount,
        kwh: bill.kwh,
        status: 'Paid',
        timestamp: bill.timestamp,
        previousReading: bill.previousReading,
        currentReading: bill.currentReading,
        balance: bill.balance,
      );
      await _db.updateBill(updatedBill);
      await _sync.saveBill(updatedBill);
      _loadData();
    }
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

  Future<void> updateBillingConfig({
    double? totalBill,
    double? masterUsage,
    double? baseFee,
    bool? splitBaseFeeEqually,
    bool? useProRata,
    double? flatRate,
  }) async {
    if (totalBill != null) {
      _totalBill = totalBill;
      await _db.settingsBox.put('totalBill', totalBill);
    }
    if (masterUsage != null) {
      _masterUsage = masterUsage;
      await _db.settingsBox.put('masterUsage', masterUsage);
    }
    if (baseFee != null) {
      _baseFee = baseFee;
      await _db.settingsBox.put('baseFee', baseFee);
    }
    if (splitBaseFeeEqually != null) {
      _splitBaseFeeEqually = splitBaseFeeEqually;
      await _db.settingsBox.put('splitBaseFeeEqually', splitBaseFeeEqually);
    }
    if (useProRata != null) {
      _useProRata = useProRata;
      await _db.settingsBox.put('useProRata', useProRata);
    }
    if (flatRate != null) {
      _flatRate = flatRate;
      await _db.settingsBox.put('flatRate', flatRate);
    }

    // Sync settings to Firestore
    await _sync.saveSettings({
      'totalBill': _totalBill,
      'masterUsage': _masterUsage,
      'baseFee': _baseFee,
      'splitBaseFeeEqually': _splitBaseFeeEqually,
      'useProRata': _useProRata,
      'flatRate': _flatRate,
    });

    notifyListeners();
  }

  Future<void> updateReminderSettings({
    bool? enabled,
    String? frequency,
    int? day,
  }) async {
    if (enabled != null) {
      _readingRemindersEnabled = enabled;
      await _db.settingsBox.put('readingRemindersEnabled', enabled);
    }
    if (frequency != null) {
      _reminderFrequency = frequency;
      await _db.settingsBox.put('reminderFrequency', frequency);
    }
    if (day != null) {
      _reminderDay = day;
      await _db.settingsBox.put('reminderDay', day);
    }

    // Sync settings to Firestore
    await _sync.saveSettings({
      'readingRemindersEnabled': _readingRemindersEnabled,
      'reminderFrequency': _reminderFrequency,
      'reminderDay': _reminderDay,
    });

    // Apply notification scheduling
    await NotificationService().scheduleReadingReminder(
      enabled: _readingRemindersEnabled,
      frequency: _reminderFrequency,
      dayOfMonth: _reminderDay,
    );

    // Add notification to history
    await addNotification(
      NotificationItem(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Reading Reminder Configured',
        description: _readingRemindersEnabled
            ? 'Reminders are set to $_reminderFrequency${_reminderFrequency == 'Monthly' ? ' on day $_reminderDay' : ''}'
            : 'Reading reminders have been disabled',
        type: 'reading',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Refresh data explicitly if needed
  void refresh() {
    _loadData();
  }
}
