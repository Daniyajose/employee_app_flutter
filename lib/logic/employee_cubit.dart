import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/employee.dart';
import '../data/employee_repository.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository repository;

  EmployeeCubit(this.repository) : super(EmployeeInitial());

  void loadEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError("Failed to load employees"));
    }
  }

  void addEmployee(Employee employee) async {
    await repository.addEmployee(employee);
    loadEmployees();
  }

  void updateEmployee(Employee employee) async {
    await repository.updateEmployee(employee);
    loadEmployees();
  }

  void deleteEmployee(int id) async {
    await repository.deleteEmployee(id);
    loadEmployees();
  }
}
