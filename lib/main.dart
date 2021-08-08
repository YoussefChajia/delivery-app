import 'package:delivery_app/pages/signin.dart';
import 'package:flutter/material.dart';

void main() => runApp(DeliApp());

class DeliApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      home: Signin(),
    );
  }
}


