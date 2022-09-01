import 'package:chatapp/Components/UserStrap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  final String email;
  const Home({Key? key, required this.email}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _fireStore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore.collection(widget.email).snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData)
            {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            List<UserStrap> messageWidgets=[];
            final messages=snapshot.data?.docs;
            for(var mess in messages!)
            {
              messageWidgets.add(UserStrap(sender:widget.email,receiver: mess.get('email'),url: mess.get('photo'),rName: mess.get('name'),));
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              children: messageWidgets,
            );
          },
        )
    );
  }
}

