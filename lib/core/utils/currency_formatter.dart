import 'package:intl/intl.dart';
import '../constants/currency_constants.dart';

/// Formats currency values according to the app's standards.
///
/// Key rules from IMPLEMENTATION_PLAN.md:
/// - CFA currencies (XOF, XAF): NO decimal places, show "500 FCFA"
/// - Other currencies: 2 decimal places
/// - Max amount: 100,000,000 FCFA
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format an amount for display.
  ///
  /// [amount] - The amount in the smallest unit (e.g., cents for USD, whole for CFA)
  /// [currencyCode] - Currency code (default: XOF)
  /// [showSymbol] - Whether to show the currency symbol
  static String format(
    int amount, {
    String currencyCode = 'XOF',
    bool showSymbol = true,
  }) {
    final currency = CurrencyConstants.getCurrency(currencyCode);

    // Format the number
    final formatter = NumberFormat.decimalPattern('fr');

    String formatted;
    if (currency.isCFA) {
      // CFA: No decimals
      formatted = formatter.format(amount);
    } else {
      // Other currencies: 2 decimals (amount stored as cents)
      formatted = formatter.format(amount / 100);
    }

    if (!showSymbol) {
      return formatted;
    }

    // Add currency symbol
    if (currency.symbolAfterAmount) {
      return '$formatted ${currency.symbol}';
    } else {
      return '${currency.symbol}$formatted';
    }
  }

  /// Format for compact display (e.g., "1.2M FCFA")
  static String formatCompact(
    int amount, {
    String currencyCode = 'XOF',
    bool showSymbol = true,
  }) {
    final currency = CurrencyConstants.getCurrency(currencyCode);

    // For CFA, amount is already in whole units
    // For other currencies, convert from cents
    final displayAmount = currency.isCFA ? amount.toDouble() : amount / 100;

    final formatter = NumberFormat.compact(locale: 'fr');
    final formatted = formatter.format(displayAmount);

    if (!showSymbol) {
      return formatted;
    }

    if (currency.symbolAfterAmount) {
      return '$formatted ${currency.symbol}';
    } else {
      return '${currency.symbol}$formatted';
    }
  }

  /// Parse a string input to amount (integer).
  ///
  /// Returns null if parsing fails.
  /// For CFA: returns the whole number
  /// For other currencies: returns cents (multiplied by 100)
  static int? parse(String input, {String currencyCode = 'XOF'}) {
    if (input.isEmpty) return null;

    // Remove currency symbols and whitespace
    final cleaned = input
        .replaceAll(RegExp(r'[^\d.,\-]'), '')
        .replaceAll(',', '.')
        .trim();

    if (cleaned.isEmpty) return null;

    try {
      final currency = CurrencyConstants.getCurrency(currencyCode);
      final value = double.parse(cleaned);

      if (currency.isCFA) {
        // CFA: Store as whole number
        return value.round();
      } else {
        // Other currencies: Store as cents
        return (value * 100).round();
      }
    } catch (_) {
      return null;
    }
  }

  /// Validate amount is within acceptable range.
  ///
  /// Returns error message or null if valid.
  static String? validate(int? amount, {String currencyCode = 'XOF'}) {
    if (amount == null) {
      return 'Please enter an amount';
    }

    if (amount < CurrencyConstants.minAmount) {
      return 'Amount cannot be negative';
    }

    final currency = CurrencyConstants.getCurrency(currencyCode);

    // For CFA, max is 100,000,000
    // For other currencies, max is equivalent in cents
    final maxAmount = currency.isCFA
        ? CurrencyConstants.maxAmount
        : CurrencyConstants.maxAmount * 100;

    if (amount > maxAmount) {
      final maxFormatted = format(
        currency.isCFA ? CurrencyConstants.maxAmount : CurrencyConstants.maxAmount * 100,
        currencyCode: currencyCode,
      );
      return 'Amount cannot exceed $maxFormatted';
    }

    return null;
  }

  /// Calculate profit: revenue - total spend
  static int calculateProfit(int revenue, int totalSpend) {
    return revenue - totalSpend;
  }

  /// Format profit with color indicator.
  ///
  /// Returns a record with formatted string and isProfit flag.
  static ({String formatted, bool isProfit}) formatProfit(
    int profit, {
    String currencyCode = 'XOF',
  }) {
    final isProfit = profit >= 0;
    final prefix = isProfit ? '+' : '';
    final formatted = '$prefix${format(profit, currencyCode: currencyCode)}';

    return (formatted: formatted, isProfit: isProfit);
  }
}
