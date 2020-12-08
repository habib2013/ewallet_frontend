import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';
import 'package:wallet_app/screens/SendMoney.dart';
import 'package:wallet_app/screens/TransactionPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final storage = new FlutterSecureStorage();
  var bookedbalance = 0;
  TextEditingController _amountController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    getAcustomer();
    super.initState();
  }

  void getAcustomer() async {
    NetworkHandler networkHandler = NetworkHandler();
    //  var response = await networkHandler.get('user/checkusername/${_usernameEditingController.text}');
    var customerID = await storage.read(key: 'customerID');
    print("customer ID is ${customerID}");
    var response = await networkHandler
        .getBleyt('wallet/customer?customerId=${customerID}');
    //  if (response.statusCode == 200 || response.statusCode == 201) {
    Map output = json.decode(response.body);
    print("User wallet is ${output['wallet']['bookedBalance']}");
    setState(() {
      bookedbalance = output['wallet']['bookedBalance'];
    });

    //  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('asset/images/logo.png'),
                      )),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "eWallet",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'ubuntu',
                          fontSize: 25),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Account Overview",
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'avenir'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₦ ${bookedbalance}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Current Balance",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) => bottomSheet());
//                      showModalBottomSheet(context: null, builder: null)
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffffac30)),
                      child: Icon(
                        FeatherIcons.plus,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Features",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'avenir'),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/scanqr.png'))),
                )
              ],
            ),
            Container(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoney()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffffac30),
                            ),
                            child: Icon(
                              FeatherIcons.send,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Center(child: Text('Send Money',style: TextStyle(color: Colors.black,fontFamily: 'ubuntu',fontSize: 18),)),
                        ],
                      ),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffffac30),
                            ),
                            child: Icon(
                              FeatherIcons.calendar,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Center(child: Text('History',style: TextStyle(color: Colors.black,fontFamily: 'ubuntu',fontSize: 18),)),
                        ],
                      ),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionPage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffffac30),
                            ),
                            child: Icon(
                              FeatherIcons.key,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Center(child: Text('Change PIN',style: TextStyle(color: Colors.black,fontFamily: 'ubuntu',fontSize: 18),)),
                        ],
                      ),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

          ],
        ),
      ),
    );
  }

  Column serviceWidget(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/$img.png'))),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Container avatarWidget(String img, String name) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      height: 90,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                  image: AssetImage('asset/images/$img.png'),
                  fit: BoxFit.contain),
            ),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'avenir',
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Widget _entryField(
    var editController,
    String title,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width / 3,
      child: Column(
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
              keyboardType: (title == 'Amount')
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                  hintText: title,
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

  Widget _formFieldWidget() {
    return Column(
      children: <Widget>[
        _entryField(_amountController, "Amount"),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        var customerID = await storage.read(key: 'customerID');
        Map<String, String> data = {
          "amount": _amountController.text,
          "reference": "tkhgnfjdn562jjs",
          "customerId": customerID,
        };
        var response = await networkHandler.postBleyt("wallet/credit", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
        } else {
          print('send failed');
        }

        print('Money Sent');
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
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
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xffffac30),
                  Color(0xffffac30),
                ])),
        child: Icon(
          FeatherIcons.send,
          size: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 900.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
      child: Column(
        children: [
          Text(
            'Fund wallet',
            style: TextStyle(
                color: Colors.black, fontSize: 15.0, fontFamily: 'ubuntu'),
          ),
          SizedBox(
            height: 4.0,
          ),
          Stack(
            children: [
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                      child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _formFieldWidget(),
                            SizedBox(width: 12),
                            _submitButton(context),
                          ],
                        )
                      ],
                    ),
                  ))),
            ],
          ),
        ],
      ),
    );
  }
}
