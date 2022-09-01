import 'dart:io';
import 'package:chatapp/Components/toast.dart';
import 'package:chatapp/Screens/Chatscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class GetData extends StatefulWidget {
  final String email;
  const GetData(this.email);
  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  final _fireStore=FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  final Image _image=Image.asset('assets/images/person.png');
  late String name;
  String url="";
  bool flag=false;
  late String bio;
  late File? file;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          title: const Text(
            'Create Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your Email',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.email,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              flex: 2,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () async {
                    final imagePicker = ImagePicker();
                    XFile? image;
                    await Permission.photos.request();
                    var permissionStatus= await Permission.photos.status;
                    if(permissionStatus.isGranted)
                    {
                      image= await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
                        file=File(image!.path);
                      if(file!=null)
                      {
                        var snapshot= await storage.ref().child(widget.email).putFile(file!);
                        url=await snapshot.ref.getDownloadURL();
                        setState((){
                          flag=true;
                        });
                      }
                    }
                    else
                      {
                        showToast("Permission denied", Colors.greenAccent);
                      }
                    setState((){
                      flag=true;
                    });
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 180.0,
                        height: 180.0,
                        child: flag?Image.network(url):_image,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        name=value.trim();
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 3)),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(25)),
                        hintText: "Enter Your Name",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Flexible(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        bio=value.trim();
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 3)),
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 3),
                            borderRadius: BorderRadius.circular(25)),
                        hintText: "Enter Your Bio",
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.person),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () async {
                      if(flag) {
                        _fireStore.collection('users').doc(widget.email).set({
                          'email': widget.email,
                          'name': name,
                          'bio': bio,
                          'photo': url
                        });
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) =>
                            ChatScreen(widget.email, name, bio,url)));
                      }
                      else
                        {
                          showToast("Please insert data", Colors.red);
                        }
                    },
                    child: const Text(
                      'Submit',
                      style:
                          TextStyle(fontSize:20,fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
