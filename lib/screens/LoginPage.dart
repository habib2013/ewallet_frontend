import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';
import 'package:wallet_app/screens/ForgotPassword.dart';
import 'package:wallet_app/screens/HomeWithSidebar.dart';
import 'package:wallet_app/screens/NoWalletYet.dart';
import 'package:wallet_app/screens/SignupPage.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool vis = true;
  final _globalKey = GlobalKey<FormState>();

  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  String errorText;
  bool validate = false;
  bool circular = false;
  final storage = new FlutterSecureStorage();


  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                FeatherIcons.arrowLeftCircle,
                color: Colors.black,
                size: 35,
              ),
            ),
            Text('',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(var editController, String title,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          Text(
//            title,
//            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "${title} cannot be empty";
                }
                if (title == 'Email' && !value.contains('@')) {
                  return 'Email is Invalid';
                }
                if ((title == 'Password' || title == 'Confirm Password') && value.length <= 8) {
                  return 'Password can\'t be less than 8';
                }
              },
              obscureText: isPassword && vis,
              controller: editController,
              decoration: InputDecoration(
                  hintText: title,
                  errorText: validate ? null : errorText,
                  prefixIcon: isPassword != true
                      ? Icon(FeatherIcons.mail)
                      : Icon(Icons.lock),
                  suffixIcon: isPassword == true
                      ? IconButton(
                          icon: vis
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              vis = !vis;
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffffac30))),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffffac30)),
                  ),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {

    return InkWell(
      onTap: ()  async{
        setState(() {

//          circular = true;
        });
        if (_globalKey.currentState.validate()) {

          Map<String, String> data = {
            "email": _emailEditingController.text,
            "password": _passwordEditingController.text,
          };
          var response = await networkHandler.post("login", data);
          if (response.statusCode == 200 || response.statusCode == 201) {

            Map<String, dynamic> output = json.decode(response.body);
//          print(output['token']);
            var userID = output['userID'].toString();
            var name = output['name'];
            var customerID = output['customerID'];
            print(
                "userID is ${userID} and name is ${name} and customerID ${customerID}");

            await storage.write(key: "userID", value: userID);
            await storage.write(key: "token", value: output['userToken']);
            await storage.write(key: "name", value: output['name']);

            setState(() {
              validate = true;
              circular = false;
            });
            if (output['customerID'] != 'null') {
              await storage.write(
                  key: "customerID", value: output['customerID']);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeWithSidebar()),
                      (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NoWalletYet()),
                      (route) => false);
            }
          }

          else if(response.statusCode == 404) {
            circular = false;

          }
          else {
//          String output = json.decode(response.body);

            setState(() {
              validate = false;
//            errorText = output;
              circular = false;
            });
          }


        }




      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffffac30),
                  Color(0xffffac30),
                ])),
        child: circular
            ? CircularProgressIndicator()
            : Text(
                'Login',
                style: TextStyle(
                    fontSize: 24, color: Colors.white, fontFamily: 'ubuntu'),
              ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Josefin Sans',
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Josefin Sans',
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignupPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Josefin Sans'),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('asset/images/logo.png'),
                  fit: BoxFit.contain)),
        ),
        Text(
          "eWallet",
          style: TextStyle(
              fontSize: 50, fontFamily: 'ubuntu', fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(_emailEditingController, "Email"),
        _entryField(_passwordEditingController, "Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      color: Colors.grey[100],
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Josefin Sans')),
                      ),
                    ),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
