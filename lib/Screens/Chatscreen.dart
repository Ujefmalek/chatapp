import 'package:chatapp/Screens/Home.dart';
import 'package:chatapp/Screens/Login_signup.dart';
import 'package:chatapp/Screens/findUsers.dart';
import 'package:chatapp/Screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatScreen extends StatefulWidget {
  final String email;
  final String name;
  final String bio;
  String url="";
  ChatScreen(this.email,this.name,this.bio,this.url, {Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  int currentIndex=0;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  Widget getBody()
  {
    switch(currentIndex)
    {
      case 0:
        return Home(email: widget.email);
      case 1:
        return FindUser(email: widget.email,);
      case 2:
        return Profile(widget.email,widget.name,widget.bio,widget.url);
      default:
        return Container(color: Colors.white,);
    }
  }
  void getCurrentUser() async{
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    }
    catch(e)
    {
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home : Scaffold(
        appBar: AppBar(title: const Text('FlashChat'),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LS(true)));
          }, icon: const Icon(Icons.close))
        ],),
        body: SafeArea(
          child: getBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index){
            setState(() {
              currentIndex=index;
            });
            },
          items: const [
               BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size:35,
                ),
                 label: 'Home',
                 backgroundColor: Colors.black
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.widgets_outlined,
                  size: 35,
                ),
                label: 'Find',
                backgroundColor: Colors.black
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: 35,
                ),
                label: 'Profile',
                backgroundColor: Colors.black
              ),
            ],
          ),
      ),
    );
  }
}
