import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/pages/analytics_screen.dart';
import 'package:smores_app/pages/history_purchases_screen.dart';
import 'package:smores_app/pages/login_screen.dart';
import 'package:smores_app/pages/shopping_list_screen.dart';
import 'package:smores_app/pages/splash_screen.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dcdg/dcdg.dart';

final socketPath = 'ws://smoressmartspace.herokuapp.com/websocket';

Future<void> main() async {
  User currentUser;
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("haha");
  if (prefs.getString('currentUser') != null) {
    Map userMap = jsonDecode(prefs.getString('currentUser'));
    print(userMap);
    currentUser = User.fromJson(userMap);
    print("Saved User: " + currentUser.key.email);
  } else {
    currentUser = new User();
    currentUser.username = "Guest";
  }

  runApp(MaterialApp(
    home: SplashScreen(),
    // currentUser == null
    //     ? LoginScreen()
    //     : ShoppingCart(
    //         user: currentUser, channel: IOWebSocketChannel.connect(socketPath))

    routes: {
      // '/': (ctx) => SplashScreen(user: currentUser),
      '/history_purchases': (ctx) => HistoryPurchases(user: currentUser),
      '/analytics': (ctx) => AnalyticsScreen(user: currentUser),
      '/shopping_list': (ctx) => ShoppingCart(
          user: currentUser, channel: IOWebSocketChannel.connect(socketPath))
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSelected = false;

  void _radio() {
    setState(() {
      AppDrawer();
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold();
  }
}
