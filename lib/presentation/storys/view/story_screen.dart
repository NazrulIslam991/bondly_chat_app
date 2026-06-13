import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/story_viewer_screen.dart';

/// **************************************************************************
/// DATA MODEL FOR VERTICAL USER STORIES LAYER
/// **************************************************************************
class UserStoryGroupModel {
  final String userName;
  final String userAvatar;
  final String uploadTime;
  final bool isUnread;
  final List<String> stories;

  const UserStoryGroupModel({
    required this.userName,
    required this.userAvatar,
    required this.uploadTime,
    required this.isUnread,
    required this.stories,
  });
}

/// **************************************************************************
/// PRODUCTION READY PREMIUM VERTICAL STORIES FEED SCREEN
/// **************************************************************************
class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  /// **************************************************************************
  /// MOCK DATA SOURCE STREAM WITH IMAGE ARRAYS
  /// **************************************************************************
  final List<UserStoryGroupModel> _verticalStories = [
    const UserStoryGroupModel(
      userName: 'Samantha Doe',
      userAvatar:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      uploadTime: 'Just now',
      isUnread: true,
      stories: [
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&auto=format&fit=crop&q=80',
      ],
    ),
    const UserStoryGroupModel(
      userName: 'Alex Mercer',
      userAvatar:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
      uploadTime: '45 minutes ago',
      isUnread: true,
      stories: [
        'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800&auto=format&fit=crop&q=80',
      ],
    ),
    const UserStoryGroupModel(
      userName: 'John Lawson',
      userAvatar:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
      uploadTime: '2 hours ago',
      isUnread: false,
      stories: [
        'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800&auto=format&fit=crop&q=80',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Updates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          /// Personal Status Anchor
          ListTile(
            leading: CircleAvatar(
              radius: 26.r,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&auto=format&fit=crop&q=80',
              ),
            ),
            title: Text(
              'My Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Tap to add status update',
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: const Divider(color: Colors.white10, thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              'Recent updates',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// Dynamic Vertical List Builder
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _verticalStories.length,
            separatorBuilder: (context, index) => SizedBox(height: 4.h),
            itemBuilder: (context, index) {
              final storyItem = _verticalStories[index];
              return ListTile(
                /// **************************************************************************
                /// INTERACTIVE ROUTING CHANNEL PUSHING TO OVERLAY SCREEN
                /// **************************************************************************
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StoryViewOverlay()),
                  );
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 2.h,
                ),
                leading: Container(
                  padding: EdgeInsets.all(2.5.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: storyItem.isUnread
                          ? Colors.greenAccent
                          : Colors.white24,
                      width: 2.5.r,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 23.r,
                    backgroundImage: NetworkImage(storyItem.userAvatar),
                  ),
                ),
                title: Text(
                  storyItem.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  storyItem.uploadTime,
                  style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                ),
                trailing: storyItem.isUnread
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withAlpha(30),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${storyItem.stories.length} New',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
