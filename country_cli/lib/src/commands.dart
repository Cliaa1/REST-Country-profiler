import 'package:terminal_colors/terminal_colors.dart';
import 'package:country_api/country_api.dart';
import 'command_base.dart';

void _printCountry(Country c) {
  final buffer = StringBuffer()
    ..writeln('═══ COUNTRY PROFILE ═══'.styleHeader)
    ..writeln('Common Name : ${c.commonName}'.styleSuccess)
    ..writeln('Official    : ${c.officialName}')
    ..writeln('Capital     : ${c.capital}')
    ..writeln('Region      : ${c.region} / ${c.subregion}')
    ..writeln('Population  : ${c.population}')
    ..writeln('Area (km²)  : ${c.area}')
    ..writeln('Languages   : ${c.languages.join(', ')}')
    ..writeln('Currencies  : ${c.currencies.join(', ')}')
    ..writeln(
      'Borders     : ${c.borders.isEmpty ? 'None' : c.borders.join(', ')}',
    )
    ..writeln('Flag URL    : ${c.flagUrl}')
    ..writeln('Google Maps : ${c.mapsUrl}')
    ..writeln('═══════════════════════'.styleHeader);
  print(buffer.toString());
}

class SearchCommand extends CliCommand {
  SearchCommand() : super('search', 'Search countries by name');

  @override
  Future<void> execute(CountryApiClient client, List<String> arguments) async {
    if (arguments.isEmpty) {
      print('Usage: search <country name>'.styleError);
      return;
    }
    try {
      final results = await client.fetchByName(arguments.join(' '));
      print('Found ${results.length} result(s)'.styleSuccess);
      for (final c in results) {
        _printCountry(c);
      }
    } on CountryException catch (e) {
      print('Operation Failed: ${e.message}'.styleError);
    }
  }
}

class RegionCommand extends CliCommand {
  RegionCommand()
    : super('region', 'List countries by region (e.g. Asia, Europe)');

  @override
  Future<void> execute(CountryApiClient client, List<String> arguments) async {
    if (arguments.isEmpty) {
      print('Usage: region <Africa|Americas|Asia|Europe|Oceania>'.styleError);
      return;
    }
    try {
      final results = await client.fetchByRegion(arguments.first);
      print(
        'Found ${results.length} countries in ${arguments.first}'.styleSuccess,
      );
      for (final c in results.take(10)) {
        print('• ${c.commonName} (Capital: ${c.capital})');
      }
      if (results.length > 10) {
        print('... and ${results.length - 10} more'.styleWarning);
      }
    } on CountryException catch (e) {
      print('Operation Failed: ${e.message}'.styleError);
    }
  }
}

class CurrencyCommand extends CliCommand {
  CurrencyCommand()
    : super('currency', 'Find countries by currency code (e.g. PHP, USD)');

  @override
  Future<void> execute(CountryApiClient client, List<String> arguments) async {
    if (arguments.isEmpty) {
      print('Usage: currency <code>   e.g. currency php'.styleError);
      return;
    }
    try {
      final results = await client.fetchByCurrency(arguments.first);
      print('Countries using "${arguments.first.toUpperCase()}":'.styleSuccess);
      for (final c in results) {
        print('• ${c.commonName} → ${c.currencies.join(', ')}');
      }
    } on CountryException catch (e) {
      print('Operation Failed: ${e.message}'.styleError);
    }
  }
}

class LanguageCommand extends CliCommand {
  LanguageCommand()
    : super('language', 'Find countries by language code (e.g. eng, spa)');

  @override
  Future<void> execute(CountryApiClient client, List<String> arguments) async {
    if (arguments.isEmpty) {
      print('Usage: language <code>   e.g. language eng'.styleError);
      return;
    }
    try {
      final results = await client.fetchByLanguage(arguments.first);
      print('Countries speaking "${arguments.first}":'.styleSuccess);
      for (final c in results.take(15)) {
        print('• ${c.commonName}');
      }
    } on CountryException catch (e) {
      print('Operation Failed: ${e.message}'.styleError);
    }
  }
}

class HelpCommand extends CliCommand {
  final List<CliCommand> allCommands;
  HelpCommand(this.allCommands) : super('help', 'Show available commands');

  @override
  Future<void> execute(CountryApiClient client, List<String> arguments) async {
    print('Available commands:'.styleHeader);
    for (final cmd in allCommands) {
      print('  ${cmd.name.padRight(12)} ${cmd.description}');
    }
    print('  exit         Quit the application');
  }
}
