import 'package:flutter/material.dart';

String formatTimeTo12Hour(TimeOfDay time) {
  final int hour =
      time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
  final String period = time.hour >= 12 ? 'PM' : 'AM';
  final String minute =
      time.minute.toString().padLeft(2, '0'); // Đảm bảo 2 chữ số
  return '$hour:$minute $period';
}
