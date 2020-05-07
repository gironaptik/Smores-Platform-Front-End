import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/pages/analytics_screen.dart';
import 'package:smores_app/pages/animations/update_element_screen.dart';
import 'package:smores_app/pages/history_purchases_screen.dart';
import 'package:smores_app/pages/new_element_screen.dart';
import 'package:smores_app/pages/online_users_screen.dart';
import 'package:smores_app/pages/profile_screen.dart';
import 'package:smores_app/pages/recommendations_screen.dart';
import 'package:smores_app/pages/shopping_list_screen.dart';
import 'package:web_socket_channel/io.dart';
import '../pages/register_screen.dart';
import 'package:http/http.dart' as http;

final socketPath = 'ws://smoressmartspace.herokuapp.com/websocket';
final secondary = Color(0xff333C46);

Future<Actionn> logOut(String username, String password) async {
  final String loginurl =
      "https://smoressmartspace.herokuapp.com/smartspace/actions";
  Actionn newAction = Actionn.empty();
  print("test  " + username + "  test2  " + password);
  await http.post(loginurl,
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "actionKey": {"id": null, "smartspace": null},
        "type": "CheckOut",
        "created": null,
        "element": {"id": "5e5ed061a14a1c000467c831", "smartspace": "Smores"},
        "player": {"smartspace": username, "email": password},
        "properties": {}
      }));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('email');
  return newAction;
}

class AppDrawer extends StatelessWidget {
  @override
  User user;
  AppDrawer({this.user});
  Widget build(BuildContext context) {
    String userName = this.user.username;
    if (userName == '' || userName == "null") {
      userName = 'Guest';
    }
    if (this.user.role == 'PLAYER') {
      //PLAYER Permissions
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20), bottom: Radius.circular(20)),
        child: Drawer(
          child: Container(
            child: Column(
              children: <Widget>[
                // AppBar(
                //    title: Text('Hello $userName!'),
                //    automaticallyImplyLeading: false,
                // ),
                UserAccountsDrawerHeader(
                  accountName: Text(user.username),
                  accountEmail: Text(user.key.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? primary
                            : Colors.white,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shop),
                  title: Text('Shopping Cart'),
                  onTap: () {
                    //Navigator.of(context).pushReplacementNamed('/');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => ShoppingCart(
                    //           user: this.user,
                    //           channel: IOWebSocketChannel.connect(socketPath))),
                    // );
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingCart(
                                user: this.user,
                                channel:
                                    IOWebSocketChannel.connect(socketPath))),
                        (route) => false);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Recommendations List'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingCart(
                              user: this.user,
                              channel: IOWebSocketChannel.connect(socketPath))),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Shopping History'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HistoryPurchases(user: this.user)));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: this.user)),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log-out'),
                  onTap: () async {
                    // await logOut("Smores", user.key.email);
                    // userName = 'Guest';
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('currentUser');
                    prefs.reload();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      if (this.user.role == 'MANAGER') {
        // Manager Permissions
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.circular(20)),
          child: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(user.username),
                  accountEmail: Text(user.key.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? primary
                            : Colors.white,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shop),
                  title: Text('Shopping List'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShoppingCart(
                                user: this.user,
                                channel:
                                    IOWebSocketChannel.connect(socketPath))),
                        (route) => false);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Recommendations List'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecommendationsList(user: this.user)),
                        (route) => false);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Shopping History'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HistoryPurchases(user: this.user)));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.add_box),
                  title: Text('New Product'),
                  onTap: () {
                    //Navigator.of(context).pushReplacementNamed('/');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewElement(user: this.user)));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Update Product'),
                  onTap: () {
                    //Navigator.of(context).pushReplacementNamed('/');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateElement(user: this.user)));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle),
                  title: Text('Current Customers'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OnlineUsers(user: this.user)));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.perm_data_setting),
                  title: Text('Store Analytics'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AnalyticsScreen(user: this.user)),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: this.user)),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log-out'),
                  onTap: () async {
                    // await logOut("Smores", user.key.email);
                    // userName = 'Guest';
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('currentUser');
                    // Navigator.of(context).pushReplacementNamed('/');
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  },
                ),
              ],
            ),
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), bottom: Radius.circular(20)),
          child: Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(user.username),
                  accountEmail: Text(user.key.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? primary
                            : Colors.white,
                    child: Text(
                      user.username[0].toUpperCase(),
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.shop),
                  title: Text('Log-in'),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.library_add),
                  title: Text('Register'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Support'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
