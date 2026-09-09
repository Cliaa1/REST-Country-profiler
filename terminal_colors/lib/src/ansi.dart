enum TerminalColor {
  reset('\x1B[0m'),
  cyan('\x1B[36m'),
  emerald('\x1B[32m'),
  amber('\x1B[33m'),
  crimson('\x1B[31m'),
  bold('\x1B[1m');

  final String code;
  const TerminalColor(this.code);
}

extension Colorizer on String {
  String color(TerminalColor color) =>
      '${color.code}$this${TerminalColor.reset.code}';

  String get styleHeader =>
      '${TerminalColor.bold.code}${TerminalColor.cyan.code}$this${TerminalColor.reset.code}';
  String get styleSuccess =>
      '${TerminalColor.emerald.code}$this${TerminalColor.reset.code}';
  String get styleWarning =>
      '${TerminalColor.amber.code}$this${TerminalColor.reset.code}';
  String get styleError =>
      '${TerminalColor.crimson.code}$this${TerminalColor.reset.code}';
}