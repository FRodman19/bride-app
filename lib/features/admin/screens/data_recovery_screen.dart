import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/data_recovery_service.dart';
import '../../../providers/database_provider.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';

/// Admin screen for emergency data recovery
///
/// This screen is for frankwultof@gmail.com to upload all local data to Supabase.
/// Should only be used ONCE for data recovery.
class DataRecoveryScreen extends ConsumerStatefulWidget {
  const DataRecoveryScreen({super.key});

  @override
  ConsumerState<DataRecoveryScreen> createState() => _DataRecoveryScreenState();
}

class _DataRecoveryScreenState extends ConsumerState<DataRecoveryScreen> {
  bool _isRunning = false;
  DataRecoveryReport? _report;
  String? _error;

  Future<void> _runRecovery() async {
    setState(() {
      _isRunning = true;
      _report = null;
      _error = null;
    });

    try {
      final db = ref.read(databaseProvider);
      final service = DataRecoveryService(db);

      final report = await service.recoverUserData();

      setState(() {
        _report = report;
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    // Direct color references for warning/error/success cards
    const warningBg = GOLPrimitives.accent100;
    const warningBorder = GOLPrimitives.accent500;
    const warningText = GOLPrimitives.accent900;
    const warningTextSecondary = GOLPrimitives.accent800;

    const errorBg = GOLPrimitives.error50;
    const errorBorder = GOLPrimitives.error500;
    const errorText = GOLPrimitives.error600;
    const errorTextSecondary = GOLPrimitives.error600;

    const successBg = GOLPrimitives.success50;
    const successBorder = GOLPrimitives.success500;
    const successText = GOLPrimitives.success600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Recovery'),
        backgroundColor: colors.surfaceRaised,
      ),
      backgroundColor: colors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GOLSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning card
              Container(
                padding: const EdgeInsets.all(GOLSpacing.space4),
                decoration: BoxDecoration(
                  color: warningBg,
                  border: Border.all(color: warningBorder, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Data Recovery',
                      style: textTheme.titleLarge?.copyWith(
                        color: warningText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    Text(
                      'This will upload ALL local data to Supabase. Run this ONCE to recover missing data.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: warningTextSecondary,
                      ),
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    Text(
                      'User: frankwultof@gmail.com',
                      style: textTheme.bodySmall?.copyWith(
                        color: warningText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GOLSpacing.space6),

              // Loading indicator
              if (_isRunning)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: colors.interactivePrimary),
                      const SizedBox(height: GOLSpacing.space4),
                      Text(
                        'Recovering data...',
                        style: textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
                      ),
                    ],
                  ),
                ),

              // Error card
              if (_error != null)
                Container(
                  padding: const EdgeInsets.all(GOLSpacing.space4),
                  decoration: BoxDecoration(
                    color: errorBg,
                    border: Border.all(color: errorBorder, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: textTheme.titleMedium?.copyWith(
                          color: errorText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: GOLSpacing.space2),
                      Text(
                        _error!,
                        style: textTheme.bodySmall?.copyWith(
                          color: errorTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

              // Report card
              if (_report != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(GOLSpacing.space4),
                      decoration: BoxDecoration(
                        color: _report!.success ? successBg : errorBg,
                        border: Border.all(
                          color: _report!.success ? successBorder : errorBorder,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _report.toString(),
                        style: textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: _report!.success ? successText : errorText,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: GOLSpacing.space6),

              // Action button
              GOLButton(
                label: _isRunning ? 'Running...' : 'Start Recovery',
                onPressed: _isRunning ? null : _runRecovery,
                variant: GOLButtonVariant.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
