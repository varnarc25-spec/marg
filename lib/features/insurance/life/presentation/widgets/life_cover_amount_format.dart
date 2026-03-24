/// Human-readable sum assured for cover / plans UI.
String formatLifeCoverAmount(int lakhs) {
  if (lakhs >= 100) return '₹${lakhs ~/ 100} Crore';
  return '₹$lakhs Lakh';
}
