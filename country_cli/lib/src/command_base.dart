import 'package:country_api/country_api.dart';

abstract class CliCommand {
  final String name;
  final String description;

  CliCommand(this.name, this.description);

  Future<void> execute(CountryApiClient client, List<String> arguments);
}