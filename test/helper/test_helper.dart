import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

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
