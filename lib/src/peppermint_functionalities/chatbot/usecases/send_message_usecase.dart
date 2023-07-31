import 'package:peppermint_sdk/src/peppermint_functionalities/chatbot/repo/chatbot_repo.dart';
import 'package:peppermint_sdk/src/resource.dart';

import '../models/chat_message_response.dart';

class SendMessageUsecase {
  final ChatbotRepo _chatbotRepo;

  SendMessageUsecase(this._chatbotRepo);

  Future<Resource<ChatMessage>> invoke(String message) {
    return _chatbotRepo.sendMessage(message);
  }
}
