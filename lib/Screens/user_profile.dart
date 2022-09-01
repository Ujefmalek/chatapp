import 'package:chatapp/Screens/GetData.dart';
import 'package:chatapp/Screens/Login_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  String email="Your email";
  String name="Your name";
  String bio="Your bio";
  String url="A";
  Profile(this.email,this.name,this.bio,this.url);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _fireStore=FirebaseFirestore.instance;
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context)=> SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Your Email',style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18
                ),),
                Text(widget.email,style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
          //const SizedBox(height: 20,),
          Expanded(
            flex:5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child:widget.url=="A"?Image.asset('assets/images/person.png'):Image.network(widget.url),
                      ),
                    ),
                  ),
                ),

                Padding(padding: const EdgeInsets.only(top: 60),
                child: IconButton(onPressed: (){
                }, icon: const Icon(Icons.camera)))
              ],
            ),
          ),
         // const SizedBox(height: 20,),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children:[
                    const Text('UserName',style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18
                    ),),
                    Text(widget.name,style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.greenAccent,
                )
              ],
            ),
          ),
         // const SizedBox(height: 20,),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      const Text("Your bio",style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18
                      ),),
                      Flexible(
                        child: Text(widget.bio,textAlign:TextAlign.center ,overflow: TextOverflow.ellipsis,maxLines: 5,style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.edit,
                  color: Colors.greenAccent,
                )
              ],
            ),
          ),
         // const SizedBox(height: 30,),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RawMaterialButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LS(true)));
                },fillColor: Colors.greenAccent,elevation: 4,splashColor: Colors.green,
                child: const Text('LOGOUT',style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 16
                ),),),
                RawMaterialButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GetData(widget.email)));
                },fillColor: Colors.greenAccent,elevation: 4,splashColor: Colors.green,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text('EDIT',style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.black,fontSize: 16
                  ),),)
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}
