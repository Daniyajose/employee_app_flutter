import 'package:employee_app_flutter/utils/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:employee_app_flutter/screens/employee_list_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/employee_repository.dart';
import 'db/db_helper.dart';
import 'logic/employee_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  final repository = EmployeeRepository(dbHelper);

  runApp(
    BlocProvider(
      create: (context) => EmployeeCubit(repository)..loadEmployees(),
      child:  MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: blue),
          fontFamily: "Roboto",
          useMaterial3: true,
        ),
        home: EmployeeListScreen(),
        debugShowCheckedModeBanner: false,),
    ),
  );
}