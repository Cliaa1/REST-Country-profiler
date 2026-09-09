import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'exceptions.dart';
import 'models.dart';

class CountryApiClient {
  final http.Client _client;
  final Logger _logger = Logger('CountryApiClient');
  static const String _authority = 'restcountries.com';

  CountryApiClient(this._client);

  Future<List<Country>> fetchByName(String name) async {
    _logger.info('Initiating query by country name: $name');
    final uri = Uri.https(_authority, '/v3.1/name/$name');
    return _getCountries(uri);
  }

  Future<List<Country>> fetchByRegion(String region) async {
    _logger.info('Initiating query by region: $region');
    final uri = Uri.https(_authority, '/v3.1/region/$region');
    return _getCountries(uri);
  }

  Future<List<Country>> fetchByCurrency(String currency) async {
    _logger.info('Initiating query by currency: $currency');
    final uri = Uri.https(_authority, '/v3.1/currency/$currency');
    return _getCountries(uri);
  }

  Future<List<Country>> fetchByLanguage(String language) async {
    _logger.info('Initiating query by language: $language');
    final uri = Uri.https(_authority, '/v3.1/lang/$language');
    return _getCountries(uri);
  }

  Future<List<Country>> _getCountries(Uri uri) async {
    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 404) {
        _logger.warning('Resource not found for URI: $uri');
        throw CountryException(
            'No country records found matching your query criteria.');
      }

      if (response.statusCode != 200) {
        _logger.warning('API responded with error status: ${response.statusCode}');
        throw CountryException(
            'Remote server rejected transaction (HTTP ${response.statusCode}).');
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) {
        throw CountryException('Unexpected JSON response payload structure.');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Country.fromJson(item))
          .toList();
    } on http.ClientException catch (e) {
      _logger.severe('Network socket transaction failed.', e);
      throw CountryException('Network communication failure occurred.', e);
    } catch (e) {
      _logger.severe('An unexpected processing failure was intercepted.', e);
      rethrow;
    }
  }
}