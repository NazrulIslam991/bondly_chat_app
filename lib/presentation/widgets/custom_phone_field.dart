import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/core/resources/constant/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/themes/app_theme.dart';

class CustomPhoneField extends StatelessWidget {
  final String countryCode;
  final TextEditingController controller;
  final String hintText;

  const CustomPhoneField({
    super.key,
    required this.countryCode,
    required this.controller,
    this.hintText = '00000-00000',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 75.w,
          height: 50.h,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.primary, width: 1),
            ),
          ),
          child: Text(
            countryCode,
            style: getSemiBoldStyle18_600(color: Colors.white),
          ),
        ),
        SizedBox(width: 16.w),

        // Main Phone Number Field
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorManager.primary, width: 1),
              ),
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: getSemiBoldStyle18_600(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
