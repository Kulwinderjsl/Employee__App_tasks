import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:round2_employee_app/core/app_colors.dart';
import 'package:round2_employee_app/presentation/bloc/employee_bloc.dart';
import 'package:round2_employee_app/presentation/bloc/employee_events.dart';
import 'package:round2_employee_app/presentation/models/employee_model.dart';
import 'package:round2_employee_app/presentation/widgets/common_widget.dart';
import 'package:uuid/uuid.dart';

import '../../core/app_assets.dart';

class AddEditEmployeeScreen extends StatefulWidget {
  bool updateEmployee = false;
  EmployeeModel? employeeModel;

  AddEditEmployeeScreen({
    super.key,
    required this.updateEmployee,
    this.employeeModel,
  });

  @override
  _AddEditEmployeeScreenState createState() => _AddEditEmployeeScreenState();
}

class _AddEditEmployeeScreenState extends State<AddEditEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();

  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;
  int selected = 1;
  Key calendarKey = UniqueKey();

  int? selectedStartTimeStamp;
  int? selectedEndTimeStamp;

  String? selectedRole;
  final List<String> roles = [
    "Product Designer",
    "Flutter Developer",
    "QA Tester",
    "Product Owner",
  ];

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployeeList());
    if (widget.employeeModel != null) {
      _nameController.text = widget.employeeModel!.empName!;
      selectedRole = widget.employeeModel!.empRole!;
      _startDate = widget.employeeModel!.getDateTime(
        widget.employeeModel!.joiningDate!,
      );
      _endDate =
          widget.employeeModel!.leavingDate!.isEmpty
              ? null
              : widget.employeeModel!.getDateTime(
                widget.employeeModel!.leavingDate!,
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.updateEmployee
              ? "Edit Employee Details"
              : "Add Employee Details",
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left,
            color: AppColors.whiteColor,
            size: 32,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Name Field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Employee name",
                prefixIcon: Image.asset(AppAssets.kPerson, width: 5, height: 5),

                //SvgPicture.asset(AppAssets.kPerson, height: 8,width: 5,),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                hintStyle: TextStyle(color: AppColors.subHeaderTextColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.borderColor),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Role Dropdown
            GestureDetector(
              onTap: () => _showRolePicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppAssets.kRole,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          selectedRole ?? "Select role",
                          style: TextStyle(
                            color:
                                selectedRole == null
                                    ? AppColors.subHeaderTextColor
                                    : AppColors.headerTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start Date Picker
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await showDatePicker(context, true);
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.kCalender,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _startDate != null
                                ? DateFormat('d MMM yyyy').format(_startDate!)
                                : "Today",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _startDate != null
                                      ? AppColors.headerTextColor
                                      : AppColors.subHeaderTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: AppColors.primaryColor),
                SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await showDatePicker(context, false);
                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.kCalender,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _endDate != null
                                ? DateFormat('d MMM yyyy').format(_endDate!)
                                : "No date",
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  _endDate != null
                                      ? AppColors.headerTextColor
                                      : AppColors.subHeaderTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),

            // Cancel & Save Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () async {
                    if (_nameController.text.isEmpty) {
                      showOkDialog(
                        context,
                        "Warning",
                        "Please enter Employee name",
                      );
                      return;
                    }

                    if (selectedRole == null) {
                      showOkDialog(
                        context,
                        "Warning",
                        "Please select Employee role ",
                      );
                      return;
                    }

                    if (_startDate == null) {
                      showOkDialog(
                        context,
                        "Warning",
                        "Please select Today's Date",
                      );
                      return;
                    }

                      selectedStartTimeStamp = _startDate!.millisecondsSinceEpoch;

                      if (_endDate != null) {
                        selectedEndTimeStamp =   _endDate!.millisecondsSinceEpoch;
                      }

                    EmployeeModel data = EmployeeModel(
                      empId:
                          widget.updateEmployee
                              ? widget.employeeModel!.empId
                              : getUniqueStringId(),
                      empName: _nameController.text.toString(),
                      empRole: selectedRole,
                      joiningDate: selectedStartTimeStamp.toString(),
                      leavingDate:
                          selectedEndTimeStamp == null
                              ? ""
                              : selectedEndTimeStamp.toString(),
                    );

                    if (widget.updateEmployee) {
                      context.read<EmployeeBloc>().add(UpdateEmployee(data));
                    } else {
                      context.read<EmployeeBloc>().add(AddEmployee(data));
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRolePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Wrap(
            children:
                roles.map((role) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(role, textAlign: TextAlign.center),
                        onTap: () {
                          setState(() {
                            selectedRole = role;
                          });
                          Navigator.pop(context);
                        },
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.borderColor,
                        thickness: 0.5,
                      ),
                    ],
                  );
                }).toList(),
          ),
        );
      },
    );
  }

  Future<String?> showDatePicker(BuildContext context, bool today) {
    DateTime? initialDate;
    DateTime? selectedDate;
    if (widget.updateEmployee) {
      if (today) {
        initialDate = _startDate;
      }

      if (_endDate != null) {
        initialDate = _endDate;
      }
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(16),
                height: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!today) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                initialDate = null;
                                selectedDate = null;
                                calendarKey = UniqueKey();
                                selected = 1;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 1
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "No Date",
                                    style: TextStyle(
                                      color:
                                          selected == 1
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                initialDate = DateTime.now();
                                selectedDate = initialDate;
                                calendarKey = UniqueKey();
                                selected = 2;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 2
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      color:
                                          selected == 2
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (today) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                initialDate = DateTime.now();
                                selectedDate = initialDate;
                                calendarKey = UniqueKey();
                                selected = 1;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 1
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "Today",
                                    style: TextStyle(
                                      color:
                                          selected == 1
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                initialDate = getNextMonday();
                                selectedDate = initialDate;
                                calendarKey = UniqueKey();
                                selected = 2;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 2
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "Next Monday",
                                    style: TextStyle(
                                      color:
                                          selected == 2
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                initialDate = getNextTuesday();
                                selectedDate = initialDate;
                                calendarKey = UniqueKey();
                                selected = 3;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 3
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "Next Tuesday",
                                    style: TextStyle(
                                      color:
                                          selected == 3
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                initialDate = getNextWeek();
                                selectedDate = initialDate;
                                calendarKey = UniqueKey();
                                selected = 4;
                                setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      selected == 4
                                          ? AppColors.primaryColor
                                          : AppColors.primaryColor.withOpacity(
                                            0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    "After 1 week",
                                    style: TextStyle(
                                      color:
                                          selected == 4
                                              ? AppColors.whiteColor
                                              : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    Expanded(
                      child: CalendarDatePicker(
                        key: calendarKey,
                        initialDate:
                            today ? initialDate ?? DateTime.now() : initialDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          selectedDate  = date;

                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.kCalender,
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              !today
                                  ? _endDate == null
                                      ? "No date"
                                      : DateFormat(
                                        'd MMM yyyy',
                                      ).format(_endDate!)
                                  : DateFormat(
                                    'd MMM yyyy',
                                  ).format(_startDate!),
                              style: TextStyle(
                                color: AppColors.headerTextColor,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                if (today) {
                                  _startDate = selectedDate;
                                } else {
                                  _endDate = selectedDate;
                                }
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: AppColors.whiteColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  DateTime getNextMonday() {
    DateTime today = DateTime.now();
    int daysUntilMonday = (DateTime.monday - today.weekday) % 7;
    if (daysUntilMonday == 0)
      daysUntilMonday = 7; // Ensure it selects next Monday
    return today.add(Duration(days: daysUntilMonday));
  }

  DateTime getNextTuesday() {
    DateTime today = DateTime.now();
    int daysUntilTuesday = (DateTime.tuesday - today.weekday) % 7;
    if (daysUntilTuesday == 0)
      daysUntilTuesday = 7; // Ensure it selects next Tuesday
    return today.add(Duration(days: daysUntilTuesday));
  }

  DateTime getNextWeek() {
    DateTime today = DateTime.now();
    return today.add(
      Duration(days: 7),
    ); // Add 7 days to get next week's same day
  }

  String getUniqueStringId() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
