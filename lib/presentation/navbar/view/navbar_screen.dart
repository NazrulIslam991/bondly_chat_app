import 'dart:ui';

import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../../chat/view/chat_list_screen.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ChatListScreen(),
    const Center(
      child: Text(
        'Groups Screen',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    const Center(
      child: Text(
        'Stories Screen',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    const Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _screens[_selectedIndex],

          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 24.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 72.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        index: 0,
                        icon: Icons.chat_bubble_outline_rounded,
                        activeIcon: Icons.chat_bubble_rounded,
                        label: 'Chats',
                      ),
                      _buildNavItem(
                        index: 1,
                        icon: Icons.groups_outlined,
                        activeIcon: Icons.groups_rounded,
                        label: 'Groups',
                      ),
                      _buildNavItem(
                        index: 2,
                        icon: Icons.camera_outdoor_outlined,
                        activeIcon: Icons.camera_rounded,
                        label: 'Stories',
                      ),
                      _buildNavItem(
                        index: 3,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings_rounded,
                        label: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? ColorManager.primary : ColorManager.gray,
              size: 24.r,
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: isSelected
                  ? getMediumStyle12_500(color: ColorManager.primary)
                  : getRegularStyle12_400(color: ColorManager.gray),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
