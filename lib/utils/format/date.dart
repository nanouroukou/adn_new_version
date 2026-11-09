import 'package:intl/intl.dart';

import '../log/logger.dart';

/// Cette fonction prend en parametre [dateString] une date en string de format dd-mm-yyyy et retourne une date de type DateTime ISO 8601
DateTime parseFrDate(String dateString) {
  DateFormat formatter = DateFormat("dd-mm-yyyy");
  DateTime result = formatter.parse(dateString);
  logger()
      .d('Parsing fr date from [$dateString] to iso [${result.toString()}]');
  return result;
}
