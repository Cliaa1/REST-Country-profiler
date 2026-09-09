import 'exceptions.dart';

class Country {
  final String commonName;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final double area;
  final List<String> languages;
  final List<String> currencies;
  final List<String> borders;
  final String flagUrl;
  final String mapsUrl;

  Country({
    required this.commonName,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.languages,
    required this.currencies,
    required this.borders,
    required this.flagUrl,
    required this.mapsUrl,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': {
          'common': String common,
          'official': String official,
        },
        'capital': List capitalList,
        'region': String region,
        'subregion': String? subregion,
        'population': num population,
        'area': num area,
        'languages': Map<String, dynamic>? languagesMap,
        'currencies': Map<String, dynamic>? currenciesMap,
        'borders': List? bordersList,
        'flags': {'png': String flag},
        'maps': {'googleMaps': String maps},
      } =>
        Country(
          commonName: common,
          officialName: official,
          capital: capitalList.isNotEmpty ? capitalList.first.toString() : 'N/A',
          region: region,
          subregion: subregion ?? 'N/A',
          population: population.toInt(),
          area: area.toDouble(),
          languages:
              languagesMap?.values.map((e) => e.toString()).toList() ?? [],
          currencies: _parseCurrencies(currenciesMap),
          borders: bordersList?.map((e) => e.toString()).toList() ?? [],
          flagUrl: flag,
          mapsUrl: maps,
        ),
      _ => throw CountryException('Payload failed pattern validation check!'),
    };
  }

  static List<String> _parseCurrencies(Map<String, dynamic>? map) {
    if (map == null) return [];
    return map.entries.map((e) {
      final code = e.key;
      final name = e.value['name'] ?? 'Unknown';
      final symbol = e.value['symbol'] ?? '';
      return '$name ($code) $symbol'.trim();
    }).toList();
  }
}