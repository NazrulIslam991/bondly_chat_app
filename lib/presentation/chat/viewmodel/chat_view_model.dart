import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==========================================
// 1. DATA MODELS
// ==========================================
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
        name: 'Sharabon Tahsin',
        lastMessage:
            'The new responsive UI layout handles tablet screens smoothly.',
        time: '10:05 AM',
        unreadCount: 0,
        isOnline: false,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
      ),
      ChatTileModel(
        name: 'Kamrul Hasan',
        lastMessage: 'Merged the latest MVVM changes into the main branch. 🚀',
        time: '9:30 AM',
        unreadCount: 1,
        isOnline: true,
        isReadByMe: false,
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
      ),
      ChatTileModel(
        name: 'Sazedul Islam',
        lastMessage:
            'Let’s hop on a quick call to check the database sync issue.',
        time: '8:45 AM',
        unreadCount: 3,
        isOnline: true,
        isReadByMe: false,
        imageUrl:
            'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&auto=format&fit=crop&q=80',
      ),
      ChatTileModel(
        name: 'Emily Watson',
        lastMessage: 'The asset package and clean code structure look solid!',
        time: '8:15 AM',
        unreadCount: 0,
        isOnline: false,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1554151228-14d9def656e4?w=200&auto=format&fit=crop&q=80',
      ),
      ChatTileModel(
        name: 'Michael Chang',
        lastMessage:
            'Ran the benchmark tests; performance is perfectly stable.',
        time: 'Yesterday',
        unreadCount: 0,
        isOnline: true,
        isReadByMe: true,
        imageUrl:
            'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200&auto=format&fit=crop&q=80',
      ),
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
        lastMessage: 'Bro, should I review the repository pattern?',
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
        lastMessage: 'FVM setup is done, running perfectly now.',
        time: 'Yesterday',
        unreadCount: 5,
        isOnline: true,
        isReadByMe: false,
        imageUrl:
            'https://images.unsplash.com/photo-1628157582853-a796fa650a6a?w=150',
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
    } else if (msg.contains('how are you') || msg.contains('how r u')) {
      return "I'm doing great! Building Bondly is fun 💻. What about you?";
    } else if (msg.contains('ui') || msg.contains('design')) {
      return "Yeah! The glassmorphism and neon borders look super clean!";
    } else {
      return "Got it! Let's explore more features in Bondly ✨.";
    }
  }
}

//  Notifier to handle the display visibility state of the Emoji Panel
class EmojiVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void show() => state = true;
  void hide() => state = false;
  void toggle() => state = !state;
}

// ==========================================
// 4. PROVIDERS DEFINITION
// ==========================================
final chatProvider = NotifierProvider<ChatViewModel, List<ChatTileModel>>(() {
  return ChatViewModel();
});

final messageProvider = NotifierProvider<MessageViewModel, ChatScreenState>(() {
  return MessageViewModel();
});

// Emoji visibility management provider
final emojiVisibilityProvider = NotifierProvider<EmojiVisibilityNotifier, bool>(
  () {
    return EmojiVisibilityNotifier();
  },
);
