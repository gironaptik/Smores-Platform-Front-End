import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smores_app/models/user.dart';
import 'package:smores_app/pages/splash_screen.dart';
import 'package:social_media_buttons/social_media_button.dart';
import 'package:smores_app/widgets/app_drawer.dart';
import '../pages/register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bmprogresshud/bmprogresshud.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
ProgressDialog pr;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => new _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  User user = User(username: 'Guest', key: null, role: 'Guest', avatar: null);
  String userName;
  String password;
  String name = 'Guest';
  ProgressDialog pr;

  Widget radioButton() => Container(
      width: 16.0,
      height: 16.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      ));

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Logging in.. ',
        borderRadius: 20.0,
        backgroundColor: Colors.grey[200],
        progressWidget: SpinKitSquareCircle(
          color: Colors.lightBlue,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      drawer: AppDrawer(user: user),
      body: ProgressHud(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset("assets/image_01.png"),
                ),
                Expanded(
                  child: Container(),
                ),
                Image.asset("assets/image_02.png")
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Smores",
                            style: TextStyle(
                                fontFamily: "Poppins-Medium",
                                fontSize: ScreenUtil.getInstance().setSp(50),
                                letterSpacing: .9,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(160),
                    ),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(500),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, 15.0),
                                blurRadius: 15.0),
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0.0, -10.0),
                                blurRadius: 10.0),
                          ]),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Login",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(45),
                                    fontFamily: "Poppins-Bold",
                                    letterSpacing: .6)),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text("Smartspace Name",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26))),
                            TextField(
                                decoration: InputDecoration(
                                    hintText: "Smores",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                                onChanged: (val) => userName = val),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(30),
                            ),
                            Text("Email",
                                style: TextStyle(
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(26))),
                            TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12.0)),
                                onChanged: (val) => password = val),
                            SizedBox(
                              height: ScreenUtil.getInstance().setHeight(15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: null,
                              child: radioButton(),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text("Remember me",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: "Poppins-Medium"))
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  _showLoadingHud(context);
                                  pr.show();
                                  // await newLogin(userName, password);
                                  user = await login(userName, password);
                                  pr.hide();
                                  if (user.username != 'Guest') {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SplashScreen()),
                                        (route) => false);
                                    // _radio();
                                  }
                                },
                                child: Center(
                                  child: Text("SIGNIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Bold",
                                          fontSize: 18,
                                          letterSpacing: 1.0)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "New User? ",
                          style: TextStyle(
                              fontFamily: "Poppins-Medium", fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text("SignUp",
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontFamily: "Poppins-Bold",
                                  fontSize: 20)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(50),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text("About Us",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SocialMediaButton.linkedin(
                                onTap: () {
                                  print('or just use onTap callback');
                                },
                                size: 35,
                                color: Colors.blue,
                                url:
                                    'https://www.linkedin.com/in/giron-aptik-8b211996/',
                              ),
                              Text("Giron Aptik",
                                  style:
                                      TextStyle(fontFamily: "Poppins-Medium"))
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SocialMediaButton.linkedin(
                                onTap: () {
                                  print('or just use onTap callback');
                                },
                                size: 35,
                                color: Colors.blue,
                                url: 'https://www.linkedin.com/in/shai-bremer/',
                              ),
                              Text("Shai Bremer",
                                  style:
                                      TextStyle(fontFamily: "Poppins-Medium"))
                            ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> login(String username, String password) async {
    print("username == " + username + " password == " + password);
    String url =
        'https://smoressmartspace.herokuapp.com/smartspace/users/login/$username/$password';
    var result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    if (result.statusCode == 200) {
      var convert = json.decode(result.body);
      user = User.fromJson(convert);
      String sharedUser = jsonEncode(User.fromJson(convert));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('currentUser', sharedUser);
      // prefs.setString('email', _user.email);
    } else {
      user.username = 'Guest';
      pr.hide();
      showInSnackBar("Login Failed");
    }
    return user;
  }

  Future<Widget> _showLoadingHud(BuildContext context) async {
    ProgressHud.of(context).show(ProgressHudType.loading, "loading...");
    await Future.delayed(const Duration(seconds: 1));
    ProgressHud.of(context).dismiss();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value), duration: const Duration(seconds: 3)));
  }
}
