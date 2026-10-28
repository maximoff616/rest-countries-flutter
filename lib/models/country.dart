
class Country {
  const Country({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.population,
    required this.languages,
    required this.currencies,
    required this.flagUrl,
    required this.region,
    required this.code,
  });

  final String name;
  final String officialName;
  final List<String> capital;
  final int population;
  final List<String> languages;
  final List<String> currencies;
  final String flagUrl;
  final String region;
  final String code;

  factory Country.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String? ?? 'Unknown country';
    final code = json['alpha2Code'] as String? ?? '';

    final capitalValue = json['capital'];
    final capital = capitalValue is String && capitalValue.isNotEmpty
        ? <String>[capitalValue]
        : <String>[];

    final languageValue = json['languages'];
    final languages = languageValue is List
        ? languageValue
            .whereType<Map<String, dynamic>>()
            .map((item) => item['name'] as String? ?? '')
            .where((value) => value.isNotEmpty)
            .toList()
        : <String>[];

    final currencyValue = json['currencies'];
    final currencies = currencyValue is List
        ? currencyValue
            .whereType<Map<String, dynamic>>()
            .map((item) {
              final currencyName = item['name'] as String? ?? '';
              final symbol = item['symbol'] as String? ?? '';

              if (currencyName.isEmpty) return symbol;
              return symbol.isEmpty
                  ? currencyName
                  : '$currencyName ($symbol)';
            })
            .where((value) => value.isNotEmpty)
            .toList()
        : <String>[];

    final flagValue = json['flag'];
    final flagsValue = json['flags'];

    final flagUrl = flagsValue is Map<String, dynamic>
        ? flagsValue['png'] as String? ?? ''
        : flagValue is String && flagValue.startsWith('http')
            ? flagValue
            : '';

    return Country(
      name: name,
      officialName: name,
      capital: List<String>.unmodifiable(capital),
      population: (json['population'] as num?)?.toInt() ?? 0,
      languages: List<String>.unmodifiable(languages),
      currencies: List<String>.unmodifiable(currencies),
      flagUrl: flagUrl,
      region: json['region'] as String? ?? 'Other',
      code: code,
    );
  }

  String get capitalLabel =>
      capital.isEmpty ? 'No capital listed' : capital.join(', ');

  String get languagesLabel =>
      languages.isEmpty ? 'Not listed' : languages.join(', ');

  String get currenciesLabel =>
      currencies.isEmpty ? 'Not listed' : currencies.join(', ');
}
