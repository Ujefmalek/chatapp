import 'package:chatapp/Components/MessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Chat extends StatefulWidget {
  final String email;
  final String receiver;
  String url="";
  String rName="";
  Chat({Key? key, required this.email, required this.receiver,required this.url,required this.rName}) : super(key: key);
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late String message="";
  var textField=TextEditingController();
  final _fireStore=FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message="";
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: SizedBox(
                  width: 40.0,
                  height: 40.0,
                  child:widget.url==""?Image.asset('assets/images/person.png'):Image.network(widget.url),
                ),
              ),
            ),
          ),
          title: Text(widget.rName),
        ),
        body:StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection(widget.email).doc(widget.receiver).collection("messages").orderBy('time').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData)
              {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                );
              }
            List<MessageBubble> messageWidgets=[];
                final messages=snapshot.data?.docs.reversed;
                for(var mess in messages!)
                  {
                    String t=mess.get('time');
                    t=t.substring(0,16);
                    messageWidgets.add(MessageBubble(message: mess.get('message'), senderName:mess.get('sender')?widget.email:widget.receiver, isMe:mess.get('sender'),time:t,));
                  }
            return ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageWidgets,
            );
          },
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: textField,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    setState((){
                      message=value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    hintText: "Message chat...",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.email),
                    ),
                  ),
                ),
              ),
               const SizedBox(width: 10,),
               Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    setState((){
                      message=message.trim();
                      textField.clear();
                      if(message!="")
                        {
                          _fireStore.collection(widget.email).doc(widget.receiver).collection("messages").add({
                            'message' : message,
                            'sender' : true,
                            'time' : DateTime.now().toString()
                          });
                          _fireStore.collection(widget.receiver).doc(widget.email).collection("messages").add({
                            'message' : message,
                            'sender' : false,
                            'time' : DateTime.now().toString()
                          });
                        }
                    });
                    setState((){
                      message="";
                    });
                  },
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: ClipOval(
                      child: SizedBox(
                        width: 30.0,
                        height: 30.0,
                        child:Icon(Icons.send,color: Colors.white,),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
