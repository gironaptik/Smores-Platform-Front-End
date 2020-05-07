import 'dart:convert';

import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
// import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:smores_app/core/presentation/res/assets.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:smores_app/widgets/network_image.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({Key key, this.user}) : super(key: key);
  static final String path = "lib/src/pages/profile/profile3.dart";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final image = avatars[1];
  int purchases = 0;
  int visits = 0;

  @override
  void initState() {
    // TODO: implement initState
    getVisitsAmount(widget.user);
    getPurchasesAmount(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(user: widget.user),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: 250,
              width: double.infinity,
              child: PNetworkImage(
                'https://smores-assets.s3-us-west-2.amazonaws.com/cover.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    this.widget.user.username,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(this.widget.user.role),
                                    subtitle: Text("Smores"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("$purchases"),
                                      Text("Purchases")
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text("$visits"),
                                      Text("Visits")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    this.widget.user.avatar),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("User information"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Email"),
                          subtitle: Text(this.widget.user.key.email),
                          leading: Icon(Icons.email),
                        ),
                        ListTile(
                          title: Text("Role"),
                          subtitle: Text(widget.user.role),
                          leading: Icon(Icons.work),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ],
        ),
      ),
    );
  }

  Future<int> getVisitsAmount(User user) async {
    final getElementPath =
        'https://smoressmartspace.herokuapp.com/smartspace/actions/amount/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?type=CheckIn';
    var result = await http.get(Uri.encodeFull(getElementPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      setState(() {
        visits = jsonDecode(result.body) as int;
      });
      return visits;
    } else {
      Text("Failed");
      return null;
    }
    setState(() {});
  }

  Future<int> getPurchasesAmount(User user) async {
    final getElementPath =
        'https://smoressmartspace.herokuapp.com/smartspace/actions/amount/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?type=Charge';
    var result = await http.get(Uri.encodeFull(getElementPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      setState(() {
        purchases = jsonDecode(result.body) as int;
      });
      return purchases;
    } else {
      Text("Failed");
      return null;
    }
  }
}
