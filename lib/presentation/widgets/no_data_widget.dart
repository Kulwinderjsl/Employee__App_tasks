import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:round2_employee_app/core/app_assets.dart';

Widget noDataWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(AppAssets.kNoDataFound,),

    ],
  );
}
