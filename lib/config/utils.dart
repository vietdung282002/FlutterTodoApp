import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  String formatTimeTo12Hour(TimeOfDay time) {
    final int hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    final String minute =
        time.minute.toString().padLeft(2, '0'); // Đảm bảo 2 chữ số
    return '$hour:$minute $period';
  }

  String getCurrentTime() {
    DateTime now = DateTime.now().toUtc();
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS'+00:00'").format(now);
  }

  String formatCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat("MMMM dd, yyyy").format(now);
  }

  String formatDateTimeString(String date, String time) {
    DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
    DateTime parsedTime = DateFormat("hh:mm a").parse(time);

    DateTime combinedDateTime = DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      parsedTime.hour,
      parsedTime.minute,
      parsedTime.second,
    ).toUtc();

    return DateFormat("yyyy-MM-ddTHH:mm:ss'+00:00'").format(combinedDateTime);
  }
}
