import 'dart:convert';

import 'package:http/http.dart';
import 'package:peppermint_sdk/src/chatbot/models/chatbot_model.dart';

import '../../resource.dart';
import '../data_source/chat_local_data_source.dart';
import '../models/chat_message_response.dart';

class ChatbotRepo {
  final Client _client;
  final String _baseUrl;
  final String _chatBotId;
  final ChatLocalDataSource dataSource;

  ChatbotRepo({
    required Client client,
    required String baseUrl,
    required String chatBotId,
    required this.dataSource,
  })  : _chatBotId = chatBotId,
        _baseUrl = baseUrl,
        _client = client;

  final String sendChatUrl = '/api/v1/public-chat/chat/';
  final String messagesUrl = '/api/v1/public-chat/';

  final String noConversation = 'Conversation is not initiated yet';

  /// Returned response is chat from AI to reply your sent message
  Future<Resource<ChatMessage>> sendMessage(String prompt) async {
    String? conversationId = await dataSource.getConversationId();
    if (conversationId == null) {
      return noConversation.toResourceFailure();
    }

    try {
      var response = await _client.post(
        Uri.https(
          _baseUrl,
          sendChatUrl,
        ),
        body: {
          'chatbot': _chatBotId,
          'conversation': conversationId,
          'prompt': prompt,
        },
      );
      ChatMessage data = ChatMessage.fromJson(json.decode(response.body));
      return data.toResourceSuccess();
    } catch (e) {
      return '$e'.toResourceFailure();
    }
  }

  /// Get message history in single conversation id
  Future<Resource<ChatMessageResponse>> getMessages() async {
    String? conversationId = await dataSource.getConversationId();
    if (conversationId == null) {
      return noConversation.toResourceFailure();
    }
    try {
      var response = await _client.get(
        Uri.https(
          _baseUrl,
          messagesUrl,
          {
            'chatbot': _chatBotId,
            'conversation': conversationId,
          },
        ),
      );
      ChatMessageResponse data =
          ChatMessageResponse.fromJson(json.decode(response.body));
      return data.toResourceSuccess();
    } catch (e) {
      return '$e'.toResourceFailure();
    }
  }

  /// initialize new conversation with chatbot
  Future<Resource<ChatbotModel>> createConversation() async {
    try {
      var response = await _client.post(
        Uri.https(
          _baseUrl,
          messagesUrl,
        ),
        body: {
          'chatbot': _chatBotId,
        },
      );
      ChatbotModel data = ChatbotModel.fromJson(json.decode(response.body));
      dataSource.setConversationId(data.id!);
      return data.toResourceSuccess();
    } catch (e) {
      return '$e'.toResourceFailure();
    }
  }
}
