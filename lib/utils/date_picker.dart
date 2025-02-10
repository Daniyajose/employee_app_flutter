import 'package:employee_app_flutter/data/employee.dart';
import 'package:flutter/material.dart';

import '../widget/custom_date_picker_dialog.dart';

class DatePickerHelper {
  static Future<DateTime?> selectDate({
    required BuildContext context,
    required DateTime? initialDate,
    required bool isFromDate,
    required DateTime firstDate,
    Employee? employees,
  }) async {
    return await showDialog<DateTime?>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: DateTime(2030),
        isFromDate: isFromDate,
        employees: employees,
      ),
    );
  }
}
