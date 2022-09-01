import 'package:chatapp/Components/UserStrap.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindUser extends StatefulWidget {
  final String email;
  const FindUser({Key? key, required this.email}) : super(key: key);
  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  String email="";
  String url="";
  String url1="";
  String name="Receiver Name";
  String name1="Sender Name";
  bool visible=false;
  final _fireStore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {
                  email=value;
                });
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                hintText: "Find User",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            child: const Text("Find", style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: 'DS',fontWeight: FontWeight.bold)),
            onPressed: () async {
              var collection = _fireStore.collection('users');
              var querySnapshot = await collection.where('email', isEqualTo: email.trim()).get();
              for (var snapshot in querySnapshot.docs) {
                Map<String, dynamic> data = snapshot.data();
                name = data['name'].toString();
                url=data['photo'].toString();
                break;
              }
              querySnapshot = await collection.where('email', isEqualTo: widget.email.trim()).get();
              for (var snapshot in querySnapshot.docs) {
                Map<String, dynamic> data = snapshot.data();
                name1=data['name'].toString();
                url1=data['photo'].toString();
                break;
              }
              if(querySnapshot.docs.isNotEmpty)
                {
                    _fireStore.collection(widget.email).doc(email).collection("messages").doc("XYZ").set({
                      'message' : "temp",
                      'sender' : true,
                      'time' : "9050-07-31 17:04:38.841505"
                    });
                    _fireStore.collection(email).doc(widget.email).collection("messages").doc("XYZ").set({
                      'message' : "temp",
                      'sender' : true,
                      'time' : "9050-07-31 17:04:38.841505"
                    });
                    _fireStore.collection(widget.email).doc(email).set({'email':email,'photo':url,'name':name});
                    _fireStore.collection(email).doc(widget.email).set({'email':widget.email,'photo':url1,'name':name1});
                    setState((){
                    visible=true;
                  });
                }
            },
          ),
        ),
        Visibility(child: UserStrap(sender : widget.email, receiver: email, url: url,rName: name,),visible: visible,),
        Expanded(flex: 5,child: Container()),
      ],
    );
  }
}
