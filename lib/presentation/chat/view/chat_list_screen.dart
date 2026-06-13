import 'dart:ui';

import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/core/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../../widgets/story_viewer_screen.dart';
import '../viewmodel/chat_view_model.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  /// **************************************************************************
  /// STATIC ACTIVE USERS DATA SOURCE
  /// Temporary mocked local collection defining online statuses, asset links,
  /// and dynamic flag definitions for rendering real-time user story badges.
  /// **************************************************************************
  static const List<Map<String, dynamic>> _activeUsers = [
    {
      'name': 'Alex',
      'image':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      'hasStory': true,
    },
    {
      'name': 'Tajimul',
      'image':
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
      'hasStory': true,
    },
    {
      'name': 'Arif',
      'image':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&auto=format&fit=crop&q=80',
      'hasStory': true,
    },
    {'name': 'Sharabon', 'image': null, 'hasStory': false},
    {
      'name': 'Kamrul',
      'image':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
      'hasStory': true,
    },
    {
      'name': 'Sazedul',
      'image':
          'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&auto=format&fit=crop&q=80',
      'hasStory': false,
    },
  ];

  /// **************************************************************************
  /// DECLARATIVE UI SCENE BLUEPRINT BUILDER
  /// Observes active Riverpod active chat data structures and handles building
  /// global frame configurations like floating control buttons and app head panels.
  /// **************************************************************************
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.black,

      /// **************************************************************************
      /// FLOATING FLOATING ACTION BUTTON
      /// Interactive access point located above bottom bars to initiate clean
      /// connection streams or setup modern active messaging instances.
      /// **************************************************************************
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100.h),
        child: FloatingActionButton(
          backgroundColor: ColorManager.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          onPressed: () {},
          child: Icon(
            Icons.add_comment_rounded,
            color: Colors.white,
            size: 24.r,
          ),
        ),
      ),

      /// **************************************************************************
      /// APP BAR NAVIGATION PANEL
      /// Minimalistic background branding banner exposing structural filters and
      /// contextual searching icons.
      /// **************************************************************************
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bondly Chats',
          style: getSemiBoldStyle18_600(color: Colors.white),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.search_rounded, color: Colors.white, size: 22.r),
              onPressed: () {},
            ),
          ),
        ],
      ),

      /// **************************************************************************
      /// MAIN SCREEN DISPLAY BODY
      /// Orchestrates individual content sections sequentially: Active horizontal
      /// story bubbles, Recent chat dividers, and the primary vertical list stream.
      /// **************************************************************************
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          /// Horizontal Active Users Viewport Matrix
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _activeUsers.length,
              itemBuilder: (context, index) {
                final user = _activeUsers[index];
                final bool hasStory = user['hasStory'] ?? false;

                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (hasStory) {
                            _showStoryActionPopup(context, user);
                          } else {
                            Navigator.pushNamed(context, RouteName.chatScreen);
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: hasStory
                                    ? const LinearGradient(
                                        colors: [
                                          ColorManager.primary,
                                          Colors.deepPurpleAccent,
                                        ],
                                      )
                                    : null,
                                border: hasStory
                                    ? null
                                    : Border.all(
                                        color: Colors.white.withAlpha(51),
                                        width: 1.5.r,
                                      ),
                              ),
                              child: _buildNetworkAvatar(
                                radius: 26.r,
                                imageUrl: user['image'],
                                name: user['name'] ?? 'U',
                              ),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: CircleAvatar(
                                radius: 6.r,
                                backgroundColor: Colors.green,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        user['name'] ?? '',
                        style: getRegularStyle12_400(color: ColorManager.gray),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Text(
              'Recent Chats',
              style: getMediumStyle14_500(color: ColorManager.textSecondary),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              physics: const BouncingScrollPhysics(),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _buildChatTile(context, chat);
              },
            ),
          ),
          SizedBox(height: 90.h),
        ],
      ),
    );
  }

  /// **************************************************************************
  /// PRESENT GLASSMORPHIC STORY OVERLAY DIALOGUE
  /// Renders responsive multi-action hubs utilizing fluid scale physics, deep
  /// Gaussian frost elements, and tailored routing options for each identity profile.
  /// **************************************************************************
  void _showStoryActionPopup(BuildContext context, Map<String, dynamic> user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'StoryActionPopup',
      barrierColor: Colors.black.withAlpha(100),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 12 * animation.value,
                sigmaY: 12 * animation.value,
              ),
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withAlpha(160),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.white.withAlpha(25), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNetworkAvatar(
                  radius: 32.r,
                  imageUrl: user['image'],
                  name: user['name'] ?? 'U',
                ),
                SizedBox(height: 12.h),
                Text(
                  user['name'] ?? 'User',
                  style: getSemiBoldStyle16_600(color: Colors.white),
                ),
                SizedBox(height: 20.h),
                ListTile(
                  leading: const Icon(
                    Icons.blur_circular_rounded,
                    color: ColorManager.primary,
                  ),
                  title: Text(
                    'See Story',
                    style: getMediumStyle14_500(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showStoryView(context, user);
                  },
                ),
                Divider(color: Colors.white.withAlpha(20)),
                ListTile(
                  leading: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: ColorManager.gray,
                  ),
                  title: Text(
                    'Send Message',
                    style: getMediumStyle14_500(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, RouteName.chatScreen);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// **************************************************************************
  /// LAUNCH FULL-SCREEN IMMERSIVE STORY TIMELINE
  /// Dispatches full screen modal overlays configured with immersive dark canvases
  /// to view temporary visual content published by targeted user entities.
  /// **************************************************************************
  void _showStoryView(BuildContext context, Map<String, dynamic> user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Story',
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StoryViewOverlay();
      },
    );
  }

  /// **************************************************************************
  /// CONSTRUCT INTERACTIVE HISTORICAL CHAT SLOTS
  /// Generates dynamic card matrices containing active online status indicators,
  /// smart multi-line string truncation safeguards, and context counters for unread signals.
  /// **************************************************************************
  Widget _buildChatTile(BuildContext context, ChatTileModel chat) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.chatScreen);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withAlpha(10)),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          leading: Stack(
            children: [
              _buildNetworkAvatar(
                radius: 26.r,
                imageUrl: chat.imageUrl,
                name: chat.name,
              ),
              if (chat.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 6.r,
                    backgroundColor: Colors.green,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            chat.name,
            style: getSemiBoldStyle16_600(color: Colors.white),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              chat.lastMessage,
              style: getRegularStyle14_400(
                color: chat.unreadCount > 0
                    ? ColorManager.whiteColor
                    : ColorManager.gray,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: getRegularStyle12_400(
                  color: chat.unreadCount > 0
                      ? ColorManager.primary
                      : ColorManager.textSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              chat.unreadCount > 0
                  ? Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: ColorManager.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${chat.unreadCount}',
                        style: getRegularStyle12_400(color: Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.done_all_rounded,
                      size: 16.r,
                      color: chat.isReadByMe
                          ? ColorManager.primary
                          : ColorManager.textSecondary,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// **************************************************************************
  /// GENERATE ASYNC NETWORK AVATAR LAYER
  /// Safely downloads media endpoints with integrated micro circular progress blocks,
  /// routing smoothly towards letter placeholders if unexpected connection drops occur.
  /// **************************************************************************
  Widget _buildNetworkAvatar({
    required double radius,
    required String? imageUrl,
    required String name,
  }) {
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: radius * 2,
                    height: radius * 2,
                    color: Colors.white.withAlpha(13),
                    child: Center(
                      child: SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorManager.primary.withAlpha(102),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackInitial(radius, initial),
              )
            : _buildFallbackInitial(radius, initial),
      ),
    );
  }

  /// **************************************************************************
  /// BUILD FALLBACK INITIAL DESIGN
  /// Constructs an elegant, styled circular text box featuring high-contrast neon
  /// character metrics to display when image components are completely absent.
  /// **************************************************************************
  Widget _buildFallbackInitial(double radius, String initial) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primary.withAlpha(51),
            Colors.blueGrey.withAlpha(76),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: getSemiBoldStyle16_600(color: ColorManager.primary),
        ),
      ),
    );
  }
}
