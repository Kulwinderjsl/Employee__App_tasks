
import 'package:equatable/equatable.dart';
import 'package:round2_employee_app/presentation/models/employee_model.dart';

abstract class EmployeeEvent extends Equatable {

  @override
  List<Object> get props => [];
}

 class LoadEmployeeList extends EmployeeEvent {}

 class AddEmployee extends EmployeeEvent {
  final EmployeeModel item;

  AddEmployee(this.item);

  @override
  List<Object> get props => [item];
}

// Remove item from list
class RemoveEmployee extends EmployeeEvent {
  final EmployeeModel item;

  RemoveEmployee(this.item);

  @override
  List<Object> get props => [item];
}

// Update item from list
class UpdateEmployee extends EmployeeEvent {
  final EmployeeModel item;

  UpdateEmployee(this.item);

  @override
  List<Object> get props => [item];
}