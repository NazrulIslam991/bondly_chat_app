import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/constant/style_manager.dart';

class StoryViewOverlay extends StatefulWidget {
  final Map<String, dynamic> user;
  const StoryViewOverlay({super.key, required this.user});

  @override
  State<StoryViewOverlay> createState() => _StoryViewOverlayState();
}

class _StoryViewOverlayState extends State<StoryViewOverlay> {
  double _progressValue = 0.0;
  Timer? _timer;
  final int _storyDurationInSeconds = 5;
  bool _isPaused = false;

  final int _ticks = 100;
  late int _intervalInMs;

  final String _hdStoryImageUrl =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=1000&auto=format&fit=crop';

  @override
  void initState() {
    super.initState();
    _intervalInMs = (_storyDurationInSeconds * 1000) ~/ _ticks;
    _startStoryTimer();
  }

  void _startStoryTimer() {
    _timer = Timer.periodic(Duration(milliseconds: _intervalInMs), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_progressValue >= 1.0) {
            _timer?.cancel();
            Navigator.pop(context);
          } else {
            _progressValue += 1.0 / _ticks;
          }
        });
      }
    });
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeStory() {
    setState(() {
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onLongPress: _pauseStory,
          onLongPressUp: _resumeStory,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  _hdStoryImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Container(
                      color: Colors.grey[900]?.withAlpha(200),
                      child: Center(
                        child: SizedBox(
                          width: 32.r,
                          height: 32.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withAlpha(100),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.blueGrey.withAlpha(51),
                    child: Center(
                      child: Text(
                        "${widget.user['name']}'s Story Slot",
                        style: getMediumStyle16_500(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _progressValue = 0.0;
                          });
                        },
                        child: const SizedBox.expand(),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _timer?.cancel();
                          Navigator.pop(context);
                        },
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 10.h,
                    left: 16.w,
                    right: 16.w,
                    bottom: 20.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withAlpha(180), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        value: _progressValue,
                        backgroundColor: Colors.white.withAlpha(60),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        minHeight: 2.5.h,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Container(
                            width: 36.r,
                            height: 36.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: ClipOval(
                              child:
                                  widget.user['image'] != null &&
                                      widget.user['image'].isNotEmpty
                                  ? Image.network(
                                      widget.user['image'],
                                      width: 36.r,
                                      height: 36.r,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.blueGrey.withAlpha(102),
                                      child: Center(
                                        child: Text(
                                          widget.user['name']?.isNotEmpty ==
                                                  true
                                              ? widget.user['name'][0]
                                                    .toUpperCase()
                                              : 'U',
                                          style: getRegularStyle14_400(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            widget.user['name'] ?? '',
                            style: getMediumStyle14_500(color: Colors.white),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
