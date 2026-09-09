import 'package:test/test.dart';
import 'package:country_api/country_api.dart';

void main() {
  group('Country Model Deserialisation Suite', () {
    test('Successful parsing of structural attributes', () {
      final mockJson = {
        'name': {
          'common': 'Philippines',
          'official': 'Republic of the Philippines',
        },
        'capital': ['Manila'],
        'region': 'Asia',
        'subregion': 'South-Eastern Asia',
        'population': 109581085,
        'area': 342353.0,
        'languages': {'eng': 'English', 'fil': 'Filipino'},
        'currencies': {
          'PHP': {'name': 'Philippine peso', 'symbol': '₱'}
        },
        'borders': ['MYS'],
        'flags': {'png': 'https://flagcdn.com/w320/ph.png'},
        'maps': {'googleMaps': 'https://goo.gl/maps/sh8ry7pCV0gM5P39'},
      };

      final country = Country.fromJson(mockJson);

      expect(country.commonName, equals('Philippines'));
      expect(country.officialName, equals('Republic of the Philippines'));
      expect(country.capital, equals('Manila'));
      expect(country.region, equals('Asia'));
      expect(country.subregion, equals('South-Eastern Asia'));
      expect(country.population, equals(109581085));
      expect(country.area, equals(342353.0));
      expect(country.languages, containsAll(['English', 'Filipino']));
      expect(country.currencies.first, contains('Philippine peso'));
      expect(country.borders, contains('MYS'));
    });

    test('Trigger custom exception on broken mapping keys', () {
      final malformedJson = {
        'name': {'common': 'Incomplete Country Data'},
      };

      expect(
        () => Country.fromJson(malformedJson),
        throwsA(isA<CountryException>()),
      );
    });
  });
}