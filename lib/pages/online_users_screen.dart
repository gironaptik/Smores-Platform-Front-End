import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;

class OnlineUsers extends StatefulWidget {
  User user;
  OnlineUsers({Key key, this.user}) : super(key: key);

  static final String path = "lib/src/pages/lists/list2.dart";

  @override
  _OnlineUsers createState() => _OnlineUsers(user: this.user);
}

class _OnlineUsers extends State<OnlineUsers> {
  Widget body;
  @override
  void initState() {
    super.initState();
  }

  final User user;

  _OnlineUsers({this.user});

  // var checkInListList = new List<Actionn>();
  var onlineUserActionList = new List<Actionn>();
  var onlineUserList = new List<User>();

  // var orederedList = new Map<String, Map>();

  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);
  final primary = Color(0xff23b574);
  final secondary = Color(0xff00bae2);

  TextEditingController customerEditingController = new TextEditingController();

  List<Map> currentCheckInList = [];

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: AppDrawer(user: user),
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 145),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: currentCheckInList.length,
                      itemBuilder: (BuildContext newcontext, int index) {
                        return buildList(newcontext, index);
                      }),
                ),
                Container(
                  height: 140,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Current Customers",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.help,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 3, color: secondary),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        currentCheckInList[index]['logoText']),
                    fit: BoxFit.fill),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentCheckInList[index]['name'],
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(currentCheckInList[index]['location'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.perm_device_information,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(currentCheckInList[index]['type'],
                          style: TextStyle(
                              color: primary, fontSize: 13, letterSpacing: .3)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> getOnlineUsersList(User user, String actionType) async {
    var onlineUsersPath =
        'https://smoressmartspace.herokuapp.com/smartspace/manager/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?search=allbytype&type=CheckIn';

    var result = await http.get(Uri.encodeFull(onlineUsersPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var tagObjsJson = jsonDecode(result.body) as List;
      onlineUserActionList =
          tagObjsJson.map((name) => new Actionn.fromJson(name)).toList();
    } else {
      Text("Failed");
    }
    for (var action in onlineUserActionList) {
      if (action.properties.checkout != null) {
        onlineUserList.remove(action);
      } else {
        await login(action.player.email, action.player.smartspace);
      }
    }
  }

  Future<User> login(String username, String smartspace) async {
    User user;
    String url =
        'https://smoressmartspace.herokuapp.com/smartspace/users/login/$username/$smartspace';
    var result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var convert = json.decode(result.body);
      user = User.fromJson(convert);
      // prefs.setString('email', _user.email);
      onlineUserList.add(user);
      setState(() {});
    }

    return user;
  }
}
