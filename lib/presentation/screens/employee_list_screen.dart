import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round2_employee_app/core/app_colors.dart';
import 'package:round2_employee_app/presentation/bloc/employee_state.dart';
import 'package:round2_employee_app/presentation/models/employee_model.dart';
import 'package:round2_employee_app/presentation/screens/add_edit_employee_Details.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_events.dart';
import '../widgets/no_data_widget.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<EmployeeModel> currentEmployees = [];
  List<EmployeeModel> previousEmployees = [];

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployeeList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Employee List",
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return CircularProgressIndicator();
          }

          if (state.items.isEmpty) {
            return Center(child: noDataWidget());
          }
          currentEmployees.clear();
          previousEmployees.clear();
          for (var emp in state.items) {
            if (emp.leavingDate!.isEmpty) {
              currentEmployees.add(emp);
            } else {
              previousEmployees.add(emp);
            }
          }

          return Container(
            color: AppColors.backgroundColor,
            child: ListView(
              // padding: EdgeInsets.all(10),
              children: [
                if (currentEmployees.isNotEmpty) ...[
                  sectionHeader("Current employees"),
                  ...currentEmployees.asMap().entries.map(
                    (entry) => employeeCard(entry.value, entry.key, true),
                  ),
                ],

                if (previousEmployees.isNotEmpty) ...[
                  sectionHeader("Previous employees"),
                  ...previousEmployees.asMap().entries.map(
                    (entry) => employeeCard(entry.value, entry.key, false),
                  ),
                ],

                if (previousEmployees.isNotEmpty || currentEmployees.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Swipe left to delete",
                      style: TextStyle(color: AppColors.subHeaderTextColor),
                    ),
                  ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => EmployeeBloc(),
                    child: AddEditEmployeeScreen(updateEmployee: false),
                  ),
            ),
          ).then((val) {
            context.read<EmployeeBloc>().add(LoadEmployeeList());
          });
        },
        backgroundColor:AppColors.primaryColor,
        child:   Icon(Icons.add,color: AppColors.whiteColor,),
      ),
    );
  }

  void deleteEmployee(int index, bool isCurrent) {
    EmployeeModel removedEmployee =
        isCurrent ? currentEmployees[index] : previousEmployees[index];

    context.read<EmployeeBloc>().add(RemoveEmployee(removedEmployee));
    setState(() {
      isCurrent
          ? currentEmployees.removeAt(index)
          : previousEmployees.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Employee data has been deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            context.read<EmployeeBloc>().add(AddEmployee(removedEmployee));
            setState(() {
              isCurrent
                  ? currentEmployees.insert(index, removedEmployee)
                  : previousEmployees.insert(index, removedEmployee);
            });
          },
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget employeeCard(EmployeeModel employee, int index, bool isCurrent) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider(
                  create: (context) => EmployeeBloc(),
                  child: AddEditEmployeeScreen(
                    updateEmployee: true,
                    employeeModel: employee,
                  ),
                ),
          ),
        ).then((val) {
          context.read<EmployeeBloc>().add(LoadEmployeeList());
        });
      },
      child: Column(
        children: [
          Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) => deleteEmployee(index, isCurrent),
            child: Container(
              color: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.empName!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.headerTextColor,
                        ),
                      ),
                      Text(
                        employee.empRole!,
                        style: TextStyle(color: AppColors.subHeaderTextColor),
                      ),
                      employee.leavingDate!.isEmpty
                          ? Text(
                           "From ${employee.getFormattedDate(employee.joiningDate!)}",
                            style: TextStyle(color: AppColors.subHeaderTextColor),
                          )
                          : Text(
                            "${employee.getFormattedDate(employee.joiningDate!)} - ${employee.getFormattedDate(employee.leavingDate!)}",
                            style: TextStyle(color: AppColors.subHeaderTextColor),
                          ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Divider(
            height: 1,
            color: AppColors.borderColor,
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}
