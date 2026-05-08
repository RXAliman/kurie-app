import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';

/// Notification Center screen — matches Stitch "Notification Center" design.
/// Displays system alerts, billing updates, and reading reminders.
class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _notifications = [
    {
      'icon': Icons.warning_rounded,
      'title': 'Urgent: Disputed Reading',
      'description': 'Tenant at Unit 4B has flagged a calculation error.',
      'time': '15m ago',
      'isUrgent': true,
      'isRead': false,
    },
    {
      'icon': Icons.receipt_long_rounded,
      'title': 'Bill Finalized',
      'description': 'October bill for Eastwood Residences is ready for review.',
      'time': '2h ago',
      'isUrgent': false,
      'isRead': false,
    },
    {
      'icon': Icons.speed_rounded,
      'title': 'Reading Reminder',
      'description': 'Scheduled monthly meter reading for Basement Apt is due tomorrow.',
      'time': '5h ago',
      'isUrgent': false,
      'isRead': true,
    },
    {
      'icon': Icons.account_circle_rounded,
      'title': 'New Tenant Joined',
      'description': 'Alice Johnson has linked to Unit 4B.',
      'time': '1d ago',
      'isUrgent': false,
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      appBar: AppBar(
        backgroundColor: KurieColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: KurieColors.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: KurieColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: KurieColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: KurieColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: KurieColors.outlineVariant),
              ),
              labelColor: KurieColors.onSurface,
              unselectedLabelColor: KurieColors.onSurfaceVariant,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Urgent'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationList(urgentOnly: false),
          _buildNotificationList(urgentOnly: true),
        ],
      ),
    );
  }

  Widget _buildNotificationList({required bool urgentOnly}) {
    final filteredList = urgentOnly 
        ? _notifications.where((n) => n['isUrgent']).toList() 
        : _notifications;

    if (filteredList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      itemCount: filteredList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return InkWell(
          onTap: () {
            if (item['isUrgent']) {
              Navigator.of(context).pushNamed('/dispute_resolution');
            }
          },
          child: _buildNotificationCard(item),
        );
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    final bool isUrgent = item['isUrgent'];
    final bool isRead = item['isRead'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(
          color: isUrgent ? KurieColors.tertiary.withAlpha(76) : KurieColors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isUrgent 
                  ? KurieColors.tertiaryContainer.withAlpha(51) 
                  : KurieColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              item['icon'],
              size: 20,
              color: isUrgent ? KurieColors.tertiary : KurieColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isUrgent ? KurieColors.tertiary : KurieColors.onSurface,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: KurieColors.neonBlue,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: KurieColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: KurieColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: KurieColors.outlineVariant,
            ),
            const SizedBox(height: 24),
            Text(
              "You're all caught up!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: KurieColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No new alerts at the moment. We'll notify you when there's an update to your readings or bills.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: KurieColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: KurieColors.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'View History',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: KurieColors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
