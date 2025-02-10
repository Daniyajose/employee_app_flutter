import 'package:employee_app_flutter/data/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants/asset_constant.dart';
import '../utils/constants/color_constants.dart';

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isFromDate;
  final Employee? employees;

  CustomDatePickerDialog({
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.isFromDate,
    required this.employees,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? selectedDate;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  UniqueKey _calendarKey = UniqueKey();
  String? selectedButton;

  @override
  void initState() {
    super.initState();

    if (!widget.isFromDate && widget.initialDate == null) {
      selectedDate = null;
    } else {
      selectedDate = widget.initialDate ?? DateTime.now();
    }
    selectedButton = _getSelectedButton(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: StatefulBuilder(
        builder: (context, setStateDialog) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate button width based on available space
                    final buttonWidth = (constraints.maxWidth - 8) / 2;
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.isFromDate
                          ? [
                        _quickSelectButton("Today", DateTime.now(), setStateDialog, buttonWidth),
                        _quickSelectButton("Next Monday", _nextWeekday(DateTime.monday), setStateDialog, buttonWidth),
                        _quickSelectButton("Next Tuesday", _nextWeekday(DateTime.tuesday), setStateDialog, buttonWidth),
                        _quickSelectButton("After 1 Week", DateTime.now().add(Duration(days: 7)), setStateDialog, buttonWidth),
                      ]
                          : [
                        _quickSelectButton("No Date", null, setStateDialog, buttonWidth),
                        _quickSelectButton("Today", DateTime.now(), setStateDialog, buttonWidth),
                      ],
                    );
                  },
                ),
              ),

              CalendarDatePicker(
                key: _calendarKey,
                initialDate: selectedDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDateChanged: (date) {
                  if (widget.isFromDate || date.isAfter(widget.firstDate)) {
                    setState(() {
                      selectedDate = date;
                      selectedButton = _getSelectedButton(date);
                    });
                    setStateDialog(() {});
                  }
                },
              ),
              const Divider(
                height: 0.1,
                color: bordercolor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset(ImageAssetPath.datePicker, width: 24, height: 24),
                        SizedBox(width: 12),
                        Text(selectedDate != null ? DateFormat('d MMM yyyy').format(selectedDate!) : widget.isFromDate ? 'Today' : 'No Date'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: blue,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, selectedDate);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _quickSelectButton(String text, DateTime? date, Function setStateDialog, double buttonWidth) {
    bool isSelected = selectedButton == text;

    return SizedBox(
      width: buttonWidth,
      height: 40,
      child: isSelected
          ? ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          setState(() {
            selectedDate = date; // Allow null for "No Date"
            selectedButton = text;
            _calendarKey = UniqueKey();
          });
          setStateDialog(() {});
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      )
          : OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: BorderSide(color: Colors.blue.shade100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blue.shade50,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          setState(() {
            selectedDate = date; // Allow null for "No Date"
            selectedButton = text;
            _calendarKey = UniqueKey();
          });
          setStateDialog(() {});
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(text, style: TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

  DateTime _nextWeekday(int weekday) {
    DateTime now = DateTime.now();
    int daysUntilNext = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysUntilNext == 0 ? 7 : daysUntilNext));
  }

  String? _getSelectedButton(DateTime? date) {
    if (date == null) return "No Date";
    if (_isSameDate(date, DateTime.now())) return "Today";
    if (_isSameDate(date, _nextWeekday(DateTime.monday))) return "Next Monday";
    if (_isSameDate(date, _nextWeekday(DateTime.tuesday))) return "Next Tuesday";
    if (_isSameDate(date, DateTime.now().add(Duration(days: 7)))) return "After 1 Week";
    return null;
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}