import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
Future<bool?> showToast(String s,Color c)
{
  return Fluttertoast.showToast(
      msg: s,
      gravity: ToastGravity.CENTER,
      backgroundColor: c,
      textColor: Colors.black,
      fontSize: 20);
}