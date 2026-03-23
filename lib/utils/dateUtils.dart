import 'package:intl/intl.dart';

String formatDate(String isoDate) {
  // Parse the ISO string to DateTime
  DateTime dateTime = DateTime.parse(isoDate);

  // Format it to "June 12, 2024"
  String formatted = DateFormat('MMMM d, y').format(dateTime);

  return formatted;
}