import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/core/routes/route_name.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/constant/style_manager.dart';
import '../../core/resources/themes/app_theme.dart';
import '../widgets/custom_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = "+880";
  String _selectedCountryName = "Bangladesh";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Enter your phone number',
                style: getSemiBoldStyle28_600(color: ColorManager.whiteColor),
              ),
              SizedBox(height: 10.h),

              Text(
                'Bondly will send an SMS message to verify your phone number. Enter your country code and phone number.',
                style: getRegularStyle14_400(color: ColorManager.gray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),

              // Country Picker Line
              countryFlagAndName(context),
              SizedBox(height: 16.h),

              CustomPhoneField(
                countryCode: _selectedCountryCode,
                controller: _phoneController,
              ),

              const Spacer(),

              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.otpScreen);
                  },
                  backgroundColor: AppTheme.primary,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24.r,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget countryFlagAndName(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorManager.primary, width: 1),
        ),
      ),
      child: CountryCodePicker(
        onChanged: (country) {
          setState(() {
            _selectedCountryCode = country.dialCode ?? "+880";
            _selectedCountryName = country.name ?? "Bangladesh";
          });
        },
        initialSelection: 'BD',
        favorite: const ['BD', 'US', 'IN'],
        showCountryOnly: true,
        showOnlyCountryWhenClosed: true,
        alignLeft: true,

        dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        boxDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [],
        ),
        dialogTextStyle: getMediumStyle14_500(color: Colors.white),
        searchStyle: getRegularStyle14_400(color: Colors.white),

        searchDecoration: InputDecoration(
          hintText: 'Search country...',
          hintStyle: getRegularStyle14_400(color: AppTheme.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),

        builder: (CountryCode? countryCode) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                if (countryCode?.flagUri != null) ...[
                  Image.asset(
                    countryCode!.flagUri!,
                    package: 'country_code_picker',
                    width: 22.w,
                  ),
                  SizedBox(width: 14.w),
                ],
                Expanded(
                  child: Text(
                    _selectedCountryName,
                    style: getMediumStyle16_500(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppTheme.primary,
                  size: 26.r,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
