import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isMe;
  String time="00:00";
  MessageBubble({Key? key, required this.message, required this.senderName, required this.isMe,required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Material(
              elevation: 5,
              color: isMe?Colors.tealAccent:Colors.cyanAccent,
            borderRadius: isMe?const BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25),topLeft: Radius.circular(25))
                :const BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25),topRight: Radius.circular(25)),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message,style: const TextStyle(fontSize: 20,fontWeight:FontWeight.w400,color: Colors.black),),
                  const SizedBox(width: 5,),
                  Text(time.substring(11,16),style: const TextStyle(fontSize: 10,color: Colors.black54,fontWeight: FontWeight.bold,))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
