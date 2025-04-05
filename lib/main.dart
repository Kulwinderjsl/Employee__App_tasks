import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round2_employee_app/core/app_colors.dart';
import 'package:round2_employee_app/presentation/bloc/employee_bloc.dart';
import 'package:round2_employee_app/presentation/screens/employee_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      ),
      home:  BlocProvider(
     create: (context) => EmployeeBloc(),
     child: const EmployeeListScreen(),
      ) );
  }
}

