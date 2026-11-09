bool isTokenExpired(String expirationDateStr) {
  final expirationDate = DateTime.parse(expirationDateStr);
  final now = DateTime.now().toUtc();
  return now.isAfter(expirationDate);
}
