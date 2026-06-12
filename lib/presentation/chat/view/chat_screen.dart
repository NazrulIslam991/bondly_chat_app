import 'package:bondly/core/resources/constant/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/resources/constant/style_manager.dart';
import '../viewmodel/chat_view_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  void _handleSend() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    ref.read(messageProvider.notifier).sendMessage(text, _scrollToBottom);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(messageProvider);
    final messages = chatState.messages;
    final isTyping = chatState.isTyping;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.02),
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: ColorManager.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: ColorManager.primary,
                    size: 22.r,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: CircleAvatar(
                    radius: 5.r,
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Morgan',
                  style: getSemiBoldStyle16_600(color: Colors.white),
                ),
                Text(
                  isTyping ? 'typing...' : 'online',
                  style: getRegularStyle12_400(
                    color: isTyping ? ColorManager.primary : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          if (isTyping)
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

          _buildMessageInput(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

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
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: message.isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: message.isMe ? Radius.zero : Radius.circular(16.r),
          ),
          border: message.isMe
              ? null
              : Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Text(
          message.text,
          style: getMediumStyle14_500(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  SizedBox(width: 14.w),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: ColorManager.gray,
                    size: 22.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: getMediumStyle14_500(color: Colors.white),
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Type a message...',
                        hintStyle: getRegularStyle14_400(
                          color: ColorManager.textSecondary,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.attach_file_rounded,
                    color: ColorManager.gray,
                    size: 20.r,
                  ),
                  SizedBox(width: 14.w),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: _handleSend,
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: ColorManager.primary,
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }
}
