import 'package:employee_app_flutter/utils/constants/asset_constant.dart';
import 'package:employee_app_flutter/utils/constants/color_constants.dart';
import 'package:employee_app_flutter/utils/constants/string_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/employee.dart';
import '../logic/employee_cubit.dart';
import '../screens/add_edit_employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final bool isCurrentEmployee;

  const EmployeeCard({Key? key, required this.employee, required this.isCurrentEmployee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          ImageAssetPath.delete,
          width: 30,
          height: 30,
        ),
      ),
      onDismissed: (direction) {
        _deleteEmployee(context, employee);
      },
      child: Container(
        color: white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                title: Text(
                  employee.name,
                  style: TextStyle(fontSize: 16, color: textColorName),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        employee.role,
                        style: TextStyle(fontSize: 14, color: textColorRole),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        isCurrentEmployee
                            ? 'From ${formatDate(employee.fromDate)}'
                            : '${formatDate(employee.fromDate)} - ${formatDate(employee.toDate)}',
                        style: TextStyle(fontSize: 12, color: textColorRole),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditEmployeeScreen(employee: employee),
                    ),
                  );
                },
              ),
            ),
            const Divider(
              height: 0.1,
              color: bordercolor,
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String date) {
    return DateFormat("d MMM, yyyy").format(
      DateFormat("yyyy-MM-dd").parse(date),
    );
  }

  void _deleteEmployee(BuildContext context, Employee employee) {
    final cubit = context.read<EmployeeCubit>();
    cubit.deleteEmployee(employee.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Employee deleted"),
        action: SnackBarAction(
          label: Strings.undo,
          onPressed: () {
            cubit.addEmployee(employee);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
