import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';
import 'package:http/http.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotRepo>(
      () => ChatbotRepo(
        client: Client(),
        baseUrl: 'staging-mercury-api-bwjdcapn3a-as.a.run.app',
        chatBotId: '9f1196141ce84950ad05ced4b6db4d9e',
        dataSource: ChatLocalDataSource(),
      ),
    );
    Get.lazyPut(() => CreateConversationUsecase(Get.find()));
    Get.lazyPut(() => GetMessagesUsecase(Get.find()));
    Get.lazyPut(() => SendMessageUsecase(Get.find()));

    Get.lazyPut<ChatbotController>(
      () => ChatbotController(
        conversationUsecase: Get.find(),
        getMessagesUsecase: Get.find(),
        sendMessageUsecase: Get.find(),
      ),
    );
  }
}
