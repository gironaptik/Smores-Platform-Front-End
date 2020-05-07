import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/utils/my_navigator.dart';
import 'package:smores_app/utils/smores.dart';
import 'package:web_socket_channel/io.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'login_screen.dart';
import 'shopping_list_screen.dart';

final socketPath = 'ws://smoressmartspace.herokuapp.com/websocket';
final primary = Color(0xff23b574);
final secondary = Color(0xff00bae2);
final progress = Color(0xffe79f3c);

class SplashScreen extends StatefulWidget {
  User user;

  SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user;
  _SplashScreenState();

  loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print("haha");
      if (prefs.getString('currentUser') != null) {
        Map userMap = jsonDecode(prefs.getString('currentUser'));
        print(userMap);
        user = User.fromJson(userMap);
        print("Saved User: " + user.key.email);
      } else {
        user = new User();
        user.username = "Guest";
      }
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    loadUser();
    Timer(
      Duration(seconds: 5),
      () => this.user.username == 'Guest'
          ? Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShoppingCart(
                      user: this.user,
                      channel: IOWebSocketChannel.connect(socketPath))),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: primary),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70.0,
                        child:
                            Image(image: AssetImage('assets/splashlogo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        Smores.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 50,
                        animation: true,
                        lineHeight: 25.0,
                        animationDuration: 5000,
                        percent: 1.0,
                        center: Text("Loading..."),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      Smores.store,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
