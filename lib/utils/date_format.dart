import 'package:intl/intl.dart';

String formatMicrosecondsToDate(int milliseconds) {
  // Create a DateTime object
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // Define the desired format
  String formattedDate = DateFormat("dd MMMM yyyy, hh:mm a").format(dateTime);

  return formattedDate;
}
