import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/core/providers/app_providers.dart';
import 'package:sociaanet/core/services/socket_service.dart';
import 'package:sociaanet/app/widgets/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  ChatConversation? _conversation;
  bool _isLoading = true;
  bool _isSending = false;
  bool _otherTyping = false;
  StreamSubscription? _messageSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _typingStopSub;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupSocket();
  }

  Future<void> _loadData() async {
    try {
      final chatService = ref.read(chatServiceProvider);
      final results = await Future.wait([
        chatService.getConversationById(widget.conversationId),
        chatService.getMessages(widget.conversationId),
      ]);
      if (mounted) {
        setState(() {
          _conversation = results[0] as ChatConversation;
          _messages = (results[1] as List<ChatMessage>).reversed.toList();
          _isLoading = false;
        });
        chatService.markAsRead(widget.conversationId);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setupSocket() {
    final socket = SocketService.instance;
    _messageSub = socket.onNewMessage.listen((msg) {
      if (msg.conversationId == widget.conversationId) {
        setState(() => _messages.add(msg));
        _scrollToBottom();
      }
    });
    _typingSub = socket.onTypingStart.listen((data) {
      if (data['conversation_id'] == widget.conversationId) {
        final currentUser = ref.read(currentUserProvider);
        if (data['user_id'] != currentUser?.userId) {
          setState(() => _otherTyping = true);
        }
      }
    });
    _typingStopSub = socket.onTypingStop.listen((data) {
      if (data['conversation_id'] == widget.conversationId) {
        setState(() => _otherTyping = false);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messageSub?.cancel();
    _typingSub?.cancel();
    _typingStopSub?.cancel();
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    _messageController.clear();
    setState(() => _isSending = true);

    try {
      final chatService = ref.read(chatServiceProvider);
      final msg = await chatService.sendMessage(
        widget.conversationId,
        content: text,
      );
      setState(() {
        _messages.add(msg);
        _isSending = false;
      });
      _scrollToBottom();

      // Also send via socket for real-time
      SocketService.instance.sendMessage(
        conversationId: widget.conversationId,
        content: text,
      );
    } catch (_) {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final onlineUsers = ref.watch(onlineUsersProvider);

    String title = 'Chat';
    String? avatarUrl;
    bool isOnline = false;
    if (_conversation != null && currentUser != null) {
      title = _conversation!.getDisplayName(currentUser.userId);
      avatarUrl = _conversation!.getDisplayAvatar(currentUser.userId);
      final other = _conversation!.getOtherParticipant(currentUser.userId);
      isOnline = other != null && onlineUsers.contains(other.userId);
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            UserAvatar(imageUrl: avatarUrl, fallbackName: title, radius: 18,
              showOnlineIndicator: isOnline),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  if (_otherTyping)
                    Text('typing...', style: TextStyle(fontSize: 12, color: theme.colorScheme.primary))
                  else if (isOnline)
                    Text('Online', style: TextStyle(fontSize: 12, color: Colors.green.shade400)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Messages
                Expanded(
                  child: _messages.isEmpty
                      ? Center(child: Text('No messages yet', style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.outline)))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            final isMe = msg.senderId == currentUser?.userId;
                            return _MessageBubble(message: msg, isMe: isMe);
                          },
                        ),
                ),
                // Input
                Container(
                  padding: EdgeInsets.fromLTRB(12, 8, 8,
                      MediaQuery.of(context).padding.bottom + 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(top: BorderSide(color: theme.dividerColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          onChanged: (_) {
                            SocketService.instance.startTyping(widget.conversationId);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4, bottom: 4,
          left: isMe ? 48 : 0,
          right: isMe ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : theme.colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeago.format(DateTime.parse(message.createdAt)),
              style: TextStyle(
                fontSize: 10,
                color: isMe
                    ? Colors.white.withValues(alpha: 0.6)
                    : theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
