import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_app/screens/CreateNewWallet.dart';


class NoWalletYet extends StatefulWidget {
  @override
  _NoWalletYetState createState() => _NoWalletYetState();
}

class _NoWalletYetState extends State<NoWalletYet> {
  final storage = new FlutterSecureStorage();
  var  EwalletUser = 'Ewallet';
  @override
  void initState() {
    // TODO: implement initState
    getCurrentUsername();
    super.initState();
  }
  void getCurrentUsername() async{
    var username = await storage.read(key: 'name');
//    setState(() {
//      EwalletUser = username;
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child:  Column(
                children: [
                  Container(
                    height: 200,
                    child:  Image.asset('asset/images/wallet1.png', width: 350.0),
                  ),
                  SizedBox(height: 50,),
                  Text('Hi , you don\'t have a wallet yet',style: TextStyle(fontFamily: 'ubuntu',fontSize: 25),),
                  SizedBox(height: 40,),
                  RaisedButton(
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewWallet()));
                    },
                    child: const Text(
                      'Create now!',
                      style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'ubuntu'),
                    ),
                    color:  Color(0xffffac30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
