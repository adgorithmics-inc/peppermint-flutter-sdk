import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/chat_message_response.dart';

class ChatLocalDataSource {
  final storage = const FlutterSecureStorage();

  Future<void> appendMessageHistory(ChatMessage data) async {}

  Future<List<ChatMessage>> getMessageHistory() async {
    List<ChatMessage> result = [];

    return result;
  }

  /// Save initiated conversation id to local storage
  Future<void> setConversationId(String id) async {
    await storage.write(key: 'botConversationId', value: id);
  }

  /// Get initiated conversation id from local storage
  /// returns null if [setConversationId] is never called
  Future<String?> getConversationId() async {
    return await storage.read(key: 'botConversationId');
  }
}
