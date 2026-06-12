import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/core/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../viewmodel/chat_view_model.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  static const List<Map<String, String?>> _activeUsers = [
    {
      'name': 'Alex',
      'image':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    },
    {
      'name': 'Tajimul',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    },
    {
      'name': 'Arif',
      'image':
          'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=150',
    },
    {'name': 'Sharabon', 'image': null},
    {
      'name': 'Kamrul',
      'image':
          'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
    },
    {
      'name': 'Sazedul',
      'image':
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=150',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80.h),
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
              color: Colors.white.withOpacity(0.04),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.search_rounded, color: Colors.white, size: 22.r),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          // Top Active Users Horizontal List
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _activeUsers.length,
              itemBuilder: (context, index) {
                final user = _activeUsers[index];
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  ColorManager.primary,
                                  Colors.deepPurpleAccent,
                                ],
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

  Widget _buildChatTile(BuildContext context, ChatTileModel chat) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.chatScreen);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
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

  Widget _buildNetworkAvatar({
    required double radius,
    required String? imageUrl,
    required String name,
  }) {
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.black,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
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
                    color: Colors.white.withOpacity(0.05),
                    child: Center(
                      child: SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorManager.primary.withOpacity(0.4),
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

  Widget _buildFallbackInitial(double radius, String initial) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primary.withOpacity(0.2),
            Colors.blueGrey.withOpacity(0.3),
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
