import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:sociaanet/core/api/api_endpoints.dart';
import 'package:sociaanet/core/models/models.dart';

/// Socket service for real-time communication
class SocketService {
  static SocketService? _instance;
  io.Socket? _socket;
  bool _isConnected = false;

  // Stream controllers for events
  final _onNewMessage = StreamController<ChatMessage>.broadcast();
  final _onMessageDeleted = StreamController<Map<String, dynamic>>.broadcast();
  final _onMessageReacted = StreamController<Map<String, dynamic>>.broadcast();
  final _onTypingStart = StreamController<Map<String, dynamic>>.broadcast();
  final _onTypingStop = StreamController<Map<String, dynamic>>.broadcast();
  final _onMessagesRead = StreamController<Map<String, dynamic>>.broadcast();
  final _onUserOnline = StreamController<String>.broadcast();
  final _onUserOffline = StreamController<String>.broadcast();
  final _onUnreadUpdate = StreamController<Map<String, dynamic>>.broadcast();
  final _onConversationUpdated = StreamController<Map<String, dynamic>>.broadcast();
  final _onNotification = StreamController<AppNotification>.broadcast();
  final _onConnect = StreamController<void>.broadcast();
  final _onDisconnect = StreamController<void>.broadcast();

  // Public streams
  Stream<ChatMessage> get onNewMessage => _onNewMessage.stream;
  Stream<Map<String, dynamic>> get onMessageDeleted => _onMessageDeleted.stream;
  Stream<Map<String, dynamic>> get onMessageReacted => _onMessageReacted.stream;
  Stream<Map<String, dynamic>> get onTypingStart => _onTypingStart.stream;
  Stream<Map<String, dynamic>> get onTypingStop => _onTypingStop.stream;
  Stream<Map<String, dynamic>> get onMessagesRead => _onMessagesRead.stream;
  Stream<String> get onUserOnline => _onUserOnline.stream;
  Stream<String> get onUserOffline => _onUserOffline.stream;
  Stream<Map<String, dynamic>> get onUnreadUpdate => _onUnreadUpdate.stream;
  Stream<Map<String, dynamic>> get onConversationUpdated => _onConversationUpdated.stream;
  Stream<AppNotification> get onNotification => _onNotification.stream;
  Stream<void> get onConnect => _onConnect.stream;
  Stream<void> get onDisconnect => _onDisconnect.stream;

  bool get isConnected => _isConnected;

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  SocketService._();

  /// Connect to socket server
  void connect(String sessionId) {
    if (_isConnected && _socket != null) {
      debugPrint('🔌 Socket already connected');
      return;
    }

    debugPrint('🔌 Connecting to socket...');
    _socket = io.io(
      ApiEndpoints.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setExtraHeaders({'Authorization': 'Bearer $sessionId'})
          .setAuth({'token': sessionId})
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('✅ Socket connected');
      _isConnected = true;
      _onConnect.add(null);
    });

    _socket!.onDisconnect((_) {
      debugPrint('❌ Socket disconnected');
      _isConnected = false;
      _onDisconnect.add(null);
    });

    _socket!.onConnectError((error) {
      debugPrint('❌ Socket connection error: $error');
    });

    // Chat events
    _socket!.on('message:new', (data) {
      if (data is Map<String, dynamic>) {
        _onNewMessage.add(ChatMessage.fromJson(data));
      }
    });

    _socket!.on('message:deleted', (data) {
      if (data is Map<String, dynamic>) {
        _onMessageDeleted.add(data);
      }
    });

    _socket!.on('message:reacted', (data) {
      if (data is Map<String, dynamic>) {
        _onMessageReacted.add(data);
      }
    });

    _socket!.on('message:unreacted', (data) {
      if (data is Map<String, dynamic>) {
        _onMessageReacted.add(data);
      }
    });

    _socket!.on('typing:start', (data) {
      if (data is Map<String, dynamic>) {
        _onTypingStart.add(data);
      }
    });

    _socket!.on('typing:stop', (data) {
      if (data is Map<String, dynamic>) {
        _onTypingStop.add(data);
      }
    });

    _socket!.on('messages:read', (data) {
      if (data is Map<String, dynamic>) {
        _onMessagesRead.add(data);
      }
    });

    _socket!.on('user:online', (data) {
      if (data is String) {
        _onUserOnline.add(data);
      } else if (data is Map) {
        _onUserOnline.add(data['user_id']?.toString() ?? '');
      }
    });

    _socket!.on('user:offline', (data) {
      if (data is String) {
        _onUserOffline.add(data);
      } else if (data is Map) {
        _onUserOffline.add(data['user_id']?.toString() ?? '');
      }
    });

    _socket!.on('unread:update', (data) {
      if (data is Map<String, dynamic>) {
        _onUnreadUpdate.add(data);
      }
    });

    _socket!.on('conversation:updated', (data) {
      if (data is Map<String, dynamic>) {
        _onConversationUpdated.add(data);
      }
    });

    _socket!.on('conversation:deleted', (data) {
      if (data is Map<String, dynamic>) {
        _onConversationUpdated.add({...data, 'deleted': true});
      }
    });

    // Notification events
    _socket!.on('notification:new', (data) {
      if (data is Map<String, dynamic>) {
        _onNotification.add(AppNotification.fromJson(data));
      }
    });
  }

  /// Send a message via socket
  void sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<String>? mediaUrls,
    String? replyToId,
    String? sharedPostId,
    String? sharedReelId,
  }) {
    _socket?.emit('message:send', {
      'conversation_id': conversationId,
      'content': content,
      'message_type': messageType,
      if (mediaUrls != null) 'media_urls': mediaUrls,
      if (replyToId != null) 'reply_to': replyToId,
      if (sharedPostId != null) 'shared_post_id': sharedPostId,
      if (sharedReelId != null) 'shared_reel_id': sharedReelId,
    });
  }

  /// Start typing indicator
  void startTyping(String conversationId) {
    _socket?.emit('typing:start', {'conversation_id': conversationId});
  }

  /// Stop typing indicator
  void stopTyping(String conversationId) {
    _socket?.emit('typing:stop', {'conversation_id': conversationId});
  }

  /// Mark messages as read
  void markRead(String conversationId) {
    _socket?.emit('messages:read', {'conversation_id': conversationId});
  }

  /// Disconnect socket
  void disconnect() {
    debugPrint('🔌 Disconnecting socket...');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  /// Dispose all streams
  void dispose() {
    disconnect();
    _onNewMessage.close();
    _onMessageDeleted.close();
    _onMessageReacted.close();
    _onTypingStart.close();
    _onTypingStop.close();
    _onMessagesRead.close();
    _onUserOnline.close();
    _onUserOffline.close();
    _onUnreadUpdate.close();
    _onConversationUpdated.close();
    _onNotification.close();
    _onConnect.close();
    _onDisconnect.close();
    _instance = null;
  }
}
