 import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:round2_employee_app/presentation/bloc/employee_events.dart';
import 'package:round2_employee_app/presentation/bloc/employee_state.dart';
import 'package:round2_employee_app/presentation/models/employee_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {


  EmployeeBloc() : super(EmployeeState([])) {
    on<LoadEmployeeList>(_loadList);
    on<AddEmployee>(_addItem);
    on<RemoveEmployee>(_removeItem);
    on<UpdateEmployee>(_updateEmployee);
  }

  Future<void> _loadList(LoadEmployeeList event, Emitter<EmployeeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('employees');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<EmployeeModel> employees = jsonList.map((e) => EmployeeModel.fromMap(e)).toList();
      emit(EmployeeState(employees));
    }
  }

  Future<void> _addItem(AddEmployee event, Emitter<EmployeeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = List<EmployeeModel>.from(state.items)..add(event.item);
    // Save to SharedPreferences
    final jsonString = json.encode(updatedList.map((e) => e.toMap()).toList());
    await prefs.setString('employees', jsonString);
    emit(EmployeeState(updatedList));
  }

  Future<void> _removeItem(RemoveEmployee event, Emitter<EmployeeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = List<EmployeeModel>.from(state.items)..remove(event.item);
    // Save to SharedPreferences
    final jsonString = json.encode(updatedList.map((e) => e.toMap()).toList());
    await prefs.setString('employees', jsonString);
    emit(EmployeeState(updatedList));
  }

  Future<void> _updateEmployee(UpdateEmployee event, Emitter<EmployeeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final updatedList = state.items.map((employee) {
      return employee.empId == event.item.empId ? event.item : employee;
    }).toList();

    // Save updated list to SharedPreferences
    final jsonString = json.encode(updatedList.map((e) => e.toMap()).toList());
    await prefs.setString('employees', jsonString);

    emit(EmployeeState(updatedList));

  }


}
