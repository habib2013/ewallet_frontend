import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallet_app/Network/NetworkHandler.dart';
import 'package:wallet_app/bloc/getTransacationsBloc.dart';
import 'package:wallet_app/elements/loader_element.dart';
import 'package:wallet_app/models/transaction_history.dart';
import 'package:wallet_app/models/transaction_history_source.dart';
import 'package:wallet_app/screens/PdfPreviewScreen.dart';
import 'package:wallet_app/screens/SendMoney.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:wallet_app/screens/pdfDownloadHandler.dart';

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

  final pdf = pw.Document();

  writeToPdf(){
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context){
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text('Test Hello world'),

            ),
            pw.Paragraph(
              text:'Next.js is a JavaScript framework created by Zeit. It lets you build server-side rendering and static web applications using React. Its a great tool to build your next website. It has many great features and advantages, which can make Nextjs your first option for building your next web application.',
            ),
            pw.Paragraph(
              text:'Next.js is a JavaScript framework created by Zeit. It lets you build server-side rendering and static web applications using React. Its a great tool to build your next website. It has many great features and advantages, which can make Nextjs your first option for building your next web application.',
            ),
            pw.Paragraph(
              text:'Next.js is a JavaScript framework created by Zeit. It lets you build server-side rendering and static web applications using React. Its a great tool to build your next website. It has many great features and advantages, which can make Nextjs your first option for building your next web application.',
            ),
            pw.Header(
              level: 1,
              child: pw.Text('this is a sub test'),
            ),
            pw.Paragraph(
              text:'Next.js is a JavaScript framework created by Zeit. It lets you build server-side rendering and static web applications using React. Its a great tool to build your next website. It has many great features and advantages, which can make Nextjs your first option for building your next web application.',
            ),
          ];
      }
      )
    );
  }

  Future savePdf() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }


  final storage = new FlutterSecureStorage();
  var bookedbalance = 0;
  TextEditingController _amountController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    getTransactionsBloc..getTransactions('c46a7836-5762-45ee-98b1-0e63359a22f0');
    getAcustomer();
    super.initState();
  }

  Future<void> _TransactionDetails(String description,String category,String source,) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(description,style: TextStyle(fontFamily: 'ubuntu',fontSize: 13,color: Colors.black),),
              SizedBox(width: 2,),
              IconButton(icon: Icon(FeatherIcons.download),onPressed: null,)
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(category),
                Text(source),
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Exit!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  void sendMoney() async{
//    print('Money Sent');
    var customerID = await storage.read(key: 'customerID');
    Map<String, String> data = {
      "amount": _amountController.text,
      "reference": "tkhgnfjdn562jjq",
      "customerId": customerID,
    };
    var response = await networkHandler.postBleyt("wallet/credit", data);
    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      print('send failed');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
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
                  "Send Money",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'avenir'),
                ),
                Container(
                  height: 45,
                  width: 45,
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfDownloader()));
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffffac30),
                        ),
                        child: Icon(
                          FeatherIcons.plus,
                          size: 40,
                        ),
                      ),
                    ),
                    avatarWidget("img1", "Anna"),
                    avatarWidget("img2", "Judith"),
                    avatarWidget("img3", "Gillian"),
                    avatarWidget("img4", "John"),
                    avatarWidget("img10", "Annie"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transaction History",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'avenir'),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/images/tag.png'))),
                )
              ],
            ),

            SizedBox(height: 20,),
            Column(

              children: <Widget>[
                NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: StreamBuilder<TransactionResponse>(
                    stream: getTransactionsBloc.subject.stream,
                    builder: (context, AsyncSnapshot<TransactionResponse> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.error != null &&
                            snapshot.data.error.length > 0) {
                          return Container(
                            child: Text('this is an error1'),
                          );
                        }
                        return TransactionsList(snapshot.data);
                        // return Text('there is data here');
                      } else if (snapshot.hasError) {
                        return Container(child: Text('this is an error2'),);
                      } else {
                        return buildLoaderWidget();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
      writeToPdf();
      await savePdf();

      Directory documentDirectory = await getApplicationDocumentsDirectory();

      String documentPath = documentDirectory.path;

      String fullPath = "$documentPath/example.pdf";

      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PdfPreviewScreen(path: fullPath,)
      ));

    },
    child: Icon(Icons.save),
    ), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }


  Widget TransactionsList(TransactionResponse data){
    List<TransactionHistoryModel> transactions = data.transactions;
    if (transactions.length == 0 ) {
      return Container(
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No transaction history",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    }
    else {
      return ListView.separated(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Divider(),
          );
        },
        padding: EdgeInsets.zero,
        itemCount:  transactions.length,
        itemBuilder: (BuildContext context, int index) {
         return ListTile(
            dense: true,
            trailing: Text(
              " \₦ ${transactions[index].amount}",
              style: TextStyle(
                  inherit: true, fontWeight: FontWeight.bold, fontSize: 13.0,  color: transactions[index].Transactiontype == 'DEBIT' ? Colors.red : Colors.green),
            ),

            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  transactions[index].description,
                  style: TextStyle(
                      inherit: true, fontWeight: FontWeight.bold, fontSize: 14.0,color: transactions[index].Transactiontype == 'DEBIT' ? Colors.red : Colors.green,fontFamily: 'ubuntu'),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(timeAgo(DateTime.parse(transactions[index].createdAt),),
                      style: TextStyle(
                          inherit: true, fontSize: 11.0, color: Colors.green)),
                  SizedBox(
                    width: 20,
                  ),
                  Text(transactions[index].Transactiontype,
                      style: TextStyle(
                          inherit: true, fontSize: 11.0, color:  Colors.black)),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(icon: transactions[index].category == 'WALLET_DEBITED_BY_MERCHANT' ? Icon(FeatherIcons.trendingDown,color: Colors.black45,) : Icon(FeatherIcons.trendingUp,color: Colors.green,) , onPressed: (){
                    print('preseed');
                  }),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(icon: Icon(Icons.picture_as_pdf_outlined,color: Colors.black45,), onPressed: (){
                    _TransactionDetails(transactions[index].description,transactions[index].category,transactions[index].source);
                  }),

                  Spacer(),
                ],
              ),
            ),
          );
          // return Text('All Trans');
        },
      );
    }


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
      height: 200,
      width: 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xfff1f3f6)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage('asset/images/$img.jpg'),
                    fit: BoxFit.contain
                ),
                border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                )
            ),
          ),
          Text(name, style: TextStyle(
              fontSize: 16,
              fontFamily: 'ubuntu',
              fontWeight: FontWeight.w700
          ),)
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
      width: MediaQuery.of(context).size.width ,
      padding: EdgeInsets.all(4),
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
                  suffixIcon: IconButton(icon: Icon(FeatherIcons.send,color: Colors.orange,size: 30,), onPressed: (){
                    sendMoney();
                  }),
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
                            _formFieldWidget(),
//                        SizedBox(width: 12),
//                        _submitButton(context)
                          ],
                        ),
                      ))),
            ],
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date){
    return timeago.format(date,allowFromNow: true,locale: 'en');
  }
}
