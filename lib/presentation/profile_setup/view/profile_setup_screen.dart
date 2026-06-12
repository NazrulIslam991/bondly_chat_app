import 'dart:ui';

import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/core/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 3;

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Selected Tags for Step 3
  final List<String> _availableTags = [
    'Tech 💻',
    'Music 🎵',
    'Gaming 🎮',
    'Movies 🎬',
    'Sports ⚽',
    'Art 🎨',
    'Travel ✈️',
    'Food 🍔',
    'Anime 💮',
    'Fitness 💪',
  ];
  final List<String> _selectedTags = [];

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.navbarScreen,
        (predicate) => false,
      );
    }
  }

  void _onPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.blackColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? GestureDetector(
                          onTap: _onPreviousPage,
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: ColorManager.whiteColor,
                              size: 16.r,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: ColorManager.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '${_currentPage + 1} / $_totalSteps',
                      style: getMediumStyle14_500(color: ColorManager.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              Stack(
                children: [
                  Container(
                    height: 5.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 5.h,
                    width:
                        MediaQuery.of(context).size.width *
                            ((_currentPage + 1) / _totalSteps) -
                        48.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.primary,
                          ColorManager.primary.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.07),
                          width: 1.2,
                        ),
                      ),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          _buildStepOne(),
                          _buildStepTwo(),
                          _buildStepThree(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currentPage == 0
                        ? 'Welcome to Bondly'
                        : _currentPage == 1
                        ? 'Almost there'
                        : 'Final touch!',
                    style: getRegularStyle14_400(color: ColorManager.gray),
                  ),
                  FloatingActionButton.extended(
                    onPressed: _onNextPage,
                    backgroundColor: ColorManager.primary,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    label: Row(
                      children: [
                        Text(
                          _currentPage == _totalSteps - 1 ? 'Finish' : 'Next',
                          style: getMediumStyle16_500(color: Colors.white),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          _currentPage == _totalSteps - 1
                              ? Icons.done_all
                              : Icons.arrow_forward,
                          size: 18.r,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- STEP 1: Profile Picture & Name ---
  Widget _buildStepOne() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create Profile',
            style: getSemiBoldStyle28_600(color: ColorManager.whiteColor),
          ),
          SizedBox(height: 8.h),
          Text(
            'Let the community know who you are.',
            style: getRegularStyle14_400(color: ColorManager.gray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 124.r,
                height: 124.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.primary,
                      Colors.deepPurpleAccent,
                      ColorManager.primary.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 58.r,
                backgroundColor: Colors.black,
                child: CircleAvatar(
                  radius: 54.r,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  child: Icon(
                    Icons.blur_on_rounded,
                    size: 45.r,
                    color: ColorManager.primary,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: ColorManager.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_enhance_rounded,
                    size: 16.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),

          _buildCustomInputField(
            controller: _firstNameController,
            hintText: 'First Name',
            icon: Icons.person_outline_rounded,
          ),
          SizedBox(height: 20.h),

          _buildCustomInputField(
            controller: _lastNameController,
            hintText: 'Last Name',
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }

  // --- STEP 2: Username & Bio ---
  Widget _buildStepTwo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Handlers',
            style: getSemiBoldStyle28_600(color: ColorManager.whiteColor),
          ),
          SizedBox(height: 8.h),
          Text(
            'Pick a unique handle so friends can find you instantly.',
            style: getRegularStyle14_400(color: ColorManager.gray),
          ),
          SizedBox(height: 32.h),

          _buildCustomInputField(
            controller: _usernameController,
            hintText: 'username',
            icon: Icons.alternate_email_rounded,
          ),
          SizedBox(height: 24.h),

          _buildCustomInputField(
            controller: _bioController,
            hintText: 'Describe yourself in a few words...',
            icon: Icons.notes_rounded,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // --- STEP 3: Interests / Tags ---
  Widget _buildStepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests & Vibes',
          style: getSemiBoldStyle28_600(color: ColorManager.whiteColor),
        ),
        SizedBox(height: 8.h),
        Text(
          'We will match you with people who share the same core energy.',
          style: getRegularStyle14_400(color: ColorManager.gray),
        ),
        SizedBox(height: 28.h),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 12.h,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorManager.primary.withOpacity(0.15)
                          : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: isSelected
                            ? ColorManager.primary
                            : Colors.white.withOpacity(0.1),
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ColorManager.primary.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      tag,
                      style: getMediumStyle14_500(
                        color: isSelected
                            ? ColorManager.whiteColor
                            : ColorManager.gray,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: getMediumStyle16_500(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: ColorManager.primary.withOpacity(0.6),
            size: 20.r,
          ),
          hintStyle: getRegularStyle14_400(color: ColorManager.textSecondary),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 16.w,
          ),
        ),
      ),
    );
  }
}
