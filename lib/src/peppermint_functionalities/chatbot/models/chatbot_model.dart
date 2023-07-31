// To parse this JSON data, do
//
//     final chatbotModel = chatbotModelFromJson(jsonString);

class ChatbotModel {
  DateTime? title;
  String? id;
  DateTime? createdOn;
  DateTime? updatedOn;
  int? messageCount;
  Chatbot? chatbot;

  ChatbotModel({
    this.title,
    this.id,
    this.createdOn,
    this.updatedOn,
    this.messageCount,
    this.chatbot,
  });

  factory ChatbotModel.fromJson(Map<String, dynamic> json) => ChatbotModel(
        title: json["title"] == null ? null : DateTime.parse(json["title"]),
        id: json["id"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        messageCount: json["message_count"],
        chatbot:
            json["chatbot"] == null ? null : Chatbot.fromJson(json["chatbot"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title?.toIso8601String(),
        "id": id,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
        "message_count": messageCount,
        "chatbot": chatbot?.toJson(),
      };
}

class Chatbot {
  String? id;
  String? shareableId;
  String? title;
  String? description;
  String? personality;
  dynamic negativePersonality;
  List<String>? documents;
  String? welcomeMessage;
  String? model;
  String? index;

  Chatbot({
    this.id,
    this.shareableId,
    this.title,
    this.description,
    this.personality,
    this.negativePersonality,
    this.documents,
    this.welcomeMessage,
    this.model,
    this.index,
  });

  factory Chatbot.fromJson(Map<String, dynamic> json) => Chatbot(
        id: json["id"],
        shareableId: json["shareable_id"],
        title: json["title"],
        description: json["description"],
        personality: json["personality"],
        negativePersonality: json["negative_personality"],
        documents: json["documents"] == null
            ? []
            : List<String>.from(json["documents"]!.map((x) => x)),
        welcomeMessage: json["welcome_message"],
        model: json["model"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shareable_id": shareableId,
        "title": title,
        "description": description,
        "personality": personality,
        "negative_personality": negativePersonality,
        "documents": documents == null
            ? []
            : List<dynamic>.from(documents!.map((x) => x)),
        "welcome_message": welcomeMessage,
        "model": model,
        "index": index,
      };
}
