import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

/// Utilities for backing up and restoring the Drift database.
///
/// Used before schema migrations to enable rollback on failure.
class DatabaseBackup {
  /// Create a backup of the current database.
  ///
  /// Returns the path to the backup file.
  /// Throws [DatabaseBackupException] on failure.
  static Future<String> createBackup(String dbPath) async {
    try {
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        throw DatabaseBackupException('Database file does not exist: $dbPath');
      }

      final originalSize = await dbFile.length();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = '$dbPath.backup_$timestamp';

      await dbFile.copy(backupPath);

      // Verify backup integrity (prevents silent corruption)
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw DatabaseBackupException('Backup file was not created: $backupPath');
      }

      final backupSize = await backupFile.length();
      if (backupSize != originalSize) {
        await backupFile.delete();  // Clean up bad backup
        throw DatabaseBackupException(
          'Backup verification failed: size mismatch ($backupSize != $originalSize)',
        );
      }

      debugPrint(
        'Database backed up to: $backupPath (${(backupSize / 1024).toStringAsFixed(2)} KB)',
      );
      return backupPath;
    } catch (e) {
      throw DatabaseBackupException('Failed to create backup: $e');
    }
  }

  /// Restore database from most recent backup.
  ///
  /// IMPORTANT: The database MUST be closed before calling this method.
  /// Otherwise, restoration will fail due to file locks.
  ///
  /// Throws [DatabaseBackupException] if no backup found or restoration fails.
  static Future<void> restoreFromBackup(String dbPath) async {
    try {
      final backups = await _findBackups(dbPath);

      if (backups.isEmpty) {
        throw DatabaseBackupException('No backups found for database: $dbPath');
      }

      // Get most recent backup
      final latestBackup = backups.last.path;
      final backupFile = File(latestBackup);

      // Check existence immediately before copy (TOCTOU protection)
      if (!await backupFile.exists()) {
        throw DatabaseBackupException('Backup file disappeared: $latestBackup');
      }

      // Small delay to ensure file handle released (if recently closed)
      await Future.delayed(const Duration(milliseconds: 100));

      // Replace current DB with backup
      await backupFile.copy(dbPath);

      debugPrint('Database restored from: $latestBackup');
    } catch (e) {
      throw DatabaseBackupException('Failed to restore backup: $e');
    }
  }

  /// Clean up old backups, keeping only the most recent N.
  ///
  /// [keepCount] - Number of backups to keep (default: 3)
  static Future<void> cleanOldBackups(String dbPath, {int keepCount = 3}) async {
    try {
      final backups = await _findBackups(dbPath);

      if (backups.length <= keepCount) {
        return; // Nothing to clean
      }

      // Delete oldest backups (list is already sorted by modification time)
      final toDelete = backups.take(backups.length - keepCount);
      for (final backup in toDelete) {
        final file = File(backup.path);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Deleted old backup: ${backup.path}');
        }
      }
    } catch (e) {
      debugPrint('Failed to clean old backups: $e');
      // Non-critical error, don't throw
    }
  }

  /// Find all backup files for a given database.
  ///
  /// Returns list of backup metadata, sorted by modification time (oldest first).
  static Future<List<_BackupMetadata>> _findBackups(String dbPath) async {
    final dbFile = File(dbPath);
    final dbDir = dbFile.parent;
    final dbName = path.basename(dbPath);

    if (!await dbDir.exists()) {
      return [];
    }

    // Find all backup files
    final backupFiles = <String>[];
    await for (final entity in dbDir.list()) {
      if (entity is File) {
        final filename = path.basename(entity.path);
        if (filename.startsWith('$dbName.backup_')) {
          backupFiles.add(entity.path);
        }
      }
    }

    if (backupFiles.isEmpty) {
      return [];
    }

    // Get metadata asynchronously (avoids blocking UI thread)
    final backupMetadata = await Future.wait(
      backupFiles.map((filePath) async {
        final file = File(filePath);
        final modifiedTime = await file.lastModified();
        return _BackupMetadata(path: filePath, modifiedTime: modifiedTime);
      }),
    );

    // Sort by modification time (oldest first)
    backupMetadata.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));

    return backupMetadata;
  }

  /// Get total size of all backups in MB.
  static Future<double> getBackupsSizeMB(String dbPath) async {
    final backups = await _findBackups(dbPath);
    int totalBytes = 0;

    for (final backup in backups) {
      final file = File(backup.path);
      if (await file.exists()) {
        totalBytes += await file.length();
      }
    }

    return totalBytes / (1024 * 1024); // Convert to MB
  }
}

/// Internal class to hold backup file metadata.
class _BackupMetadata {
  final String path;
  final DateTime modifiedTime;

  _BackupMetadata({required this.path, required this.modifiedTime});
}

/// Exception thrown when database backup/restore operations fail.
class DatabaseBackupException implements Exception {
  final String message;
  const DatabaseBackupException(this.message);

  @override
  String toString() => 'DatabaseBackupException: $message';
}
