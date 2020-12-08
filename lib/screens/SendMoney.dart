import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {

  @override
  void initState() {
    // TODO: implement initState
    generateSortCode();
    super.initState();
  }

  generateSortCode(){
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
//    print(next.toInt());
    var sortCode = next.toInt();
    _sortCodeController.text = sortCode.toString();
  }


  final _globalKey = GlobalKey<FormState>();

  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _sortCodeController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _accountNameController = TextEditingController();
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
          "amount": _amountController.text,
          "sortCode": _sortCodeController.text,
          "accountNumber": _accountNumberController.text,
          "accountName": _accountNameController.text
        };
        var response = await networkHandler.postBleyt("transfer/bank", data);
          if (response.statusCode == 200 || response.statusCode == 201) {

            var customerID = await storage.read(key: 'customerID');

            Map<String,String> Debitdata = {
              "amount": _amountController.text,
              "reference": 'tkhgnfjdn562tripe',
              "customerId": customerID,

            };

            var Walleresponse = await networkHandler.postBleyt("wallet/debit", Debitdata);
              if (Walleresponse.statusCode == 200 || Walleresponse.statusCode == 201) {
                final snackBar = SnackBar(content: Text('Transfer successful'));
                Scaffold.of(context).showSnackBar(snackBar);
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
          'Transfer ',
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
        _entryField(_amountController, "Amount"),
        _entryField(_sortCodeController, "Sortcode"),
        _entryField(_accountNumberController, "Account Number"),
        _entryField(_accountNameController, "Account Name"),
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
        Text("Transfer To bank🔥", style: TextStyle(
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
    return
      Scaffold(
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
