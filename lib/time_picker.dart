import 'package:flutter/material.dart';

// ignore: camel_case_types
class time_picker {
  static TimeOfDay time = TimeOfDay.now();
  // ignore: non_constant_identifier_names
  static String time_selected = '';
  // ignore: missing_return
  static Future<void> selecttime(BuildContext context) async {
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      time_selected = time.format(context);
    }
  }
}
