import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sociaanet/core/models/models.dart';
import 'package:sociaanet/features/chat/data/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

enum ChatStatus { initial, loading, loaded, sending, error }

class ChatState {
  final ChatStatus status;
  final List<ChatConversation> conversations;
  final List<ChatMessage> messages;
  final String? errorMessage;
  final bool hasMore;

  ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.messages = const [],
    this.errorMessage,
    this.hasMore = true,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatConversation>? conversations,
    List<ChatMessage>? messages,
    String? errorMessage,
    bool? hasMore,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ChatViewModel extends Notifier<ChatState> {
  int _page = 1;

  @override
  ChatState build() {
    return ChatState();
  }

  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  Future<void> loadConversations({bool refresh = false}) async {
    if (refresh) _page = 1;
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _repository.getConversations(page: _page, limit: 20);
    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (conversations) {
        if (refresh || _page == 1) {
          state = state.copyWith(
            status: ChatStatus.loaded,
            conversations: conversations,
            hasMore: conversations.length >= 20,
          );
        } else {
          state = state.copyWith(
            status: ChatStatus.loaded,
            conversations: [...state.conversations, ...conversations],
            hasMore: conversations.length >= 20,
          );
        }
        _page++;
      },
    );
  }

  Future<void> loadMessages(String conversationId, {bool refresh = false}) async {
    if (refresh) _page = 1;
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _repository.getMessages(conversationId, page: _page, limit: 30);
    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (messages) {
        if (refresh || _page == 1) {
          state = state.copyWith(
            status: ChatStatus.loaded,
            messages: messages,
            hasMore: messages.length >= 30,
          );
        } else {
          state = state.copyWith(
            status: ChatStatus.loaded,
            messages: [...state.messages, ...messages],
            hasMore: messages.length >= 30,
          );
        }
        _page++;
      },
    );
  }

  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    List<String>? mediaKeys,
  }) async {
    state = state.copyWith(status: ChatStatus.sending);

    final result = await _repository.sendMessage(
      conversationId: conversationId,
      content: content,
      messageType: messageType,
      mediaKeys: mediaKeys,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (message) {
        state = state.copyWith(
          status: ChatStatus.loaded,
          messages: [message, ...state.messages],
        );
      },
    );
  }

  void addIncomingMessage(ChatMessage message) {
    state = state.copyWith(
      messages: [message, ...state.messages],
    );
  }

  Future<void> deleteMessage(String messageId) async {
    await _repository.deleteMessage(messageId);
    state = state.copyWith(
      messages: state.messages.where((m) => m.id != messageId).toList(),
    );
  }

  Future<void> markAsRead(String conversationId) async {
    await _repository.markAsRead(conversationId);
  }
}

final chatViewModelProvider = NotifierProvider<ChatViewModel, ChatState>(
  ChatViewModel.new,
);
