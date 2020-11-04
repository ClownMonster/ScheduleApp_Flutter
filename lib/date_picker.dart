import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

// ignore: camel_case_types
class date_picker {
  // ignore: non_constant_identifier_names
  static DateTime selected_date = DateTime.now();
  static String formatted_date = '';
  // ignore: missing_return
  static Future<void> selectdate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      selected_date = picked;
      print(selected_date);
      formatted_date = formatDate(selected_date, [dd, '-', mm, '-', yyyy]);
    }
  }
}
