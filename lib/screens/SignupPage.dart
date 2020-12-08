import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';
import 'package:wallet_app/screens/ForgotPassword.dart';
import 'package:wallet_app/screens/HomeWithSidebar.dart';
import 'package:wallet_app/screens/LoginPage.dart';
import 'package:wallet_app/screens/SignupPage.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool vis = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  SharedPreferences preferences;

  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _c_password_EditingController = TextEditingController();
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
              child: Icon(FeatherIcons.arrowLeftCircle, color: Colors.black,size: 35,),
            ),
            Text('',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(var editController,String title, {bool isPassword = false}) {
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
              controller: editController,
              validator: (value) {
                if (value.isEmpty) {
                  return "${title} cannot be empty";
                }
                if (title == 'Email address' && !value.contains('@')) {
                  return 'Email is Invalid';
                }
                if ((title == 'Password' || title == 'Confirm Password') && value.length <= 8) {
                  return 'Password can\'t be less than 8';
                }
              },

              obscureText: isPassword && vis,
              decoration: InputDecoration(
                  errorText: validate && title != 'Username' ? null : errorText,
                  prefixIcon: title == 'Email address' ? Icon(FeatherIcons.mail) : title == 'Name' ? Icon(FeatherIcons.user) : Icon(FeatherIcons.lock),
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
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),

                  filled: true)
          )
        ],
      ),
    );
  }


  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
//        await checkUser();
        if (_globalKey.currentState.validate()) {
          print('Data Sent to server ');

          Map<String,String> data = {
            "name" : _nameEditingController.text,
            "email": _emailEditingController.text,
            "password": _passwordEditingController.text,
            "c_password": _c_password_EditingController.text,

          };
          var responseRegister =   await networkHandler.post("register",data);

          if (responseRegister.statusCode == 200 || responseRegister.statusCode == 201) {
//            final snackBar = SnackBar(content: Text('Registeration successful'));
//            Scaffold.of(context).showSnackBar(snackBar);
          print('Registeration successful');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);

//            Map<String,String> data = {
//              "email" : _emailEditingController.text,
//              "password": _passwordEditingController.text,
//            };
//            var response = await networkHandler.post("login", data);
//            if (response.statusCode == 200 || response.statusCode == 201 ) {
//              Map<String,dynamic> output = json.decode(response.body);
//              print(output['userToken']);
//
//              await storage.write(key: "token", value: output['userToken']);
//              setState(() {
//                validate = true;
//                circular = false;
//              });
//              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeWithSidebar()), (route) => false);
//
//            }
          print('return a success code');
          }
        else{
//            final snackBar = SnackBar(content: Text('Unable To Register🤔'));
//            Scaffold.of(context).showSnackBar(snackBar);
          print('Unable to register');
          }

          setState(() {
            circular = false;
          });
          print(data);
        }
        else{
          setState(() {
            circular = false;
          });
        }
//        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWithSidebar()));
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
          'Create Account',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'ubuntu'),
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
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ubuntu'),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login now',
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
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 30,
          width: 70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('asset/images/logo.png'),
                  fit: BoxFit.contain
              )
          ),
        ),
        Text("eWallet", style: TextStyle(
            fontSize: 30,
            fontFamily: 'ubuntu',
            fontWeight: FontWeight.w600
        ),),
        SizedBox(height: 10,),

      ],
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField(_nameEditingController, "Name"),
        _entryField(_emailEditingController, "Email address"),
        _entryField(_passwordEditingController, "Password",isPassword: true),
        _entryField(_c_password_EditingController, "Confirm Password", isPassword: true),
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
                        SizedBox(height: height * .12),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 30),
                        _submitButton(context),

                        SizedBox(height: 20),
                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        )
    );
  }
}
