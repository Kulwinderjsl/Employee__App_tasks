import 'dart:convert';

import 'package:intl/intl.dart';

class EmployeeModel {
  String? empId;
  String? empName;
  String? empRole;
  String? joiningDate;
  String? leavingDate;

  EmployeeModel({
    required this.empId,
    required this.empName,
    required this.empRole,
    required this.joiningDate,
    required this.leavingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": empId,
      "name": empName,
      "role": empRole,
      "joiningDate": joiningDate,
      "leavingDate": leavingDate,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      empId: map["id"],
      empName: map["name"],
      empRole: map["role"],
      joiningDate: map["joiningDate"],
      leavingDate: map["leavingDate"],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  String getFormattedDate(String value) {
    DateTime dateTime = getDateTime(value);
    return DateFormat('d MMM, yyyy').format(dateTime);
  }

  DateTime getDateTime(String value) {
    int timestamp = int.parse(value);
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
