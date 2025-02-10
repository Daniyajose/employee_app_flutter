import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int? id;
  final String name;
  final String role;
  final String fromDate;
  final String toDate;

  const Employee({this.id, required this.name, required this.role, required this.fromDate, required this.toDate});

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'fromDate': fromDate,
      'toDate': toDate,
    };
  }

  @override
  List<Object?> get props => [id, name, role, fromDate, toDate];
}