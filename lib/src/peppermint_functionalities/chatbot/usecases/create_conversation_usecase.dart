import 'package:peppermint_sdk/src/peppermint_functionalities/chatbot/repo/chatbot_repo.dart';
import 'package:peppermint_sdk/src/resource.dart';

import '../models/chat_message_response.dart';

class CreateConversationUsecase {
  final ChatbotRepo _chatbotRepo;

  CreateConversationUsecase(this._chatbotRepo);

  Future<Resource<ChatMessageResponse>> invoke() async {
    String? conversationId = await _chatbotRepo.getSavedConversationId();

    if (conversationId == null) {
      final result = await _chatbotRepo.createConversation();
      String? error = result.getErrorOrNull();
      if (error != null) return error.toResourceFailure();
    }

    return _chatbotRepo.getMessages();
  }
}
