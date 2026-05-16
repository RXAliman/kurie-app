import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
    );

    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  Future<void> scheduleReadingReminder({
    required bool enabled,
    required String frequency,
    required int dayOfMonth,
  }) async {
    // Clear existing reminders to avoid duplicates
    await _notificationsPlugin.cancel(id: 888); // Use a fixed ID for the reminder

    if (!enabled) return;
    
    if (frequency == 'Daily') {
      await _notificationsPlugin.periodicallyShow(
        id: 888,
        title: 'Meter Reading Reminder',
        body: 'It\'s time to log your submeter readings for today!',
        repeatInterval: RepeatInterval.daily,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reading_reminders',
            'Reading Reminders',
            channelDescription: 'Reminders to log meter readings',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else if (frequency == 'Weekly') {
      await _notificationsPlugin.periodicallyShow(
        id: 888,
        title: 'Meter Reading Reminder',
        body: 'It\'s time for your weekly meter reading log!',
        repeatInterval: RepeatInterval.weekly,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reading_reminders',
            'Reading Reminders',
            channelDescription: 'Reminders to log meter readings',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else if (frequency == 'Monthly') {
      await _notificationsPlugin.zonedSchedule(
        id: 888,
        title: 'Meter Reading Reminder',
        body:
            'It\'s the $dayOfMonth${_getDaySuffix(dayOfMonth)}! Time to log your submeter readings.',
        scheduledDate: _nextInstanceOfDayOfMonth(dayOfMonth),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'reading_reminders',
            'Reading Reminders',
            channelDescription: 'Reminders to log meter readings',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfDayOfMonth(int day) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, day, 9, 0); // 9:00 AM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(tz.local, now.year, now.month + 1, day, 9, 0);
    }
    return scheduledDate;
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}
