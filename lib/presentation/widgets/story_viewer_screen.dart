import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **************************************************************************
/// PRODUCTION READY PREMIUM STORY VIEW SCREEN
/// **************************************************************************
class StoryViewOverlay extends StatefulWidget {
  const StoryViewOverlay({super.key});

  @override
  State<StoryViewOverlay> createState() => _StoryViewOverlayState();
}

class _StoryViewOverlayState extends State<StoryViewOverlay>
    with SingleTickerProviderStateMixin {
  /// **************************************************************************
  /// ANIMATION & CONTROLLER CONFIGURATIONS
  /// **************************************************************************
  late AnimationController _animationController;
  int _currentStoryIndex = 0;

  /// Mock Story Data Stream Array
  final List<String> _storyImages = [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800&auto=format&fit=crop&q=80',
  ];

  @override
  void initState() {
    super.initState();

    // Dynamic 5-second progress frame configuration
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _loadStory(index: _currentStoryIndex);

    // Auto-advancing logic gate trigger when animation finished
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// **************************************************************************
  /// CORE NAVIGATION ARCHITECTURE
  /// **************************************************************************
  void _loadStory({required int index}) {
    _animationController.stop();
    _animationController.reset();
    _animationController.forward();
  }

  void _nextStory() {
    if (_currentStoryIndex < _storyImages.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _loadStory(index: _currentStoryIndex);
    } else {
      // Closes layer smoothly if all stories read completely
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _loadStory(index: _currentStoryIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// **************************************************************************
          /// FULLSCREEN HIGH-RES IMAGE COMPONENT
          /// **************************************************************************
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) =>
                  _animationController.stop(), // Pause on hold down
              onTapUp: (details) {
                // Screen tap segment coordinate partitioning
                final double screenWidth = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < screenWidth * 0.3) {
                  _previousStory();
                } else {
                  _nextStory();
                }
              },
              child: Image.network(
                _storyImages[_currentStoryIndex],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),

          /// **************************************************************************
          /// GRADIENT LAYER (TOP & BOTTOM OVERLAYS FOR OPTIMAL VISIBILITY)
          /// **************************************************************************
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withAlpha(160),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withAlpha(160),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),

          /// **************************************************************************
          /// INTERACTIVE METADATA & PROGRESS BAR TOPPERS
          /// **************************************************************************
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.h),

                    /// **************************************************************************
                    /// INSTAGRAM-STYLE MULTIPLE PROGRESS STEPS INDICATOR
                    /// **************************************************************************
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: List.generate(
                          _storyImages.length,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  double progressValue = 0.0;
                                  if (index < _currentStoryIndex) {
                                    progressValue = 1.0;
                                  } else if (index == _currentStoryIndex) {
                                    progressValue = _animationController.value;
                                  }
                                  return LinearProgressIndicator(
                                    value: progressValue,
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    minHeight: 3.h,
                                    borderRadius: BorderRadius.circular(2.r),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    /// **************************************************************************
                    /// USER PROFILE CONTROLLER HEADER
                    /// **************************************************************************
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage: const NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Samantha_Doe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '2 hrs ago',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// **************************************************************************
                /// BOTTOM INTERACTIVE INPUT UTILITY SYSTEM
                /// **************************************************************************
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(color: Colors.white38, width: 1),
                            color: Colors.transparent,
                          ),
                          child: TextField(
                            onTap: () => _animationController
                                .stop(), // Pause execution on typing
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              filled: false,
                              hintText: 'Send message...',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 14.sp,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),

                      /// Quick Share Action Node
                      GestureDetector(
                        onTap: () {
                          // Execution channel trigger for sharing action
                        },
                        child: Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white12,
                          ),
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
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
