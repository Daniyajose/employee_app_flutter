import '../db/db_helper.dart';
import 'employee.dart';

class EmployeeRepository {
  final DatabaseHelper dbHelper;

  EmployeeRepository(this.dbHelper);

  Future<List<Employee>> getEmployees() => dbHelper.getEmployees();
  Future<void> addEmployee(Employee employee) => dbHelper.insertEmployee(employee);
  Future<void> updateEmployee(Employee employee) => dbHelper.updateEmployee(employee);
  Future<void> deleteEmployee(int id) => dbHelper.deleteEmployee(id);
}
