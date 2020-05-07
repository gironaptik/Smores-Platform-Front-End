import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:random_color/random_color.dart';
import 'package:smores_app/models/action.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/pages/animations/analytics_animation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:smores_app/pages/splash_screen.dart';
import 'package:smores_app/utils/indicator.dart';
import 'package:smores_app/widgets/app_drawer.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

User user;
var userAmount = 0;
var ordersAmount = 0;
final primary = Color(0xff23b574);
final String image =
    "https://smores-assets.s3-us-west-2.amazonaws.com/logo.png";

class AnalyticsScreen extends StatefulWidget {
  static final String path = "lib/src/pages/dashboard/dash1.dart";
  User user;
  AnalyticsScreen({Key key, this.user}) : super(key: key);
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState(user: this.user);
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  User user;
  int touchedIndex;
  var dropdownValue = 'Shelf 1';

  static List<Actionn> chargeActionList = new List<Actionn>();
  static List<Actionn> returnActionList = new List<Actionn>();
  List dateRange = new List();
  List productName = new List();
  List productAmount = new List();

  var actions = new Map<String, Map>();
  var colors = new Map<String, Color>();

  DateTime selectedMonth;

  _AnalyticsScreenState({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(user: user),
      backgroundColor: Theme.of(context).buttonColor,
      body: _buildBody(context),
    );
  }

  List changeDateFormat(DateTime date) {
    String currentMounth = DateFormat('MMyyyy').format(date);
    var newDate = new DateTime(date.year, date.month + 1);
    String untilMonth = DateFormat('MMyyyy').format(newDate);
    return [currentMounth, untilMonth];
  }

  @override
  void initState() {
    super.initState();
    selectedMonth = new DateTime(2020, 4);
    dateRange = changeDateFormat(selectedMonth);
    analyzeStore(user, dateRange[0], dateRange[1]);

    getUserAmount(user);
    getOrdersAmount(user);
  }

