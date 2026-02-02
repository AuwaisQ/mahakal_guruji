class ChatModel {
  List<Messages>? messages;
  int? total;
  int? chunk;
  int? totalChunks;

  ChatModel({this.messages, this.total, this.chunk, this.totalChunks});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    total = json['total'];
    chunk = json['chunk'];
    totalChunks = json['totalChunks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['chunk'] = chunk;
    data['totalChunks'] = totalChunks;
    return data;
  }
}

class Messages {
  String? from;
  String? to;
  String? message;
  String? datetime;

  Messages({this.from, this.to, this.message, this.datetime});

  Messages.fromJson(Map<String, dynamic> json) {
    from = json['from'].toString();
    to = json['to'].toString();
    message = json['message'].toString();
    datetime = json['datetime'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    data['message'] = message;
    data['datetime'] = datetime;
    return data;
  }
}
