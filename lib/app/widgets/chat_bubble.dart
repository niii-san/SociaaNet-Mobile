import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final DateTime timestamp;
  const ChatBubble({super.key, required this.message, required this.isSender, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isSender ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSender ? 16 : 4),
            bottomRight: Radius.circular(isSender ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(message, style: TextStyle(color: isSender ? Colors.white : null)),
            const SizedBox(height: 4),
            Text('${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, color: isSender ? Colors.white70 : Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Added read receipt indicator
