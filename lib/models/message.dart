import 'package:chat_app/constants.dart';

class Message{
  final String message;
  final String id;
  Message( this.message, this.id);

  // i made it type of (JsonData) to recieve any type of data
  factory Message.fromJson(jsonData){
    return Message(jsonData[kMessage],jsonData['id']);
  }
}