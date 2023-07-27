import '../../resource.dart';
import '../models/chat_message_response.dart';
import '../repo/chatbot_repo.dart';

class GetMessagesUsecase {
  final ChatbotRepo _chatbotRepo;
  GetMessagesUsecase(this._chatbotRepo);

  Future<Resource<ChatMessageResponse>> invoke() async {
    return _chatbotRepo.getMessages();
  }
}