  List<PieChartSectionData> showingSections = new List();

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        Builder(
          builder: (context) => SliverToBoxAdapter(
            child: Container(
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
                      "Store Analytics",
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
          ),
        ),
        _buildStats(),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  _buildTitledContainer("Organization Rating",
                      child: Column(
                        children: [
                          new MonthStrip(
                            format: 'MMM yyyy',
                            from: new DateTime(2020, 2),
                            to: new DateTime(2021, 2),
                            initialMonth: selectedMonth,
                            height: 48.0,
                            viewportFraction: 0.25,
                            onMonthChanged: (v) {
                              setState(() {
                                selectedMonth = v;
                                dateRange = changeDateFormat(selectedMonth);
                                analyzeStore(user, dateRange[0], dateRange[1]);
                              });
                            },
                          ),
                          Container(
                            height: 300,
                            child: (ordersAmount & userAmount) != 0
                                ? AspectRatio(
                                    aspectRatio: 1.3,
                                    child: Card(
                                      color: Colors.white,
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 18,
                                          ),
                                          Expanded(
                                            child: AspectRatio(
                                              aspectRatio: 1,
                                              child: PieChart(
                                                PieChartData(
                                                    pieTouchData: PieTouchData(
                                                        touchCallback:
                                                            (pieTouchResponse) {
                                                      setState(() {
                                                        if (pieTouchResponse
                                                                    .touchInput
                                                                is FlLongPressEnd ||
                                                            pieTouchResponse
                                                                    .touchInput
                                                                is FlPanEnd) {
                                                          touchedIndex = -1;
                                                        } else {
                                                          touchedIndex =
                                                              pieTouchResponse
                                                                  .touchedSectionIndex;
                                                        }
                                                      });
                                                    }),
                                                    borderData: FlBorderData(
                                                      show: false,
                                                    ),
                                                    sectionsSpace: 0,
                                                    centerSpaceRadius: 40,
                                                    sections: showingSections),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              for (var name in actions.keys)
                                                Column(children: <Widget>[
                                                  Indicator(
                                                    color: colors[name],
                                                    text: name,
                                                    isSquare: true,
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  )
                                                ]),
                                              SizedBox(
                                                height: 18,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 28,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CircularPercentIndicator(
                                      radius: 120.0,
                                      lineWidth: 13.0,
                                      animation: true,
                                      percent: 1.0,
                                      footer: new Text(
                                        "Calculating",
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.purple,
                                    ),
                                  ),
                          ),
                        ],
                      )),
                ],
              )),
        ),
        _buildActivities(context),
      ],
    );
  }

  createAlertDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // orderProducts();
          return StatefulBuilder(
            builder: (context, setState) {
              return actions.isEmpty
                  ? Container()
                  : new AlertDialog(
                      backgroundColor: Colors.transparent,
                      actions: <Widget>[
                        new Container(
                          height: 300.0,
                          width: 300.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xfff0f0f0),
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(15.0))),
                          child: new Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                padding:
                                    new EdgeInsets.only(top: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: primary,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        dateRange[0].substring(0, 2) +
                                            "-" +
                                            dateRange[0].substring(
                                                dateRange[0].length - 4) +
                                            " To: " +
                                            dateRange[1].substring(0, 2) +
                                            "-" +
                                            dateRange[0].substring(
                                                dateRange[1].length - 4),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: new EdgeInsets.only(
                                    left: 10.0, right: 10, bottom: 10, top: 10),
                                child: new Column(children: <Widget>[
                                  new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new DropdownButton<String>(
                                        value: dropdownValue,
                                        // value: dropdownValue != null ? dropdownValue : null,
                                        items: actions.keys
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                            productName.clear();
                                            productAmount.clear();
                                            productName = actions[dropdownValue]
                                                    ['products']
                                                .keys
                                                .toList();
                                            productAmount =
                                                actions[dropdownValue]
                                                        ['products']
                                                    .values
                                                    .toList();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Padding(
                                      padding: new EdgeInsets.only(
                                          left: 40.0, right: 40, top: 10),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Item",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("Purchases",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      )),
                                  Container(
                                      height: 60,
                                      child: ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children: [
                                            for (int i = 0;
                                                i <
                                                    actions[dropdownValue]
                                                            ['products']
                                                        .length;
                                                i++)
                                              Padding(
                                                padding: new EdgeInsets.only(
                                                    left: 40.0,
                                                    right: 40,
                                                    top: 10),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(productName[i],
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12)),
                                                    Text('${productAmount[i]}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12))
                                                  ],
                                                ),
                                              )
                                          ])),
                                  Divider(),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                          padding: new EdgeInsets.all(10),
                                          child: new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                    "Income: \₪" +
                                                        actions[dropdownValue]
                                                                ['profit']
                                                            .toStringAsFixed(2),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "Purchases: " +
                                                        actions[dropdownValue]
                                                                ['purchases']
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ]))),
                                ]),
                              ),
                              // for (var entry in orederedList.entries)
                              //   Padding(
                              //     padding: new EdgeInsets.only(
                              //         left: 40.0, right: 60, bottom: 10, top: 10),
                              //     child: new Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(entry.value['title'],
                              //             style:
                              //                 TextStyle(color: Colors.black, fontSize: 18)),
                              //         Text(entry.value['amount'].toString(),
                              //             style:
                              //                 TextStyle(color: Colors.black, fontSize: 18))
                              //       ],
                              //     ),
                              //   )
                            ],
                          ),
                        )
                      ],
                    );
            },
          );
        });
  }

  SliverPadding _buildStats() {
    final TextStyle stats = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);
    return SliverPadding(
      padding: const EdgeInsets.only(
          top: 4.0, bottom: 16.0, left: 16.0, right: 16.0),
      sliver: SliverGrid.count(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 2,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$userAmount",
                  style: stats,
                ),
                const SizedBox(height: 5.0),
                Text("Customers".toUpperCase())
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.pink,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$ordersAmount",
                  style: stats,
                ),
                const SizedBox(height: 5.0),
                Text("Orders".toUpperCase())
              ],
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Features",
          height: 180,
          child: Expanded(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: features
                  .map(
                    (activity) => Column(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () => createAlertDialog(context),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Theme.of(context).buttonColor,
                              child: activity.icon != null
                                  ? Icon(
                                      activity.icon,
                                      size: 18.0,
                                      color: primary,
                                    )
                                  : null,
                            )),
                        const SizedBox(height: 5.0),
                        Text(
                          activity.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTitledContainer(String title, {Widget child, double height}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
          ),
          if (child != null) ...[const SizedBox(height: 10.0), child]
        ],
      ),
    );
  }

  Future<void> getUserAmount(User user) async {
    String url =
        'https://smoressmartspace.herokuapp.com/smartspace/users/amount/' +
            user.key.smartspace +
            '/' +
            user.key.email;
    var result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      setState(() {
        userAmount = json.decode(result.body);
      });
    } else {
      userAmount = 0;
    }
  }

  Future<void> getOrdersAmount(User user) async {
    String url =
        'https://smoressmartspace.herokuapp.com/smartspace/actions/amount/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?type=CheckOut';
    var result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      setState(() {
        ordersAmount = json.decode(result.body);
      });
    } else {
      ordersAmount = 0;
    }
  }

  Future<void> analyzeStore(User user, String fromDate, String toDate) async {
    String chargeUrl =
        'https://smoressmartspace.herokuapp.com/smartspace/manager/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?search=all&type=Charge&fromDate=' +
            fromDate +
            '&toDate=' +
            toDate;

    String returnUrl =
        'https://smoressmartspace.herokuapp.com/smartspace/manager/' +
            user.key.smartspace +
            '/' +
            user.key.email +
            '?search=all&type=Return&fromDate=' +
            fromDate +
            '&toDate=' +
            toDate;
    var chargeResult = await http.get(Uri.encodeFull(chargeUrl),
        headers: {"Accept": "application/json"});
    var returnResult = await http.get(Uri.encodeFull(returnUrl),
        headers: {"Accept": "application/json"});
    if (chargeResult.statusCode == 200 && returnResult.statusCode == 200) {
      if (chargeResult.body != null) {
        var tagObjsJson = jsonDecode(chargeResult.body) as List;
        chargeActionList =
            tagObjsJson.map((name) => new Actionn.fromJson(name)).toList();
      }
      if (returnResult.body != null) {
        var tagObjsJson = jsonDecode(returnResult.body) as List;
        returnActionList =
            tagObjsJson.map((name) => new Actionn.fromJson(name)).toList();
      }
      List<Actionn> combinedActionList = chargeActionList + returnActionList;
      actions.clear();
      for (Actionn action in combinedActionList) {
        var products = new Map<String, int>();
        products.clear();
        if (actions.containsKey(action.properties.shelf)) {
          var updateAction = actions[action.properties.shelf];
          var newAction = new Map();
          if (action.type == "Charge") {
            updateAction['products'].containsKey(action.properties.product)
                ? updateAction['products'][action.properties.product] =
                    updateAction['products'][action.properties.product] =
                        ++updateAction['products'][action.properties.product]
                : updateAction['products'][action.properties.product] = 1;
            //updateAction.update('products', (value) => newAction);
            var price = updateAction['profit'];
            updateAction.update(
                'profit', (value) => price + action.properties.price);
            int amount = updateAction['purchases'];
            updateAction.update('purchases', (value) => ++amount);
          } else {
            if (updateAction['products']
                .containsKey(action.properties.product)) {
              updateAction['products'][action.properties.product] =
                  updateAction['products'][action.properties.product] =
                      --updateAction['products'][action.properties.product];
            }
            var price = updateAction['profit'];
            updateAction.update(
                'profit', (value) => price - action.properties.price);
            int amount = updateAction['purchases'];
            updateAction.update('purchases', (value) => --amount);
          }
          actions.update(action.properties.shelf, (value) => updateAction);
        } else {
          var newAction = new Map();
          products.putIfAbsent(action.properties.product, () => 1);
          newAction.putIfAbsent("products", () => products); //Amount
          newAction.putIfAbsent("profit", () => action.properties.price);
          newAction.putIfAbsent('purchases', () => 1);
          actions.putIfAbsent(action.properties.shelf, () => newAction);
        }
      }

      final isTouched = actions.keys.length == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      showingSections.clear();
      for (var name in actions.keys) {
        Color _color = RandomColor()
            .randomColor(colorSaturation: ColorSaturation.mediumSaturation);
        colors.putIfAbsent(name, () => _color);
        showingSections.add(new PieChartSectionData(
          color: colors[name],
          value: actions[name]['purchases'].toDouble(),
          title: actions[name]['purchases'].toString(),
          radius: radius,
          titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff)),
        ));
      }
      productName.clear();
      productAmount.clear();
      productName = actions[dropdownValue]['products'].keys.toList();
      productAmount = actions[dropdownValue]['products'].values.toList();
      print(actions.toString());
      setState(() {});
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value), duration: const Duration(seconds: 3)));
  }
}

class Activity {
  final String title;
  final IconData icon;
  Activity({this.title, this.icon});
}

final List<Activity> features = [
  Activity(title: "Reports", icon: FontAwesomeIcons.listOl),
  Activity(title: "Top Products", icon: FontAwesomeIcons.medal),
];
