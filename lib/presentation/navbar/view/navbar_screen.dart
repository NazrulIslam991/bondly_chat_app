import 'dart:ui';

import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../../ai_chat/view/ai_chat_screen.dart';
import '../../chat/view/chat_list_screen.dart';
import '../../setting/view/setting_screen.dart';
import '../../storys/view/story_screen.dart';
import '../viewmodel/navbar_viewmodel.dart';

class NavbarScreen extends ConsumerWidget {
  const NavbarScreen({super.key});

  /// ************* screen list ********************
  static final List<Widget> _screens = [
    ChatListScreen(),
    AIChatScreen(),
    StoryScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navbarProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _screens[selectedIndex],

          Positioned(
            left: 20.w,
            right: 20.w,
            bottom: 14.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 72.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(10),
                    borderRadius: BorderRadius.circular(28.r),
                    border: Border.all(
                      color: Colors.white.withAlpha(10),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
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
                        ref: ref,
                        index: 0,
                        currentIndex: selectedIndex,
                        icon: Icons.chat_bubble_outline_rounded,
                        activeIcon: Icons.chat_bubble_rounded,
                        label: 'Chats',
                      ),
                      _buildNavItem(
                        ref: ref,
                        index: 1,
                        currentIndex: selectedIndex,
                        icon: Icons.auto_awesome_outlined,
                        activeIcon: Icons.auto_awesome_rounded,
                        label: 'AI',
                      ),
                      _buildNavItem(
                        ref: ref,
                        index: 2,
                        currentIndex: selectedIndex,
                        icon: Icons.camera_outdoor_outlined,
                        activeIcon: Icons.camera_rounded,
                        label: 'Stories',
                      ),
                      _buildNavItem(
                        ref: ref,
                        index: 3,
                        currentIndex: selectedIndex,
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
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(navbarProvider.notifier).updateIndex(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primary.withAlpha(25)
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
