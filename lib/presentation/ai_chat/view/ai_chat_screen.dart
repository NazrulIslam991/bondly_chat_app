import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  static const _apiKey = 'AIz';

  final _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);

  Future<void> _sendMessage() async {
    final text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text});
      _controller.clear();
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _messages.add({
        'sender': 'ai',
        'message':
            'Bondly AI is currently in test mode! Please set up your API key correctly to receive real-time responses.',
      });
    });

    /* // যখন API Key সেটআপ হয়ে যাবে তখন এই অংশটি আন-কমেন্ট করে দিবেন:
    try {
      final content = [Content.text(text)];
      final response = await _model.generateContent(content);
      setState(() {
        _messages.add({'sender': 'ai', 'message': response.text ?? 'No response'});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'ai', 'message': 'Error: $e'});
      });
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Bondly AI', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  title: Text(
                    msg['message']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    msg['sender']!,
                    style: const TextStyle(color: Colors.greenAccent),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Ask Bondly AI...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
