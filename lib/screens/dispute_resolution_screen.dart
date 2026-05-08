import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme/kurie_colors.dart';
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
    final disputes = context.watch<AppRepository>().disputes;
    final pendingDisputes = disputes.where((d) => d.status == 'Pending').toList();

    return Scaffold(
      backgroundColor: KurieColors.surface,
      appBar: AppBar(
        backgroundColor: KurieColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: KurieColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dispute Resolution',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: KurieColors.onSurface,
          ),
        ),
      ),
      body: pendingDisputes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 48, color: KurieColors.outline),
                  const SizedBox(height: 16),
                  Text('No pending disputes found',
                      style: TextStyle(color: KurieColors.onSurfaceVariant)),
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
                        _buildContextCard(pendingDisputes.first),
                        const SizedBox(height: 32),

                        // Message Thread (Placeholder for now)
                        Text(
                          'MESSAGE HISTORY',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: KurieColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMessageItem({
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
                _buildAdminControls(),
              ],
            ),
    );
  }

  Widget _buildContextCard(dynamic dispute) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: Border.all(color: KurieColors.outlineVariant),
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
                  color: KurieColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: KurieColors.tertiaryFixed.withAlpha(51),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: KurieColors.tertiary.withAlpha(76)),
                ),
                child: Text(
                  dispute.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: KurieColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMetric('₱${dispute.amount.toStringAsFixed(2)}', 'AMOUNT'),
              const SizedBox(width: 32),
              _buildMetric('${dispute.usage.toInt()} kWh', 'USAGE'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 16, color: KurieColors.outline),
              const SizedBox(width: 8),
              Text(
                'Submeter ${dispute.submeterId} - ${dispute.tenantName}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: KurieColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
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
            color: KurieColors.outline,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: KurieColors.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
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
                      color: KurieColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: KurieColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(isSystem ? 8 : 16),
            decoration: BoxDecoration(
              color: isSystem ? Colors.transparent : KurieColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
              border: isSystem ? null : Border.all(color: KurieColors.outlineVariant),
            ),
            child: Text(
              message['text'],
              textAlign: isSystem ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSystem ? 11 : 14,
                fontStyle: isSystem ? FontStyle.italic : FontStyle.normal,
                fontWeight: isSystem ? FontWeight.w500 : FontWeight.w400,
                color: isSystem ? KurieColors.outline : KurieColors.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: KurieColors.surfaceContainerLowest,
        border: const Border(top: BorderSide(color: KurieColors.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildAdminAction(
                  icon: Icons.edit_rounded,
                  label: 'Adjust Reading',
                  color: KurieColors.primary,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAdminAction(
                  icon: Icons.check_circle_rounded,
                  label: 'Resolve Dispute',
                  color: KurieColors.onSurface,
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
                    color: KurieColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: KurieColors.outlineVariant),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a response...',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: KurieColors.outline,
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
                  color: KurieColors.primary,
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
          border: Border.all(color: KurieColors.outlineVariant),
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
