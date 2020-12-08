import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';

class CreateNewWallet extends StatefulWidget {
  @override
  _CreateNewWalletState createState() => _CreateNewWalletState();
}

class _CreateNewWalletState extends State<CreateNewWallet> {

  @override
  void initState() {
    // TODO: implement initState
//    generateSortCode();
    super.initState();
  }

//  generateSortCode(){
//    var rnd = new Random();
//    var next = rnd.nextDouble() * 1000000;
//    while (next < 100000) {
//      next *= 10;
//    }
////    print(next.toInt());
//    var sortCode = next.toInt();
//    _sortCodeController.text = sortCode.toString();
//  }


  final _globalKey = GlobalKey<FormState>();

  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dateOfBirthrController = TextEditingController();
  TextEditingController _bvnrController = TextEditingController();
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
                FeatherIcons.arrowLeftCircle, color: Colors.black, size: 35,),
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
              readOnly: title == 'Sortcode' ? true: false,
              controller: editController,
              keyboardType: (title == 'Amount' || title == 'Sortcode' || title == 'Account Number') ? TextInputType.number : TextInputType.text,
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

  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        Map<String, String> data = {
          "firstName": _firstNameController.text,
          "lastName": _lastNameController.text,
          "email": _emailController.text,
          "phoneNumber": _phoneNumberController.text,
          "dateOfBirth": _dateOfBirthrController.text,
          "bvn": _bvnrController.text
        };
        var response = await networkHandler.postBleyt("wallet", data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map output = json.decode(response.body);
          print("User wallet is ${output['customer']['id']}");

            var customerID = output['customer']['id'];

            await storage.write(key: customerID, value: customerID);

            var userID = await storage.read(key: 'userID');
          Map<String, String> data = {
            "userID": userID,
            "bleyt_id": customerID,

          };
          var saveResponseToDB = await networkHandler.post("saveToHasWallet", data);
          if (saveResponseToDB.statusCode == 200 || saveResponseToDB.statusCode == 201) {
            print('Successfully Created');
            Navigator.pop(context);
          }  
        }

        print('Money Sent');
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
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
        child:Text(
          'Create Wallet ',
          style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'ubuntu'),
        ),

      ),
    );
  }

  Widget _formFieldWidget() {
    return Column(
      children: <Widget>[
        _entryField(_firstNameController, "First Name"),
        _entryField(_lastNameController, "Last Name"),
        _entryField(_emailController, "Email"),
        _entryField(_phoneNumberController, "Phone Number"),
        _entryField(_dateOfBirthrController, "Date Of Birth"),
        _entryField(_bvnrController, "BVN"),
      ],
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
                  fit: BoxFit.contain
              )
          ),
        ),
        Text("Create a new wallet ", style: TextStyle(
            fontSize: 30,
            fontFamily: 'ubuntu',
            fontWeight: FontWeight.w600
        ),),
        SizedBox(height: 10,),

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
            children: [
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          children: [
                            SizedBox(height: height * .12),
                            _title(),
                            SizedBox(height: 50),
                            _formFieldWidget(),
                            SizedBox(height: 20),
                            _submitButton(context),
                          ],
                        ),
                      )
                  )
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        )
    );
  }
}
