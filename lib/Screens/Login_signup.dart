import 'package:firebase_auth/firebase_auth.dart';
import 'GetData.dart';
import 'package:flutter/material.dart';
import 'Chatscreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/constants.dart';
import 'package:chatapp/Components/toast.dart';
late int? isViewed;

class LS extends StatefulWidget {
  final bool check;
  const LS(this.check, {Key? key}) : super(key: key);
  @override
  State<LS> createState() => _LSState();
}
class _LSState extends State<LS> {
  @override
  void initState() {
    super.initState();
  }
  final _auth = FirebaseAuth.instance;
  final _fireStore=FirebaseFirestore.instance;
  bool showSpinner = false;
  late String email;
  late String pass;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: Colors.white,
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(
                widget.check?'Login':'Sign up',
                style: KtextStyle1.copyWith(color: Colors.black),
              )),
              backgroundColor: Colors.white,
            ),
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Column(
                children: [
                  Expanded(flex: 8, child: Image.asset(widget.check?'assets/images/login.png':'assets/images/signup.png')),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          email = value.trim();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          hintText: "Your email",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          pass = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          hintText: "Your password",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (widget.check) {
                          try {
                            await _auth.signInWithEmailAndPassword(email: email, password: pass);
                            User? temp = _auth.currentUser;

                            if(temp!=null) {
                              if (temp.emailVerified) {
                                var collection = _fireStore.collection('users');
                                var querySnapshot = await collection.where('email', isEqualTo: email).get();
                                  var name = "Your name";
                                  var bio = "Your bio";
                                  String url="";
                                  for (var snapshot in querySnapshot.docs) {
                                    Map<String, dynamic> data = snapshot.data();
                                    name = data['name'].toString();
                                    bio = data['bio'].toString();
                                    url= data['photo'].toString();
                                    break;
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          ChatScreen(email, name, bio,url)));
                                  setState(() {
                                    showSpinner = false;
                                  });
                              } else {
                                showToast('User Not Exists', Colors.red);
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                            else{
                              showToast('Wrong credentials', Colors.red);
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        } else {
                          try {
                               _auth.createUserWithEmailAndPassword(email: email, password: pass);
                               await Future.delayed(const Duration(seconds: 5),(){
                               });
                             User temp=_auth.currentUser as User;
                             temp.sendEmailVerification();
                             showToast("Verify email in 30 seconds", Colors.greenAccent);
                             await Future.delayed(const Duration(seconds: 25),(){
                                temp.reload();
                              });
                              await Future.delayed(const Duration(seconds: 5),(){
                                temp=_auth.currentUser as User;
                                if(temp.emailVerified)
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>GetData(email)));
                                }
                                else{
                                  temp.delete();
                                }
                              });
                            setState(() {
                              showSpinner=false;
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner=false;
                            });
                            showToast('Error Try Again', Colors.red);
                          }
                        }
                      },
                      child: Text(widget.check?'Login':'Sign up',style: const TextStyle(fontSize: 20),),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Expanded(
                    flex: 1,
                    child: AlreadyHaveAnAccountCheck(
                      login: widget.check,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return widget.check
                                  ? const LS(false)
                                  : const LS(true);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    required this.login,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Login",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
