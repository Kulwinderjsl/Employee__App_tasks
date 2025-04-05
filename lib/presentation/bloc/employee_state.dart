
import 'package:equatable/equatable.dart';
import 'package:round2_employee_app/presentation/models/employee_model.dart';

class EmployeeState extends Equatable {
  final List<EmployeeModel> items;

  const EmployeeState(this.items);

  @override
  List<Object> get props => [items];
}

class LoadingState extends Equatable {

  const LoadingState();

  @override
  List<Object> get props => [];

}