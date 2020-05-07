import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/element.dart';
import 'package:smores_app/models/recommendations.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:smores_app/widgets/network_image.dart';

class RecommendationsList extends StatefulWidget {
  User user;
  RecommendationsList({Key key, this.user}) : super(key: key);

  @override
  _RecommendationsList createState() => _RecommendationsList(user: this.user);
}

class _RecommendationsList extends State<RecommendationsList> {
  Widget body;
  @override
  void initState() {
    super.initState();
    getRecommendationList(user);
    //checkInList(user);
  }

  final User user;
  final primary = Color(0xff23b574);
  final secondary = Color(0xff00bae2);
  List topProducts = new List<Elementt>();
  _RecommendationsList({this.user});
  var recommendationList = new List<Elementt>();

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
            child: Column(children: <Widget>[
              // Container(
              //   padding: EdgeInsets.only(top: 145),
              //   height: MediaQuery.of(context).size.height,
              //   width: double.infinity,
              //   child: ListView.builder(
              //       itemCount: currentCheckInList.length,
              //       itemBuilder: (BuildContext newcontext, int index) {
              //         return buildList(newcontext, index);
              //       }),
              // ),
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
                        "Top 10 \nRecommendations",
                        textAlign: TextAlign.center,
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
              Container(
                  height: MediaQuery.of(context).size.height - 140,
                  width: MediaQuery.of(context).size.width,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            top: 26.0, left: 26.0, right: 26.0, bottom: 26.0),
                        sliver: SliverGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: <Widget>[
                            for (Elementt element in recommendationList)
                              cards(
                                  'https://smores-assets.s3-us-west-2.amazonaws.com/logo.png',
                                  element.name,
                                  element.elementProperties
                                      .price), // for (Elementt element in recommendationList)
                            //   cards(
                            //       'https://smores-assets.s3-us-west-2.amazonaws.com/logo.png',
                            //       element.name,
                            //       element.elementProperties.price),
                            // cards(
                            //     'https://smores-assets.s3-us-west-2.amazonaws.com/logo.png',
                            //     'Cabbage',
                            //     '37'),
                            // cards(
                            //     'https://smores-assets.s3-us-west-2.amazonaws.com/logo.png',
                            //     'Mango',
                            //     '22'),
                            // cards(
                            //     'https://smores-assets.s3-us-west-2.amazonaws.com/logo.png',
                            //     'Pineapple',
                            //     '90'),
                          ],
                        ),
                      )
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }

  void updateList() {
    setState(() {});
  }

  Widget cards(image, title, price) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PNetworkImage(
              image,
              height: 80,
            ),
            SizedBox(
              height: 5,
            ),
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 4),
                color: Colors.deepOrange,
                child: Text("\₪$price",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Future<void> getRecommendationList(User user) async {
    final recommendationPath =
        'https://smoresrecommendationsystem.herokuapp.com/search?id=' +
            user.key.email;
    var result = await http.get(Uri.encodeFull(recommendationPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      Map<String, dynamic> tagObjsJson = jsonDecode(result.body);
      // var arr = tagObjsJson.split('|');
      List elementsId = tagObjsJson.values.toString().split('|');
      for (int i = 0; i < elementsId.length; i++) {
        elementsId[i] = elementsId[i].replaceAll('(', '');
        elementsId[i] = elementsId[i].replaceAll(')', '');
        recommendationList.add(await getElement(user, elementsId[i]));
      }
    } else {
      Text("Failed");
    }
    setState(() {});
  }

  Future<Elementt> getElement(User user, String elementName) async {
    final getElementPath =
        'https://smoressmartspace.herokuapp.com/smartspace/elements/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?search=name&value=' +
            elementName;
    List recievedElementList = new List();
    var result = await http.get(Uri.encodeFull(getElementPath),
        headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var tagObjsJson = jsonDecode(result.body) as List;
      recievedElementList =
          tagObjsJson.map((name) => new Elementt.fromJson(name)).toList();
    } else {
      Text("Failed");
    }
    return recievedElementList[0];
  }
}
