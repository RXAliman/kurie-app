import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/bill.dart';
import '../models/submeter.dart';

class PdfService {
  static final _currencyFormat = NumberFormat.currency(symbol: 'P', decimalDigits: 2);
  static final _dateFormat = DateFormat('MMM dd, yyyy');

  /// Generates a single-page high-fidelity bill statement for a specific tenant.
  static Future<Uint8List> generateIndividualBill(Bill bill, Submeter meter) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final boldFont = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('KURIE', style: pw.TextStyle(font: boldFont, fontSize: 24, color: PdfColors.blue900)),
                        pw.Text('Smart Submetering Solutions', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('BILL STATEMENT', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                        pw.Text('Bill ID: ${bill.id}', style: pw.TextStyle(font: font, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Bill To & Summary
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('BILL TO', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.grey700)),
                          pw.SizedBox(height: 4),
                          pw.Text(meter.tenantId, style: pw.TextStyle(font: boldFont, fontSize: 14)),
                          pw.Text(meter.unit, style: pw.TextStyle(font: boldFont, fontSize: 14)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('BILLING PERIOD', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.grey700)),
                          pw.SizedBox(height: 4),
                          pw.Text(bill.month, style: pw.TextStyle(font: boldFont, fontSize: 14)),
                          pw.SizedBox(height: 12),
                          pw.Text('DUE DATE', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.grey700)),
                          pw.SizedBox(height: 4),
                          pw.Text(_dateFormat.format(bill.timestamp.add(const Duration(days: 7))), style: pw.TextStyle(font: font, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),

                // Consumption Details Table
                pw.Table(
                  border: const pw.TableBorder(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                      children: [
                        _tableHeader('DESCRIPTION', font),
                        _tableHeader('PREVIOUS', font),
                        _tableHeader('CURRENT', font),
                        _tableHeader('USAGE', font),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _tableCell('Electricity Consumption', font),
                        _tableCell('${(bill.previousReading ?? 0.0).toStringAsFixed(2)} kWh', font, align: pw.Alignment.centerRight),
                        _tableCell('${(bill.currentReading ?? 0.0).toStringAsFixed(2)} kWh', font, align: pw.Alignment.centerRight),
                        _tableCell('${bill.kwh.toStringAsFixed(2)} kWh', boldFont, align: pw.Alignment.centerRight),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Cost Breakdown
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text('Subtotal: ', style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.SizedBox(width: 40),
                            pw.Text(_currencyFormat.format(bill.amount), style: pw.TextStyle(font: font, fontSize: 12)),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.SizedBox(
                          width: 150,
                          child: pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          children: [
                            pw.Text('Balance: ', style: pw.TextStyle(font: font, fontSize: 12)),
                            pw.SizedBox(width: 40),
                            pw.Text(_currencyFormat.format(bill.balance), style: pw.TextStyle(font: font, fontSize: 12)),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.SizedBox(
                          width: 150,
                          child: pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          children: [
                            pw.Text('TOTAL DUE: ', style: pw.TextStyle(font: boldFont, fontSize: 16)),
                            pw.SizedBox(width: 40),
                            pw.Text(_currencyFormat.format(bill.amount), style: pw.TextStyle(font: boldFont, fontSize: 16, color: PdfColors.blue900)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                pw.Spacer(),

                // Footer
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Thank you for your prompt payment.', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                    pw.Text('Generated by Kurie App', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates a summary document with 2x4 grid of small cuttable slips for all tenants.
  static Future<Uint8List> generateCuttableSlips(List<Bill> bills, List<Submeter> meters) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final boldFont = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          if (bills.isEmpty) {
            return [
              pw.Center(
                child: pw.Text(
                  'No billing records found for this period.',
                  style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey700),
                ),
              ),
            ];
          }

          final List<pw.Widget> slips = [];
          
          for (final bill in bills) {
            // Find the meter, or use a placeholder if not found
            Submeter? meter;
            try {
              meter = meters.firstWhere((m) => m.id == bill.submeterId);
            } catch (_) {
              // If meter not found, create a dummy one for the slip
              meter = Submeter(id: bill.submeterId, unit: 'Unknown Unit', tenantId: 'Unknown', lastReading: '0', status: 'Inactive');
            }
            slips.add(_buildSlip(bill, meter, font, boldFont));
          }

          return [
            pw.Wrap(
              spacing: 0,
              runSpacing: 0,
              children: slips,
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildSlip(Bill bill, Submeter meter, pw.Font font, pw.Font boldFont) {
    return pw.Container(
      width: PdfPageFormat.a4.width / 2,
      height: PdfPageFormat.a4.height / 4,
      padding: const pw.EdgeInsets.all(24),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('KURIE BILL SLIP', style: pw.TextStyle(font: boldFont, fontSize: 11, color: PdfColors.blue900)),
              pw.Text(bill.month, style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey300, thickness: 0.5),
          pw.SizedBox(height: 12),
          pw.Text('TENANT: ${meter.tenantId}', style: pw.TextStyle(font: boldFont, fontSize: 12)),
          pw.Text('UNIT: ${meter.unit}', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
          pw.Spacer(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _slipDetail('Prev Reading:', '${(bill.previousReading ?? 0).toStringAsFixed(2)} kWh', font),
                  _slipDetail('Curr Reading:', '${(bill.currentReading ?? 0).toStringAsFixed(2)} kWh', font),
                  _slipDetail('Balance:', 'P${bill.balance.toStringAsFixed(2)}', font),
                  pw.SizedBox(height: 4),
                  _slipDetail('Total Usage:', '${bill.kwh.toStringAsFixed(2)} kWh', boldFont, fontSize: 10),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('TOTAL DUE', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey700)),
                  pw.Text(_currencyFormat.format(bill.amount), style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.blue900)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _slipDetail(String label, String value, pw.Font font, {double fontSize = 8}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: fontSize, color: PdfColors.grey600)),
          pw.SizedBox(width: 4),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: fontSize)),
        ],
      ),
    );
  }

  static pw.Widget _tableHeader(String label, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(label, style: pw.TextStyle(font: font, fontSize: 10, fontWeight: pw.FontWeight.bold)),
    );
  }

  static pw.Widget _tableCell(String value, pw.Font font, {pw.Alignment align = pw.Alignment.centerLeft}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Align(
        alignment: align,
        child: pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10)),
      ),
    );
  }
}
