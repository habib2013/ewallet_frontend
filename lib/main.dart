import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_app/TestOnboard.dart';
import 'package:wallet_app/screens/HomePage.dart';
import 'package:wallet_app/screens/HomeWithSidebar.dart';
import 'package:wallet_app/screens/LoginPage.dart';
import 'package:wallet_app/screens/SignupPage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeWithSidebar(),

    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('asset/images/sideImg.png'),
                    fit: BoxFit.cover
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.7,
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("06:22 AM", style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'avenir',
                        fontWeight: FontWeight.w500
                    ),),
                    Expanded(
                      child: Container(),
                    ),

                    SizedBox(width: 5,),

                  ],
                ),
                Text("Aug 1, 2020 | Wednesday", style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('asset/images/logo.png'),
                                  fit: BoxFit.contain
                              )
                          ),
                        ),
                        Text("eWallet", style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'ubuntu',
                            fontWeight: FontWeight.w600
                        ),),
                        SizedBox(height: 10,),
                        Text("Open An Account For \nDigital E-Wallet Solutions. \nInstant Payouts.", style: TextStyle(
                            color: Colors.black45,
                        ),)
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: openLogin,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xffffac30),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Go to Login", style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,fontFamily: 'ubuntu'
                          ),),
                          SizedBox(width: 4,),
                          Icon(Icons.arrow_forward, size: 22,)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                    },
                    child: Text("Create an account", style: TextStyle(
                        fontSize: 16,fontFamily: 'ubuntu'
                    ),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  void openHomePage()
  {
//  Navigator.pushNamed(context, '/homePage');
  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWithSidebar()));
  }
  void openLogin()
  {
//  Navigator.pushNamed(context, '/homePage');
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget page = MyHomePage();
  final storage = new FlutterSecureStorage();
  @override
  void initState(){
    super.initState();
    checkLogin();
    Timer(Duration(seconds: 4), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page)));

  }
  void checkLogin() async {
    SharedPreferences preferences;
    var token  = await storage.read(key: "token");
    // print('token is ${token}');
//    String token = await preferences.get("token");

    if (token != null) {
      setState(() {
        page = HomeWithSidebar();
      });
    }
    else {
//      page =  WelcomePage();
      setState(() {
//        page = TestOnboard();
        displayOnboarding() async {
          preferences = await SharedPreferences.getInstance();
          bool onboardingVisibilityStats = preferences.getBool("ShowOnboardingPageTest");
          if (onboardingVisibilityStats == null) {
            page =  TestOnboard();
            preferences.setBool("ShowOnboardingPageTest", false);
            return true;
          }
          else {
            page =  MyHomePage();
            return false;
          }

        }
//        displayOnboarding().then((status) {
//            page =  WelcomePage();
//
//        });
        displayOnboarding();
      });
    }
  }
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white54,])
        ),
        child: Center(
          child: Column(
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
          ),

        ),
      ),
    );
  }
}
