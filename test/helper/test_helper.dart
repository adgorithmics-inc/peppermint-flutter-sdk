import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:peppermint_sdk/src/chatbot/data_source/chat_local_data_source.dart';

// command
// dart run build_runner build

@GenerateMocks([
  Client,
  ChatbotRepo,
  ChatLocalDataSource,
  CreateConversationUsecase,
  GetMessagesUsecase,
  SendMessageUsecase,
  FlutterSecureStorage,
])
void main() {}
