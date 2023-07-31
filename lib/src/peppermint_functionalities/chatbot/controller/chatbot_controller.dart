import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat_message_response.dart';
import '../usecases/create_conversation_usecase.dart';
import '../usecases/get_messages_usecase.dart';
import '../usecases/send_message_usecase.dart';

class ChatbotController extends GetxController {
  final CreateConversationUsecase _conversationUsecase;
  final GetMessagesUsecase _getMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;

  ChatbotController({
    required CreateConversationUsecase conversationUsecase,
    required GetMessagesUsecase getMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
  })  : _sendMessageUsecase = sendMessageUsecase,
        _getMessagesUsecase = getMessagesUsecase,
        _conversationUsecase = conversationUsecase;

  String error = '';
  bool loading = false;
  List<ChatMessage> data = [];
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool botThinking = false;

  Future<void> sendChat() async {
    String message = textController.text;
    if (message.isEmpty) return;
    textController.text = '';
    data.insert(0, ChatMessage.fromMyself(message));
    setBotThinking(true);
    final result = await _sendMessageUsecase.invoke(message);
    setBotThinking(false);

    result.when(
      onSuccess: (p0) {
        data.insert(0, p0);
        showChatGradually(p0);
      },
      onFailure: (p0) {},
    );
  }

  Future<void> getMessages() async {
    setLoading(true);
    final result = await _getMessagesUsecase.invoke();
    result.when(
      onSuccess: (p0) {
        data = p0.results;
      },
      onFailure: (p0) {
        error = p0;
      },
    );
    setLoading(false);
  }

  Future<void> createConversation() async {
    setLoading(true);
    final result = await _conversationUsecase.invoke();
    result.when(
      onSuccess: (p0) {
        data = p0.results;
      },
      onFailure: (p0) {
        error = p0;
      },
    );
    setLoading(false);
  }

  void setLoading(bool value) {
    loading = value;
    if (loading) error = '';
    update();
  }

  void setBotThinking(bool value) {
    botThinking = value;
    update();
  }

  Future<void> showChatGradually(ChatMessage chat) async {
    String text = chat.content;
    chat.content = '';
    update(['${chat.id}']);
    await Future.forEach(text.split(' '), (item) async {
      await Future.delayed(const Duration(milliseconds: 100));
      chat.content += ' $item';
      update(['${chat.id}']);
    });
  }

  @override
  void onInit() {
    createConversation();
    super.onInit();
  }
}
