import 'dart:ui';

import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:bondly/presentation/chat/view/video_call_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../viewmodel/chat_view_model.dart';
import 'audio_call_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Local state for user interactions within this session
  bool _isMuted = false;
  bool _isBlocked = false;

  /// **************************************************************************
  /// INITIALIZE STATE LIFECYCLE
  /// Sets up state listeners. Hides the emoji panel automatically if the
  /// text entry field gains keyboard focus.
  /// **************************************************************************
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        ref.read(emojiVisibilityProvider.notifier).hide();
      }
    });
  }

  /// **************************************************************************
  /// DISPOSE CONTROLLERS AND NODES
  /// Standard cleanup routine to close stream channels, discard focus trees,
  /// and prevent memory leaks.
  /// **************************************************************************
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// **************************************************************************
  /// SCROLL LIST VIEW TO BOTTOM
  /// Schedules a post-frame rendering callback to animate the list window viewport
  /// smoothly down to the latest appended chat stream message payload.
  /// **************************************************************************
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// **************************************************************************
  /// HANDLE MESSAGE DISPATCH
  /// Captures input text, ignores blank inputs, passes data payload to the
  /// Riverpod state notifier framework, and flushes input field buffers.
  /// **************************************************************************
  void _handleSend() {
    if (_isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unblock this user to send messages.')),
      );
      return;
    }
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    ref.read(messageProvider.notifier).sendMessage(text, _scrollToBottom);
    _messageController.clear();
  }

  /// **************************************************************************
  /// TOGGLE EMOJI KEYBOARD INTERACTION
  /// Manages system hardware soft-keyboard channels and visibility state.
  /// Seamlessly closes active text fields before introducing the custom picker view.
  /// **************************************************************************
  void _toggleEmojiKeyboard() {
    final isEmojiVisible = ref.read(emojiVisibilityProvider);
    if (isEmojiVisible) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          ref.read(emojiVisibilityProvider.notifier).show();
        }
      });
    }
  }

  /// **************************************************************************
  /// SHOW ATTACHMENT BOTTOM SHEET
  /// Dismisses active input overlays and builds a high-fidelity glassmorphism style
  /// action sheet menu utilizing blur backdrops and neon-style color gradient items.
  /// **************************************************************************
  void _showAttachmentBottomSheet() {
    _focusNode.unfocus();
    ref.read(emojiVisibilityProvider.notifier).hide();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(140),
      isScrollControlled: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey[900]!.withAlpha(220),
                  Colors.black.withAlpha(240),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(28.r),
              border: Border.all(color: Colors.white.withAlpha(25), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 24.h),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: 24.h,
                  crossAxisSpacing: 12.w,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAttachmentItem(
                      icon: Icons.insert_drive_file_rounded,
                      title: 'Document',
                      colors: [Colors.purple, Colors.deepPurple],
                    ),
                    _buildAttachmentItem(
                      icon: Icons.camera_alt_rounded,
                      title: 'Camera',
                      colors: [Colors.pink, Colors.redAccent],
                    ),
                    _buildAttachmentItem(
                      icon: Icons.image_rounded,
                      title: 'Gallery',
                      colors: [Colors.blue, Colors.lightBlueAccent],
                    ),
                    _buildAttachmentItem(
                      icon: Icons.headphones_rounded,
                      title: 'Audio',
                      colors: [Colors.orange, Colors.amber],
                    ),
                    _buildAttachmentItem(
                      icon: Icons.location_on_rounded,
                      title: 'Location',
                      colors: [Colors.green, Colors.teal],
                    ),
                    _buildAttachmentItem(
                      icon: Icons.person_rounded,
                      title: 'Contact',
                      colors: [Colors.cyan, Colors.blueAccent],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// **************************************************************************
  /// BUILD ATTACHMENT ITEM GRID BUTTONS
  /// Renders structural grid layouts for individual document/media attachment
  /// options. Features embedded glow gradients, subtle neon highlights, and custom tags.
  /// **************************************************************************
  Widget _buildAttachmentItem({
    required IconData icon,
    required String title,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(6),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withAlpha(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22.r),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: getMediumStyle14_500(
                color: Colors.white.withAlpha(220),
              ).copyWith(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  /// **************************************************************************
  /// SHOW USER DETAILS & INFO HUBS (MODERNIZED)
  /// Displays an ultra-modern glassmorphic profile sheet featuring advanced toggles,
  /// shared files view matrix, bio nodes, and block utility actions.
  /// **************************************************************************
  void _showUserDetailsDialog({
    required String name,
    required String imageUrl,
  }) {
    _focusNode.unfocus();
    ref.read(emojiVisibilityProvider.notifier).hide();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UserDetailsPopup',
      barrierColor: Colors.black.withAlpha(180),
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 16 * animation.value,
                sigmaY: 16 * animation.value,
              ),
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 40.h,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[900]!.withAlpha(235),
                      Colors.black.withAlpha(250),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                  border: Border.all(
                    color: Colors.white.withAlpha(30),
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Navigation dismiss
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withAlpha(150),
                            size: 22.r,
                          ),
                        ),
                      ),

                      // User Avatar Glow Node
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: _isBlocked
                                    ? [Colors.redAccent, Colors.orangeAccent]
                                    : [
                                        ColorManager.primary,
                                        Colors.deepPurpleAccent,
                                      ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (_isBlocked
                                              ? Colors.red
                                              : ColorManager.primary)
                                          .withAlpha(60),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          ClipOval(
                            child: Image.network(
                              imageUrl,
                              width: 93.r,
                              height: 93.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  CircleAvatar(
                                    radius: 46.r,
                                    backgroundColor: Colors.grey[800],
                                    child: Icon(
                                      Icons.person,
                                      size: 45.r,
                                      color: Colors.white,
                                    ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Identity Labels
                      Text(
                        name,
                        style: getSemiBoldStyle18_600(
                          color: Colors.white,
                        ).copyWith(fontSize: 20.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _isBlocked ? '[ BLOCKED ]' : 'alex.morgan@example.com',
                        style: getRegularStyle12_400(
                          color: _isBlocked
                              ? Colors.redAccent
                              : ColorManager.gray,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // User Status Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(12),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          "✨ Living life one pixel at a time.",
                          style: getRegularStyle12_400(
                            color: Colors.white.withAlpha(190),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 24.h),
                      const Divider(color: Colors.white10),
                      SizedBox(height: 12.h),

                      // Feature Toggles Section
                      _buildDialogToggleRow(
                        icon: _isMuted
                            ? Icons.notifications_off_rounded
                            : Icons.notifications_active_rounded,
                        title: 'Mute Notifications',
                        iconColor: Colors.tealAccent,
                        value: _isMuted,
                        onChanged: (val) {
                          setDialogState(() => _isMuted = val);
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 12.h),

                      _buildDialogToggleRow(
                        icon: Icons.block_flipped,
                        title: 'Block User',
                        iconColor: Colors.redAccent,
                        value: _isBlocked,
                        onChanged: (val) {
                          setDialogState(() => _isBlocked = val);
                          setState(() {});
                        },
                      ),

                      SizedBox(height: 24.h),
                      // Shared Media Section Preview
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Shared Media',
                          style: getSemiBoldStyle16_600(
                            color: Colors.white,
                          ).copyWith(fontSize: 14.sp),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 65.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return Container(
                              width: 65.h,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://picsum.photos/150?random=$i',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(color: Colors.white10),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// **************************************************************************
  /// DIALOG TOGGLE ROW HELPER
  /// Builds glassmorphic rows containing operational toggle switches for features.
  /// **************************************************************************
  Widget _buildDialogToggleRow({
    required IconData icon,
    required String title,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: getMediumStyle14_500(color: Colors.white.withAlpha(230)),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: ColorManager.primary,
            activeTrackColor: ColorManager.primary.withAlpha(100),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.white12,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// **************************************************************************
  /// BUILD APP BAR ACTION BUTTON
  /// Renders translucent circular buttons for structural utilities inside the top panel.
  /// **************************************************************************
  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(10)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20.r),
        onPressed: onTap,
      ),
    );
  }

  /// **************************************************************************
  /// MAIN WIDGET SCENE BUILDER
  /// Subscribes asynchronously to provider nodes, controls device system navigation
  /// pop behaviors, and generates screen canvas blueprints (AppBars, Body streams).
  /// **************************************************************************
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(messageProvider);
    final messages = chatState.messages;
    final isTyping = chatState.isTyping;
    final showEmoji = ref.watch(emojiVisibilityProvider);

    const String targetUserName = 'Alex Morgan';
    const String targetUserImage =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80';

    return PopScope(
      canPop: !showEmoji,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (showEmoji) {
          ref.read(emojiVisibilityProvider.notifier).hide();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 40.w,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: false,
          title: GestureDetector(
            onTap: () => _showUserDetailsDialog(
              name: targetUserName,
              imageUrl: targetUserImage,
            ),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: ColorManager.primary.withAlpha(51),
                      child: ClipOval(
                        child: Image.network(
                          targetUserImage,
                          width: 36.r,
                          height: 36.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            color: ColorManager.primary,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 4.5.r,
                        backgroundColor: _isBlocked ? Colors.red : Colors.green,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              targetUserName,
                              style: getSemiBoldStyle16_600(
                                color: Colors.white,
                              ).copyWith(fontSize: 15.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_isMuted) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.notifications_off_rounded,
                              color: Colors.white38,
                              size: 13.r,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _isBlocked
                            ? 'blocked'
                            : (isTyping ? 'typing...' : 'online'),
                        style: getRegularStyle12_400(
                          color: _isBlocked
                              ? Colors.redAccent
                              : (isTyping
                                    ? ColorManager.primary
                                    : Colors.green),
                        ).copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            _buildAppBarAction(
              icon: Icons.phone_forwarded_rounded,
              onTap: () {
                if (_isBlocked) return; // ব্লকড থাকলে কল হবে না
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AudioCallScreen(
                      userName: targetUserName,
                      imageUrl: targetUserImage,
                    ),
                  ),
                );
              },
            ),
            _buildAppBarAction(
              icon: Icons.videocam_rounded,
              onTap: () {
                if (_isBlocked) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoCallScreen(
                      userName: targetUserName,
                      imageUrl: targetUserImage,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 6.w),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                  ref.read(emojiVisibilityProvider.notifier).hide();
                },
                child: _isBlocked
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              color: Colors.white24,
                              size: 48.r,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'You have blocked this contact.',
                              style: getMediumStyle14_500(
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
              ),
            ),
            if (isTyping && !_isBlocked)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Row(
                  children: [
                    Text(
                      'Alex is typing',
                      style: getRegularStyle12_400(color: ColorManager.gray),
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      width: 12.w,
                      height: 12.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            _buildMessageInput(showEmoji),
            if (showEmoji && !_isBlocked) _buildEmojiPicker(),
            SizedBox(height: showEmoji ? 0 : 10.h),
          ],
        ),
      ),
    );
  }

  /// **************************************************************************
  /// BUILD MESSAGE CHAT BUBBLE WIDGET
  /// Renders speech containers, adjusts side alignment vectors based on sender roles,
  /// and dynamically handles border rounding radii transformations.
  /// **************************************************************************
  Widget _buildMessageBubble(MessageModel message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: message.isMe
              ? ColorManager.primary
              : Colors.white.withAlpha(15),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: message.isMe ? Radius.zero : Radius.circular(16.r),
          ),
          border: message.isMe
              ? null
              : Border.all(color: Colors.white.withAlpha(13)),
        ),
        child: Text(
          message.text,
          style: getMediumStyle14_500(color: Colors.white),
        ),
      ),
    );
  }

  /// **************************************************************************
  /// BUILD CHAT INPUT FIELD BAR WIDGET
  /// Controls structural alignment of interactive utilities down within bottom panes,
  /// providing toggles for emoji keyboards, raw textual typing, and media uploads.
  /// **************************************************************************
  Widget _buildMessageInput(bool showEmoji) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withAlpha(20)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(
                      _isBlocked
                          ? Icons.block_rounded
                          : (showEmoji
                                ? Icons.keyboard_rounded
                                : Icons.emoji_emotions_outlined),
                      color: ColorManager.gray,
                      size: 22.r,
                    ),
                    onPressed: _isBlocked ? null : _toggleEmojiKeyboard,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      enabled: !_isBlocked,
                      onTap: () {
                        ref.read(emojiVisibilityProvider.notifier).hide();
                      },
                      style: getMediumStyle14_500(color: Colors.white),
                      decoration: InputDecoration(
                        filled: false,
                        hintText: _isBlocked
                            ? 'You cannot reply to this conversation'
                            : 'Type a message...',
                        hintStyle: getRegularStyle14_400(
                          color: ColorManager.textSecondary,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: ColorManager.gray,
                      size: 20.r,
                    ),
                    onPressed: _isBlocked ? null : _showAttachmentBottomSheet,
                  ),
                  SizedBox(width: 6.w),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _handleSend,
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: _isBlocked
                  ? Colors.grey[800]
                  : ColorManager.primary,
              child: Icon(
                Icons.send_rounded,
                color: _isBlocked ? Colors.white30 : Colors.white,
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **************************************************************************
  /// BUILD EMOJI PICKER CONTAINER PANEL WIDGET
  /// Configures grid matrix scales, scaling values across iOS/Android, and wraps
  /// localized visual options using matching ecosystem custom dark sheets.
  /// **************************************************************************
  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250.h,
      child: EmojiPicker(
        textEditingController: _messageController,
        config: Config(
          height: 250.h,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            backgroundColor: Colors.black.withAlpha(235),
            columns: 7,
            emojiSizeMax:
                24 *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1.20
                    : 1.0),
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: Colors.black.withAlpha(250),
            indicatorColor: ColorManager.primary,
            iconColorSelected: ColorManager.primary,
            iconColor: ColorManager.gray,
          ),
        ),
      ),
    );
  }
}
