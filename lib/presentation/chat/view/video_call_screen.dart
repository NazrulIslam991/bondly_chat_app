import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';

/// **************************************************************************
/// REALISTIC VIDEO CALL OVERLAY SCREEN (UI ONLY)
/// **************************************************************************
class VideoCallScreen extends StatefulWidget {
  final String userName;
  final String imageUrl;

  const VideoCallScreen({
    super.key,
    required this.userName,
    required this.imageUrl,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  /// **************************************************************************
  /// STATE VARIABLES
  /// **************************************************************************
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// **************************************************************************
          /// MAIN FULLSCREEN BACKGROUND VIDEO LAYER (REMOTE STREAM SIMULATION)
          /// **************************************************************************
          Positioned.fill(
            child: _isVideoOff
                ? Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: Icon(
                        Icons.videocam_off_rounded,
                        color: Colors.white24,
                        size: 64.r,
                      ),
                    ),
                  )
                : Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),

          /// **************************************************************************
          /// HIGH END GRADIENT OVERLAY (FOR CONTENT LEGIBILITY CONTRAST)
          /// **************************************************************************
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(180),
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// **************************************************************************
          /// LOCAL USER FLOATING PREVIEW BOX (PIP MODE SIMULATION)
          /// **************************************************************************
          Positioned(
            top: 50.h,
            right: 20.w,
            child: Container(
              width: 100.w,
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white30, width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=60',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          /// **************************************************************************
          /// INTERACTIVE METADATA & ACTIONS CONTROL OVERLAY
          /// **************************************************************************
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **************************************************************************
                /// TOP METADATA SECTION (CALL COMPONENT DETAILS)
                /// **************************************************************************
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: getSemiBoldStyle18_600(color: Colors.white)
                            .copyWith(
                              fontSize: 22.sp,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Ringing...",
                        style: getMediumStyle14_500(color: Colors.amberAccent),
                      ),
                    ],
                  ),
                ),

                /// **************************************************************************
                /// BOTTOM UTILITIES CONTROL BAR (ACTION NODES GRID)
                /// **************************************************************************
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
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
                        icon: _isVideoOff
                            ? Icons.videocam_off_rounded
                            : Icons.videocam_rounded,
                        label: 'Camera',
                        isActive: _isVideoOff,
                        onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                      ),
                      _buildCallActionBtn(
                        icon: Icons.switch_camera_rounded,
                        label: 'Flip',
                        onTap: () {},
                      ),
                      _buildCallActionBtn(
                        icon: Icons.call_end_rounded,
                        label: 'End',
                        btnColor: Colors.redAccent,
                        iconColor: Colors.white,
                        onTap: () => Navigator.pop(context),
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
