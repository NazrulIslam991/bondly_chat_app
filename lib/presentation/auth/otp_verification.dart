import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/constant/style_manager.dart';
import '../../core/resources/themes/app_theme.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final int _otpLength = 4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = "+8801XXXXXXXX";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorManager.whiteColor,
            size: 24.r,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Verify your number',
                style: getSemiBoldStyle28_600(color: ColorManager.whiteColor),
              ),
              SizedBox(height: 10.h),

              Text(
                'We have sent an SMS with an activation code to your phone number $phoneNumber.',
                style: getRegularStyle14_400(color: ColorManager.gray),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),

              GestureDetector(
                onTap: () {
                  _otpFocusNode.requestFocus();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_otpLength, (index) {
                        String character = "";
                        if (_otpController.text.length > index) {
                          character = _otpController.text[index];
                        }

                        bool isFocused =
                            _otpFocusNode.hasFocus &&
                            _otpController.text.length == index;

                        return Container(
                          width: 50.w,
                          height: 60.h,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isFocused
                                    ? AppTheme.primary
                                    : ColorManager.primary.withOpacity(0.4),
                                width: isFocused ? 2.5 : 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            character,
                            style: getMediumStyle18_500(
                              color: ColorManager.whiteColor,
                            ).copyWith(fontSize: 24.sp),
                          ),
                        );
                      }),
                    ),

                    Opacity(
                      opacity: 0.01,
                      child: TextField(
                        controller: _otpController,
                        focusNode: _otpFocusNode,
                        keyboardType: TextInputType.number,
                        maxLength: _otpLength,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 1,
                        ),
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                          if (value.length == _otpLength) {
                            _verifyOtp();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: getRegularStyle14_400(color: ColorManager.gray),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(
                      'Resend',
                      style: getMediumStyle14_500(color: AppTheme.primary),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: _verifyOtp,
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

  void _verifyOtp() {
    if (_otpController.text.length == _otpLength) {
      // Navigator.pushNamedAndRemoveUntil(context, RouteName.homeScreen, (route) => false);
    }
  }
}
