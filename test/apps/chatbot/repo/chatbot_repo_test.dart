import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:peppermint_sdk/src/chatbot/models/chat_message_response.dart';
import 'package:peppermint_sdk/src/chatbot/repo/chatbot_repo.dart';

import '../../../helper/test_helper.mocks.dart';
import '../json/message_reply.dart';

void main() {
  group('Mock Chatbot API', () {
    late MockClient mockClient;
    late ChatbotRepo chatbotRepo;
    late MockChatLocalDataSource mockChatLocalDataSource;
    const baseUrl = '';
    const chatBotId = 'botId';
    String conversationId = 'testConversationId';

    setUp(() {
      mockClient = MockClient();
      mockChatLocalDataSource = MockChatLocalDataSource();

      chatbotRepo = ChatbotRepo(
        client: mockClient,
        baseUrl: baseUrl,
        chatBotId: chatBotId,
        dataSource: mockChatLocalDataSource,
      );
    });

    group('Send chat', () {
      String prompt = 'hi';

      test('send chat success', () async {
        when(mockChatLocalDataSource.getConversationId()).thenAnswer(
          (realInvocation) async {
            return conversationId;
          },
        );

        when(mockClient.post(
          Uri.https(
            baseUrl,
            chatbotRepo.sendChatUrl,
          ),
          body: {
            'chatbot': chatBotId,
            'conversation': conversationId,
            'prompt': prompt,
          },
        )).thenAnswer((realInvocation) async {
          return Future.value(
              Response(json.encode(MessageReplyJson.json), 200));
        });

        final result = await chatbotRepo.sendMessage(prompt);
        ChatMessage? data = result.getDataOrNull();
        expect(data, isA<ChatMessage>());
        expect(data?.content, MessageReplyJson.json['content']);
      });

      test('send chat fail: no conversation id saved', () async {
        when(mockChatLocalDataSource.getConversationId()).thenAnswer(
          (realInvocation) async {
            return null;
          },
        );

        final result = await chatbotRepo.sendMessage(prompt);
        String? error = result.getErrorOrNull();
        expect(error, isA<String>());
        expect(error, chatbotRepo.noConversation);
      });
    });
  });
}
