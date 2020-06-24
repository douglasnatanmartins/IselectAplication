import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iselectaplication1990/model/user_model.dart';
import 'package:iselectaplication1990/src/home/home_screem_botton_navigator.dart';
import 'file:///C:/ProjetosFlutter/iselectaplication1990/lib/src/login/login_screem.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class SplashScreem extends StatefulWidget {
  @override
  _SplashScreemState createState() => _SplashScreemState();
}

class _SplashScreemState extends State<SplashScreem> {
  @override

  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 4
    ), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ScopedModelDescendant<UserModel>(
                    builder: (_, __, model) {
                      if (!model.isloggedIn()) {
                        return LoginPage();
                      } else {
                        return HomeScreen();
                      }
                    },
                  )
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/iphone3.png"), fit: BoxFit.cover)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 200, bottom: 15, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 10),
                  child: Text(
                    "ISelect",
                    style: GoogleFonts.acme(
                        textStyle: TextStyle(
                            fontSize: 50.0,
                            color: Colors.white, //Color(0xFF0ea7a4),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)),
                  )),
              LinearPercentIndicator(
                backgroundColor: Colors.grey[400],
                animation: true,
                lineHeight: 10,
                animationDuration: 3500,
                percent: 1.0,
                center: Center(
                  child: new Text(
                    "",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                progressColor: Colors.orange[700],
                linearStrokeCap: LinearStrokeCap.roundAll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}