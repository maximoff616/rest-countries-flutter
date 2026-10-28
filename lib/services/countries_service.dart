
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/country.dart';

class CountriesService {
  CountriesService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.https(
      'countries.dev',
      '/countries',
      {
        'limit': '250',
        'fields':
            'name,alpha2Code,capital,region,population,currencies,languages,flag',
        'sort': 'name',
        'order': 'asc',
      },
    );

    final response = await _client
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw CountriesApiException(
        'Gagal mengambil data. Status: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const CountriesApiException(
        'Format data negara tidak sesuai.',
      );
    }

    final countries = decoded
        .whereType<Map<String, dynamic>>()
        .map(Country.fromJson)
        .toList()
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

    return List<Country>.unmodifiable(countries);
  }

  void dispose() {
    _client.close();
  }
}

class CountriesApiException implements Exception {
  const CountriesApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
