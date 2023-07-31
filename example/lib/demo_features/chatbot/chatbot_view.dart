import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peppermint_sdk/peppermint_sdk.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GetBuilder(
              builder: (ChatbotController controller) {
                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        controller.error,
                      ),
                    ),
                  );
                }

                return NotificationListener(
                  child: ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(24.0),
                    itemCount: controller.data.length,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 16.0),
                    itemBuilder: (context, i) => ChatItem(
                      controller.data[i],
                      i,
                    ),
                    controller: controller.scrollController,
                  ),
                  onNotification: (ScrollUpdateNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {}
                    return true;
                  },
                );
              },
            ),
          ),
          GetBuilder(
            builder: (ChatbotController controller) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: controller.botThinking
                    ? const Padding(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          top: 12.0,
                          bottom: 4.0,
                        ),
                        child: Text('. . .'),
                      )
                    : Container(),
              );
            },
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.textController,
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 16.0),
                InkWell(
                  key: const Key("send_chat"),
                  onTap: () => controller.sendChat(),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(-0.5),
                    child: const CircleAvatar(
                      radius: 18.0,
                      child: Icon(
                        Icons.send,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {
  final ChatMessage data;
  final int index;
  const ChatItem(this.data, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool me = data.role == Role.user;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomRight: Radius.circular(me ? 0 : 12),
            bottomLeft: Radius.circular(me ? 12 : 0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: EdgeInsets.only(
        left: me ? 54.0 : 0.0,
        right: me ? 0.0 : 54.0,
      ),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GetBuilder(
            id: data.id,
            builder: (ChatbotController controller) {
              return Text(
                controller.data[index].content,
              );
            },
          ),
        ],
      ),
    );
  }
}
