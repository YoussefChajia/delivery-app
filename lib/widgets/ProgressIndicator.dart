import 'package:flutter/material.dart';

class ProgressDialogPrimary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery
        .of(context)
        .platformBrightness == Brightness.light;
    return Scaffold(
      body: Center(
          child: Container(
            height: 80.0,
            width: 80.0,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 8.0,
            ),
          ),
        ),
      backgroundColor: brightness ? Colors.white.withOpacity(
          0.70) : Colors.black.withOpacity(
          0.70), 
    );
  }
}