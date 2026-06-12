import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageModel {
  final String text;
  final bool isMe;
  final DateTime time;

  MessageModel({required this.text, required this.isMe, required this.time});
}

class ChatTileModel {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isReadByMe;
  final String? imageUrl;

  ChatTileModel({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.isReadByMe,
    this.imageUrl,
  });
}

// ==========================================
// 2. STATE MODELS FOR CHAT SCREEN
// ==========================================

class ChatScreenState {
  final List<MessageModel> messages;
  final bool isTyping;

  ChatScreenState({required this.messages, required this.isTyping});

  ChatScreenState copyWith({List<MessageModel>? messages, bool? isTyping}) {
    return ChatScreenState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

// ==========================================
// 3. VIEW MODELS (NOTIFIERS)
// ==========================================

class ChatViewModel extends Notifier<List<ChatTileModel>> {
  @override
  List<ChatTileModel> build() {
    return [
      ChatTileModel(
        name: 'Alex Morgan',
        lastMessage: 'Yeah! The glassmorphism looks clean! 🔥',
        time: '12:40 PM',
        unreadCount: 2,
        isOnline: true,
        isReadByMe: false,
        imageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      ),
      ChatTileModel(
        name: 'Tajimul Islam',
        lastMessage: 'Bro, repository pattern টা কি দেখব?',
        time: '11:15 AM',
        unreadCount: 0,
        isOnline: true,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      ),
      ChatTileModel(
        name: 'Sarah Connor',
        lastMessage: 'Sent a photo 📸',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: false,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      ),
      ChatTileModel(
        name: 'Arif Ahmed',
        lastMessage: 'FVM setup ডান, এখন রান হচ্ছে।',
        time: 'Yesterday',
        unreadCount: 5,
        isOnline: true,
        isReadByMe: false,
        imageUrl:
            'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=150',
      ),
      ChatTileModel(
        name: 'Kamrul Hasan',
        lastMessage: 'Meeting at 4:00 PM today.',
        time: '2 days ago',
        unreadCount: 0,
        isOnline: false,
        isReadByMe: true,
        imageUrl: null,
      ),
      ChatTileModel(
        name: 'Sazedul Islam',
        lastMessage: 'UI ডিজাইনটা জোস হয়েছে ভাই!',
        time: '3 days ago',
        unreadCount: 0,
        isOnline: false,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=150',
      ),
    ];
  }

  void addChat({
    required String name,
    required String message,
    String? imageUrl,
  }) {
    final newChat = ChatTileModel(
      name: name,
      lastMessage: message,
      time: 'Just now',
      unreadCount: 1,
      isOnline: true,
      isReadByMe: false,
      imageUrl: imageUrl,
    );
    state = [newChat, ...state];
  }
}

class MessageViewModel extends Notifier<ChatScreenState> {
  @override
  ChatScreenState build() {
    return ChatScreenState(
      messages: [
        MessageModel(
          text: "Hey! Welcome to Bondly 🚀",
          isMe: false,
          time: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        MessageModel(
          text: "Hello! Thanks, the UI looks amazing!",
          isMe: true,
          time: DateTime.now().subtract(const Duration(minutes: 4)),
        ),
      ],
      isTyping: false,
    );
  }

  void sendMessage(String text, VoidCallback onMessageAdded) {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();

    state = state.copyWith(
      messages: [
        ...state.messages,
        MessageModel(text: userMessage, isMe: true, time: DateTime.now()),
      ],
    );
    onMessageAdded();

    Timer(const Duration(seconds: 1), () {
      state = state.copyWith(isTyping: true);
      onMessageAdded();

      Timer(const Duration(milliseconds: 1500), () {
        state = state.copyWith(
          isTyping: false,
          messages: [
            ...state.messages,
            MessageModel(
              text: _getDummyResponse(userMessage),
              isMe: false,
              time: DateTime.now(),
            ),
          ],
        );
        onMessageAdded();
      });
    });
  }

  String _getDummyResponse(String message) {
    String msg = message.toLowerCase();
    if (msg.contains('hi') || msg.contains('hello') || msg.contains('hey')) {
      return "Hello there! How's your day going?";
    } else if (msg.contains('kamn acho') || msg.contains('how are you')) {
      return "I'm doing great! Building Bondly is fun 💻. What about you?";
    } else if (msg.contains('ui') || msg.contains('design')) {
      return "Yeah! The glassmorphism and neon borders look super clean!";
    } else {
      return "Got it! Let's explore more features in Bondly ✨.";
    }
  }
}

// ==========================================
// 4. PROVIDERS
// ==========================================

final chatProvider = NotifierProvider<ChatViewModel, List<ChatTileModel>>(() {
  return ChatViewModel();
});

final messageProvider = NotifierProvider<MessageViewModel, ChatScreenState>(() {
  return MessageViewModel();
});
