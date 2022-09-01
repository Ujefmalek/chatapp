import 'package:chatapp/Screens/Login_signup.dart';
import 'package:flutter/material.dart';
import 'Screens/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
late int? isViewed;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs= await SharedPreferences.getInstance();
  isViewed= await prefs.getInt('isViewed');
  await prefs.setInt('isViewed', 1);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isViewed==0 || isViewed==null ? const WelcomeScreen() : const LS(false),
    );
  }
}
