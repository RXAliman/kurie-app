import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/app_repository.dart';

/// Dispute Resolution screen — matches Stitch "Dispute Resolution" design.
/// Allows admins to review and resolve tenant queries about bills.
class DisputeResolutionScreen extends StatefulWidget {
  const DisputeResolutionScreen({super.key});

  @override
  State<DisputeResolutionScreen> createState() => _DisputeResolutionScreenState();
}

class _DisputeResolutionScreenState extends State<DisputeResolutionScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final disputes = context.watch<AppRepository>().disputes;
    final pendingDisputes = disputes.where((d) => d.status == 'Pending').toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dispute Resolution',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: pendingDisputes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 48, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No pending disputes found',
                      style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Context Card for the first pending dispute
                        _buildContextCard(colorScheme, pendingDisputes.first),
                        const SizedBox(height: 32),

                        // Message Thread (Placeholder for now)
                        Text(
                          'MESSAGE HISTORY',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMessageItem(colorScheme, {
                          'isSystem': false,
                          'sender': pendingDisputes.first.tenantName,
                          'text': 'I have a concern about my last reading.',
                          'time': 'Just now',
                        }),
                      ],
                    ),
                  ),
                ),

                // Admin Actions & Input
                _buildAdminControls(colorScheme),
              ],
            ),
    );
  }

  Widget _buildContextCard(ColorScheme colorScheme, dynamic dispute) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disputed Bill: ${dispute.billCycle}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer.withAlpha(51),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: colorScheme.tertiary.withAlpha(76)),
                ),
                child: Text(
                  dispute.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetric(colorScheme, '₱${dispute.amount.toStringAsFixed(2)}', 'AMOUNT'),
              const SizedBox(width: 32),
              _buildMetric(colorScheme, '${dispute.usage.toInt()} kWh', 'USAGE'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 16, color: colorScheme.outline),
              const SizedBox(width: 8),
              Text(
                'Submeter ${dispute.submeterId} - ${dispute.tenantName}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(ColorScheme colorScheme, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
            color: colorScheme.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(ColorScheme colorScheme, Map<String, dynamic> message) {
    final bool isSystem = message['isSystem'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isSystem ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (!isSystem)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    message['sender'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(isSystem ? 8 : 16),
            decoration: BoxDecoration(
              color: isSystem ? Colors.transparent : colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
              border: isSystem ? null : Border.all(color: colorScheme.outlineVariant),
            ),
            child: Text(
              message['text'],
              textAlign: isSystem ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSystem ? 11 : 14,
                fontStyle: isSystem ? FontStyle.italic : FontStyle.normal,
                fontWeight: isSystem ? FontWeight.w500 : FontWeight.w400,
                color: isSystem ? colorScheme.outline : colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminControls(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAdminAction(
                  colorScheme: colorScheme,
                  icon: Icons.edit_rounded,
                  label: 'Adjust Reading',
                  color: colorScheme.primary,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAdminAction(
                  colorScheme: colorScheme,
                  icon: Icons.check_circle_rounded,
                  label: 'Resolve Dispute',
                  color: colorScheme.onSurface,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a response...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: colorScheme.outline,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminAction({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
