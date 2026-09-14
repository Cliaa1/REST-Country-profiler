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

  /// Pattern-matched JSON deserializer following Sound Null Safety
  factory Country.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'name': {'common': String common, 'official': String official}} =>
        Country(
          commonName: common,
          officialName: official,
          capital: switch (json['capital']) {
            List cap when cap.isNotEmpty => cap.first.toString(),
            _ => 'N/A',
          },
          region: json['region']?.toString() ?? 'N/A',
          subregion: json['subregion']?.toString() ?? 'N/A',
          population: (json['population'] as num?)?.toInt() ?? 0,
          area: (json['area'] as num?)?.toDouble() ?? 0.0,
          languages: switch (json['languages']) {
            Map<String, dynamic> langs =>
              langs.values.map((e) => e.toString()).toList(),
            _ => [],
          },
          currencies: _parseCurrencies(
            json['currencies'] as Map<String, dynamic>?,
          ),
          borders: switch (json['borders']) {
            List b => b.map((e) => e.toString()).toList(),
            _ => [],
          },
          flagUrl: switch (json['flags']) {
            {'png': String pngUrl} => pngUrl,
            _ => 'N/A',
          },
          mapsUrl: switch (json['maps']) {
            {'googleMaps': String googleUrl} => googleUrl,
            _ => 'N/A',
          },
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
