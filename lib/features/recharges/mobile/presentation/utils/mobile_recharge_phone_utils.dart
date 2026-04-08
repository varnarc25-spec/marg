/// Strips non-digits and returns the last 10 digits when [input] has at least 10 digits.
String? tenDigitMobileFromInput(String input) {
  final d = input.replaceAll(RegExp(r'\D'), '');
  if (d.length < 10) return null;
  return d.length > 10 ? d.substring(d.length - 10) : d;
}
