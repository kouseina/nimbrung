// To parse this JSON data, do
//
//     final chatsModel = chatsModelFromJson(jsonString);

import 'dart:convert';

ChatsModel chatsModelFromJson(String str) =>
    ChatsModel.fromJson(json.decode(str));

String chatsModelToJson(ChatsModel data) => json.encode(data.toJson());

class ChatsModel {
  ChatsModel({
    this.connections,
    this.chat,
  });

  List<String>? connections;
  List<ChatModel>? chat;

  factory ChatsModel.fromJson(Map<String, dynamic> json) => ChatsModel(
        connections: List<String>.from(json["connections"].map((x) => x)),
        chat: List<ChatModel>.from(json["chat"].map((x) => ChatModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections?.map((x) => x) ?? []),
        "chat": List<dynamic>.from(chat?.map((x) => x.toJson()) ?? []),
      };
}

class ChatModel {
  ChatModel({
    this.sender,
    this.receiver,
    this.message,
    this.time,
    this.isRead,
    this.groupTime,
  });

  String? sender;
  String? receiver;
  String? message;
  String? time;
  bool? isRead;
  String? groupTime;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        sender: json["sender"],
        receiver: json["receiver"],
        message: json["message"],
        time: json["time"],
        isRead: json["isRead"],
        groupTime: json["groupTime"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "receiver": receiver,
        "message": message,
        "time": time,
        "isRead": isRead,
        "groupTime": groupTime,
      };
}
