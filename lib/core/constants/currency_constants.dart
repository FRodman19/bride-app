/// Currency configuration for the Performance Tracker app.
///
/// Default: Franc CFA (XOF) - West African CFA franc
/// No decimal places for CFA currencies.
class CurrencyConstants {
  CurrencyConstants._();

  /// Default currency code
  static const String defaultCurrencyCode = 'XOF';

  /// All supported currencies
  static const List<CurrencyInfo> supportedCurrencies = [
    CurrencyInfo(
      code: 'XOF',
      name: 'Franc CFA (BCEAO)',
      symbol: 'FCFA',
      decimalPlaces: 0,
      symbolAfterAmount: true,
    ),
    CurrencyInfo(
      code: 'XAF',
      name: 'Franc CFA (BEAC)',
      symbol: 'FCFA',
      decimalPlaces: 0,
      symbolAfterAmount: true,
    ),
    CurrencyInfo(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      decimalPlaces: 2,
      symbolAfterAmount: false,
    ),
    CurrencyInfo(
      code: 'EUR',
      name: 'Euro',
      symbol: '\u20AC',
      decimalPlaces: 2,
      symbolAfterAmount: false,
    ),
    CurrencyInfo(
      code: 'GBP',
      name: 'British Pound',
      symbol: '\u00A3',
      decimalPlaces: 2,
      symbolAfterAmount: false,
    ),
    CurrencyInfo(
      code: 'NGN',
      name: 'Nigerian Naira',
      symbol: '\u20A6',
      decimalPlaces: 2,
      symbolAfterAmount: false,
    ),
    CurrencyInfo(
      code: 'GHS',
      name: 'Ghanaian Cedi',
      symbol: 'GH\u20B5',
      decimalPlaces: 2,
      symbolAfterAmount: false,
    ),
  ];

  /// Get currency info by code
  static CurrencyInfo getCurrency(String code) {
    return supportedCurrencies.firstWhere(
      (c) => c.code == code.toUpperCase(),
      orElse: () => supportedCurrencies.first, // Default to XOF
    );
  }

  /// Maximum allowed amount (100,000,000 FCFA)
  static const int maxAmount = 100000000;

  /// Minimum allowed amount
  static const int minAmount = 0;
}

/// Information about a currency
class CurrencyInfo {
  final String code;
  final String name;
  final String symbol;
  final int decimalPlaces;
  final bool symbolAfterAmount;

  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalPlaces,
    required this.symbolAfterAmount,
  });

  /// Check if this is a CFA currency (no decimals)
  bool get isCFA => code == 'XOF' || code == 'XAF';
}
