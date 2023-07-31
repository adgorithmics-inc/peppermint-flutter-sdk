// To parse this JSON data, do
//
//     final chatMessageResponse = chatMessageResponseFromJson(jsonString);

class ChatMessageResponse {
  dynamic next;
  dynamic previous;
  int? showingFrom;
  int? showingTo;
  int? count;
  List<ChatMessage> results = [];

  ChatMessageResponse({
    this.next,
    this.previous,
    this.showingFrom,
    this.showingTo,
    this.count,
    required this.results,
  });

  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      ChatMessageResponse(
        next: json["next"],
        previous: json["previous"],
        showingFrom: json["showing_from"],
        showingTo: json["showing_to"],
        count: json["count"],
        results: json["results"] == null
            ? []
            : List<ChatMessage>.from(
                json["results"]!.map((x) => ChatMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "previous": previous,
        "showing_from": showingFrom,
        "showing_to": showingTo,
        "count": count,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class ChatMessage {
  String? id;
  DateTime? createdOn;
  Role? role;
  String content;
  List<dynamic>? sources;
  int? rating;

  ChatMessage({
    this.id,
    this.createdOn,
    this.role,
    this.content = '',
    this.sources,
    this.rating,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse('${json["created_on"]}+0000'),
        role: roleValues.map[json["role"]]!,
        content: json["content"],
        sources: json["sources"] == null
            ? []
            : List<dynamic>.from(json["sources"]!.map((x) => x)),
        rating: json["rating"],
      );

  factory ChatMessage.fromMyself(String data) => ChatMessage(
        createdOn: DateTime.now(),
        role: Role.user,
        content: data,
        sources: [],
        rating: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_on": createdOn?.toIso8601String(),
        "role": roleValues.reverse[role],
        "content": content,
        "sources":
            sources == null ? [] : List<dynamic>.from(sources!.map((x) => x)),
        "rating": rating,
      };
}

enum Role { assistant, user }

final roleValues = EnumValues(
  {
    "assistant": Role.assistant,
    "user": Role.user,
  },
);

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
