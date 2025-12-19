import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class DirectMessagesScreen extends StatelessWidget {
  const DirectMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SociaaNetAppBar(
        showLogo: false,
        title: 'Messages',
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          // Conversations List
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return _ConversationTile(index: index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Start new conversation
        },
        backgroundColor: const Color(0xFF667eea),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final int index;

  const _ConversationTile({required this.index});

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = index % 3 == 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?img=${index + 1}',
            ),
          ),
          if (index % 4 == 0)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        'User ${index + 1}',
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        hasUnread
            ? 'Hey! Check out this post 📸'
            : 'Thanks for sharing! That was great.',
        style: TextStyle(
          color: hasUnread ? Colors.black87 : Colors.grey.shade600,
          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${index + 1}h ago',
            style: TextStyle(
              fontSize: 12,
              color: hasUnread ? const Color(0xFF667eea) : Colors.grey.shade500,
            ),
          ),
          if (hasUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF667eea),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to chat
      },
    );
  }
}
