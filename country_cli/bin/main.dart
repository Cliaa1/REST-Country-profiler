import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:terminal_colors/terminal_colors.dart';
import 'package:country_api/country_api.dart';
import '../lib/src/command_base.dart';
import '../lib/src/commands.dart';
import '../lib/src/logging_config.dart';

void main() async {
  configureSystemTelemetry();

  final httpClient = http.Client();
  final apiClient = CountryApiClient(httpClient);

  final commands = <CliCommand>[
    SearchCommand(),
    RegionCommand(),
    CurrencyCommand(),
    LanguageCommand(),
  ];
  final helpCmd = HelpCommand(commands);
  commands.add(helpCmd);

  final commandMap = {for (var c in commands) c.name: c};

  print('══════════════════════════════════════'.styleHeader);
  print('   REST Country Profiler CLI'.styleHeader);
  print('   Type "help" for commands'.styleHeader);
  print('══════════════════════════════════════'.styleHeader);

  try {
    while (true) {
      stdout.write('\ncountry > ');
      final input = stdin.readLineSync();

      if (input == null || input.trim().toLowerCase() == 'exit') {
        print('Exiting platform...'.styleWarning);
        break;
      }

      final trimmed = input.trim();
      if (trimmed.isEmpty) continue;

      final parts = trimmed.split(RegExp(r'\s+'));
      final commandName = parts.first.toLowerCase();
      final args = parts.sublist(1);

      final command = commandMap[commandName];
      if (command != null) {
        await command.execute(apiClient, args);
      } else {
        print('Unknown command. Type "help" or "exit".'.styleError);
      }
    }
  } finally {
    httpClient.close();
    print('System network socket disconnected successfully.'.styleSuccess);
  }
}
