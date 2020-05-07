import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/app_drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
// import 'package:aws_ai/aws_ai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../models/user.dart';

const url = 'https://smoressmartspace.herokuapp.com/smartspace/users';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class RegisterScreen extends StatefulWidget {
  String userName;
  static const routeName = '/register';
  RegisterScreen();

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  String username;
  String email;
  String avatar;
  String role;
  File _image;
  User user;
  ProgressDialog pr_reg;

  File sourceImagefile, targetImagefile;

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final File newImage = await picture.copy('$appDocPath/profile.png');
    this.setState(() {
      _image = newImage;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final File newImage = await picture.copy('$appDocPath/profile.png');
    this.setState(() {
      _image = newImage;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiseDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make your choise!"),
            content: SingleChildScrollView(
                child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(10.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    pr_reg = new ProgressDialog(context);
    pr_reg = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr_reg.style(
        message: 'Just a sec..',
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
      resizeToAvoidBottomPadding: true,
      drawer: AppDrawer(user: user),
      body: Stack(fit: StackFit.expand, children: <Widget>[
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
            Image.asset("asset/image_02.png")
          ],
        ),
        SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Smores",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .9,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(180),
                  ),
                  Container(
                      width: double.infinity,
                      height: ScreenUtil.getInstance().setHeight(720),
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
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Join Us!",
                                                style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil.getInstance()
                                                            .setSp(45),
                                                    fontFamily: "Poppins-Bold",
                                                    letterSpacing: .6)),
                                            SizedBox(
                                              height: ScreenUtil.getInstance()
                                                  .setHeight(30),
                                            )
                                          ]),
                                      InkWell(
                                          onTap: () {
                                            _showChoiseDialog(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black12,
                                                        width: 2),
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: _image == null
                                                          ? AssetImage(
                                                              "assets/profile.png")
                                                          : FileImage(_image),
                                                    ))),
                                          )),
                                    ]),
                                Text("Email",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance()
                                            .setSp(26))),
                                TextField(
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                    onChanged: (val) => email = val),
                                SizedBox(
                                  height:
                                      ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Username",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance()
                                            .setSp(26))),
                                TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                    onChanged: (val) => username = val),
                                SizedBox(
                                  height:
                                      ScreenUtil.getInstance().setHeight(30),
                                ),
                                Text("Role",
                                    style: TextStyle(
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance()
                                            .setSp(26))),
                                TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Role (Owner / Customer)",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                    onChanged: (val) => role = val),
                                Padding(padding: EdgeInsets.all(10.0)),
                                SizedBox(
                                  height:
                                      ScreenUtil.getInstance().setHeight(30),
                                ),
                              ]))),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(),
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
                                pr_reg.show();
                                setState(() {});
                                this.user = await register(
                                        username, email, avatar, role, _image)
                                    .then((_) {
                                  setState(() {});
                                  pr_reg.hide();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Center(
                                child: Text("SIGNUP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ))
                      ])
                ])))
      ]),
    );
  }

  Future<User> register(String username, String email, String avatar,
      String role, File _image) async {
    User newUser;
    var photoEmail = email;
    photoEmail = photoEmail.replaceAll('@', '_');
    print("photoemail :" + photoEmail);
    const region = "us-west-2";
    const bucketId = "smores-users";

    avatar = await AmazonS3Cognito.upload(
        _image.path,
        "smores-users",
        "us-west-2:47921d99-c61e-4382-bd67-3955cd35af79",
        photoEmail + '.png',
        AwsRegion.US_WEST_2,
        AwsRegion.US_WEST_2);

    var receivedUser = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "email": email,
          "username": username,
          "avatar": avatar,
          "role": role,
        }));

    if (receivedUser.statusCode == 200) {
      var convert = json.decode(receivedUser.body);
      newUser = User.fromJson(convert);
    } else {
      showInSnackBar("Sign-Up Failed");
      pr_reg.hide();
    }

    return newUser;
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value), duration: const Duration(seconds: 3)));
  }
}
