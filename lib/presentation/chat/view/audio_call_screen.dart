import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/color_manager.dart';
import '../../../core/resources/constant/style_manager.dart';

/// **************************************************************************
/// REALISTIC AUDIO CALL OVERLAY SCREEN (UI ONLY)
/// **************************************************************************
class AudioCallScreen extends StatefulWidget {
  final String userName;
  final String imageUrl;

  const AudioCallScreen({
    super.key,
    required this.userName,
    required this.imageUrl,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  /// **************************************************************************
  /// STATE VARIABLES
  /// **************************************************************************
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// **************************************************************************
          /// BACKGROUND LAYER (BLURRED AVATAR EFFECT)
          /// **************************************************************************
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.black.withAlpha(160)),
            ),
          ),

          /// **************************************************************************
          /// MAIN INTERACTIVE CONTENT LAYER
          /// **************************************************************************
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// **************************************************************************
                /// TOP METADATA SECTION (CALL DETAILS)
                /// **************************************************************************
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Column(
                    children: [
                      Text(
                        'Voice Call',
                        style: getRegularStyle14_400(
                          color: Colors.white60,
                        ).copyWith(letterSpacing: 1.2),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        widget.userName,
                        style: getSemiBoldStyle18_600(
                          color: Colors.white,
                        ).copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Ringing...",
                        style: getMediumStyle14_500(
                          color: ColorManager.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// **************************************************************************
                /// CENTER DISPLAY SECTION (AVATAR FRAME GRID)
                /// **************************************************************************
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160.r,
                        height: 160.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.primary.withAlpha(20),
                          border: Border.all(
                            color: ColorManager.primary.withAlpha(40),
                            width: 2,
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          widget.imageUrl,
                          width: 130.r,
                          height: 130.r,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => CircleAvatar(
                            radius: 65.r,
                            backgroundColor: Colors.grey[800],
                            child: Icon(
                              Icons.person,
                              size: 60.r,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// **************************************************************************
                /// LOWER DASHBOARD SECTION (ACTION NODES CONTROL)
                /// **************************************************************************
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCallActionBtn(
                        icon: _isMuted
                            ? Icons.mic_off_rounded
                            : Icons.mic_rounded,
                        label: 'Mute',
                        isActive: _isMuted,
                        onTap: () => setState(() => _isMuted = !_isMuted),
                      ),
                      _buildCallActionBtn(
                        icon: Icons.call_end_rounded,
                        label: 'End',
                        btnColor: Colors.redAccent,
                        iconColor: Colors.white,
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildCallActionBtn(
                        icon: _isSpeakerOn
                            ? Icons.volume_up_rounded
                            : Icons.volume_down_rounded,
                        label: 'Speaker',
                        isActive: _isSpeakerOn,
                        onTap: () =>
                            setState(() => _isSpeakerOn = !_isSpeakerOn),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// **************************************************************************
/// GENERIC CALL CIRCULAR BUTTON ASSET
/// **************************************************************************
Widget _buildCallActionBtn({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color? btnColor,
  Color? iconColor,
  bool isActive = false,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                btnColor ??
                (isActive ? Colors.white : Colors.white.withAlpha(40)),
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? (isActive ? Colors.black : Colors.white),
            size: 24.r,
          ),
        ),
      ),
      SizedBox(height: 8.h),
      Text(
        label,
        style: getRegularStyle12_400(
          color: Colors.white70,
        ).copyWith(fontSize: 11.sp),
      ),
    ],
  );
}
