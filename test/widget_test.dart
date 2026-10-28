import 'package:flutter_test/flutter_test.dart';
import 'package:rest_countries_explorer/models/country.dart';

void main() {
  test('Country.fromJson parses country data correctly', () {
    final country = Country.fromJson({
      'name': {
        'common': 'Indonesia',
        'official': 'Republic of Indonesia',
      },
      'capital': ['Jakarta'],
      'population': 275000000,
      'languages': {'ind': 'Indonesian'},
      'currencies': {
        'IDR': {'name': 'Indonesian rupiah', 'symbol': 'Rp'},
      },
      'flags': {'png': 'https://example.com/flag.png'},
      'region': 'Asia',
      'cca2': 'ID',
    });

    expect(country.name, 'Indonesia');
    expect(country.capitalLabel, 'Jakarta');
    expect(country.population, 275000000);
    expect(country.languagesLabel, 'Indonesian');
    expect(country.code, 'ID');
  });
}