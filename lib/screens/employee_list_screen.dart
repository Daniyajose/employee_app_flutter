import 'package:employee_app_flutter/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/employee_cubit.dart';
import '../logic/employee_state.dart';
import '../widget/item_employee.dart';
import 'add_edit_employee.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List", style: TextStyle(color: white)),
        backgroundColor: blue,
      ),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return _buildNoEmployeesWidget();
            }
            return _buildEmployeeList(state);
          } else {
            return _buildNoEmployeesWidget();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditEmployeeScreen()),
        ),
        child: const Icon(Icons.add, color: white),
      ),
    );
  }

  Widget _buildNoEmployeesWidget() {
    return const Center(
      child: Text(
        "No Employee Records Found",
        style: TextStyle(fontSize: 18, color: textColorName),
      ),
    );
  }

  Widget _buildEmployeeList(EmployeeLoaded state) {
    final currentDate = DateTime.now();

    final currentEmployees = state.employees
        .where((e) => e.toDate.isEmpty || DateTime.parse(e.toDate).isAfter(currentDate))
        .toList();

    final previousEmployees = state.employees
        .where((e) => e.toDate.isNotEmpty && DateTime.parse(e.toDate).isBefore(currentDate))
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: bgGray,
          child: ListView(
            children: [
              if (currentEmployees.isNotEmpty) ...[
                _buildSectionHeader("Current Employees"),
                ...currentEmployees.map((e) => EmployeeCard(employee: e, isCurrentEmployee: true)),
              ],
              if (previousEmployees.isNotEmpty) ...[
                _buildSectionHeader("Previous Employees"),
                ...previousEmployees.map((e) => EmployeeCard(employee: e, isCurrentEmployee: false)),
              ],
              if (state.employees.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 6.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Swipe Left to Delete',
                      style: TextStyle(fontSize: 12, color: textColorRole),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: blue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
