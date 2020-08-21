import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(

      body : Stack(
        children: <Widget>[
              Center(
          child: Container(
            width: deviceSize.width * 0.3,
            height: deviceSize.width * 0.3,
            child: Image.asset('lib/assets/images/logo.png')),
        ),

        Center(
          child: SizedBox(
            width: deviceSize.width * 0.3,
            height: deviceSize.width * 0.3,
            child: CircularProgressIndicator()       
          )
        )

        ],
      )
      
    );
  }
}