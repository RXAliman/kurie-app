import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

import '../data/models/bill.dart';
import '../data/models/submeter.dart';
import '../data/repositories/app_repository.dart';
import '../data/services/pdf_service.dart';
import 'package:intl/intl.dart';

class BillDetailsScreen extends StatelessWidget {
  final String billId;

  const BillDetailsScreen({super.key, required this.billId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appRepo = context.watch<AppRepository>();
    final Bill bill = appRepo.bills.firstWhere((b) => b.id == billId);
    final Submeter meter = appRepo.submeters.firstWhere((m) => m.id == bill.submeterId);
    
    final currencyFormat = NumberFormat.currency(symbol: 'P', decimalDigits: 2);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: const Text('Bill Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () async {
              final pdfData = await PdfService.generateIndividualBill(bill, meter);
              await Printing.layoutPdf(
                onLayout: (format) => pdfData,
                name: 'Bill_${bill.id}.pdf',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: bill.status == 'Paid' 
                    ? colorScheme.primaryContainer.withAlpha(40)
                    : colorScheme.tertiaryContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    bill.status == 'Paid' ? Icons.check_circle_rounded : Icons.pending_rounded,
                    size: 20,
                    color: bill.status == 'Paid' ? colorScheme.primary : colorScheme.tertiary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Bill is ${bill.status.toUpperCase()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: bill.status == 'Paid' ? colorScheme.primary : colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Bill Summary Header
            Text(
              bill.month,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Bill ID: ${bill.id}',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // Details Section
            _buildDetailSection(colorScheme, 'TENANT INFORMATION', [
              _buildDetailRow(colorScheme, 'Name', meter.tenantId),
              _buildDetailRow(colorScheme, 'Submeter', meter.name),
              _buildDetailRow(colorScheme, 'Location', meter.unit),
            ]),
            const SizedBox(height: 32),

            _buildDetailSection(colorScheme, 'CONSUMPTION DETAILS', [
              _buildDetailRow(colorScheme, 'Previous Reading', '${bill.previousReading ?? 0} kWh'),
              _buildDetailRow(colorScheme, 'Current Reading', '${bill.currentReading ?? 0} kWh'),
              _buildDetailRow(colorScheme, 'Total Usage', '${bill.kwh} kWh', isBold: true),
            ]),
            const SizedBox(height: 32),

            _buildDetailSection(colorScheme, 'PAYMENT SUMMARY', [
              _buildDetailRow(colorScheme, 'Subtotal', currencyFormat.format(bill.amount)),
              Divider(height: 32, color: colorScheme.outlineVariant),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL AMOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: colorScheme.onSurface)),
                  Text(
                    currencyFormat.format(bill.amount),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: colorScheme.primary),
                  ),
                ],
              ),
            ]),
            const SizedBox(height: 48),

            // Download Button (Primary)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final pdfData = await PdfService.generateIndividualBill(bill, meter);
                  await Printing.layoutPdf(
                    onLayout: (format) => pdfData,
                    name: 'Bill_${bill.id}.pdf',
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('Download Statement (PDF)', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(ColorScheme colorScheme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailRow(ColorScheme colorScheme, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
