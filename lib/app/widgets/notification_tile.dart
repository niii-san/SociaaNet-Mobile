import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String body;
  final String? avatarUrl;
  final DateTime timestamp;
  final bool isRead;
  final VoidCallback? onTap;
  const NotificationTile({super.key, required this.title, required this.body, this.avatarUrl, required this.timestamp, this.isRead = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null, child: avatarUrl == null ? const Icon(Icons.person) : null),
      title: Text(title, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
      subtitle: Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: !isRead ? Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blue)) : null,
      tileColor: isRead ? null : Colors.blue.withValues(alpha: 0.05),
      onTap: onTap,
    );
  }
}

// Added swipe to dismiss support
