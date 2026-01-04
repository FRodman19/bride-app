import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/models/tracker.dart';
import '../providers/entry_provider.dart';
import '../providers/reports_provider.dart';

/// Service for exporting data to CSV files.
class ExportService {
  ExportService._();

  /// Export entries to CSV and share the file.
  static Future<void> exportEntriesToCsv({
    required Tracker tracker,
    required List<Entry> entries,
    required ReportsData reportsData,
  }) async {
    if (entries.isEmpty) {
      throw Exception('No entries to export');
    }

    final csv = _generateEntriesCsv(
      tracker: tracker,
      entries: entries,
      reportsData: reportsData,
    );

    await _shareFile(
      content: csv,
      fileName: '${_sanitizeFileName(tracker.name)}_report_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv',
    );
  }

  /// Generate CSV content for entries.
  static String _generateEntriesCsv({
    required Tracker tracker,
    required List<Entry> entries,
    required ReportsData reportsData,
  }) {
    final buffer = StringBuffer();

    // Header section
    buffer.writeln('# Performance Report');
    buffer.writeln('# Project: ${tracker.name}');
    buffer.writeln('# Currency: ${tracker.currency}');
    buffer.writeln('# Period: ${DateFormat('MMM d, yyyy').format(reportsData.periodStart)} - ${DateFormat('MMM d, yyyy').format(reportsData.periodEnd)}');
    buffer.writeln('# Generated: ${DateFormat('MMM d, yyyy HH:mm').format(DateTime.now())}');
    buffer.writeln();

    // Summary section
    buffer.writeln('# Summary');
    buffer.writeln('Total Revenue,${reportsData.totalRevenue}');
    buffer.writeln('Total Spend,${reportsData.totalSpend}');
    buffer.writeln('Setup Costs,${reportsData.setupCost}');
    buffer.writeln('Net Profit,${reportsData.netProfit}');
    buffer.writeln('ROI,${reportsData.roi.toStringAsFixed(2)}%');
    buffer.writeln('Avg Daily Spend,${reportsData.avgDailySpend}');
    buffer.writeln('Entry Count,${reportsData.entryCount}');
    buffer.writeln();

    // Entries section
    buffer.writeln('# Daily Entries');

    // Get all unique platforms
    final allPlatforms = <String>{};
    for (final entry in entries) {
      allPlatforms.addAll(entry.platformSpends.keys);
    }
    final platformList = allPlatforms.toList()..sort();

    // Header row
    final headers = [
      'Date',
      'Revenue',
      'Total Spend',
      ...platformList.map((p) => '$p Spend'),
      'Profit',
      'DMs/Leads',
      'Notes',
    ];
    buffer.writeln(headers.join(','));

    // Sort entries by date
    final sortedEntries = List<Entry>.from(entries)
      ..sort((a, b) => a.entryDate.compareTo(b.entryDate));

    // Data rows
    for (final entry in sortedEntries) {
      final row = [
        DateFormat('yyyy-MM-dd').format(entry.entryDate),
        entry.totalRevenue.toString(),
        entry.totalSpend.toString(),
        ...platformList.map((p) => (entry.platformSpends[p] ?? 0).toString()),
        entry.profit.toString(),
        entry.totalDmsLeads.toString(),
        _escapeCsvValue(entry.notes ?? ''),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// Escape CSV special characters.
  static String _escapeCsvValue(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Sanitize filename to remove invalid characters.
  static String _sanitizeFileName(String name) {
    return name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_').toLowerCase();
  }

  /// Share the file using platform-specific sharing.
  static Future<void> _shareFile({
    required String content,
    required String fileName,
  }) async {
    if (kIsWeb) {
      // Web: Create download link
      await _downloadWeb(content: content, fileName: fileName);
    } else {
      // Mobile/Desktop: Use share_plus
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Performance Report',
        text: 'Exported report from Performance Tracker',
      );
    }
  }

  /// Web-specific download using HTML anchor element.
  static Future<void> _downloadWeb({
    required String content,
    required String fileName,
  }) async {
    // For web, we use dart:html which is only available on web
    // This is handled at compile time
    throw UnsupportedError('Web export not implemented yet');
  }
}
