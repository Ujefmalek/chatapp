import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Screens/Chat.dart';
class UserStrap extends StatefulWidget {
  String sender="";
  String receiver="";
  String url="";
  String rName="";
  UserStrap({Key? key,required this.sender, required this.receiver,required this.url,required this.rName}) : super(key: key);

  @override
  State<UserStrap> createState() => _UserStrapState();
}

class _UserStrapState extends State<UserStrap> {
  FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Chat(email: widget.sender, receiver: widget.receiver,url: widget.url,rName: widget.rName,)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0)
          ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10,),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child:(widget.url!="")?Image.network(widget.url):Image.asset('assets/images/person.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(child: Text(widget.rName,style: const TextStyle(fontSize: 18),)),
              ],
            ),
        ),
      ),
    );
  }
}
