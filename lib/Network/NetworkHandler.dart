import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHandler{
   String baseUrl = 'http://192.168.137.1:8000/api/';
    String bletyUrl = 'https://api.bleyt.com/v1/';
 // String baseUrl = 'http://127.0.0.1:8000/api/';

  final storage = new FlutterSecureStorage();
  SharedPreferences preferences;
  var log = Logger();

  Future<http.Response> get(String url) async{
    String token  = await storage.read(key: "token");
    url = formatter(url);
    var response = await http.get(url,headers: {"Authorization": "Bearer $token"}
    );
    return response;
  }


  Future<http.Response> post(String url,Map<String,String> body) async{
    url =  formatter(url);
//    Map<String,dynamic> output = json.decode(response.body);
    String token  = await storage.read(key: "token");
    var response = await http.post(url,
        headers: {"Content-type": "application/json","Authorization": "Bearer $token"},
        body: json.encode(body) );
    return response;
  }


//Bleyt URl
  Future<http.Response> getBleyt(String url) async{
    String merchantToken = 'sk_sandbox_VbYQ9ZixkTqhZaz1zRcX7yNsyfSUJMI9hI6uPO8nt6KiX4EF';
    url = bleytFormatter(url);
    var response = await http.get(url,headers: {"Authorization": "Bearer $merchantToken"}
    );
    return response;
  }


  Future<http.Response> postBleyt(String url,Map<String,String> body) async{
    url =  bleytFormatter(url);
//    Map<String,dynamic> output = json.decode(response.body);
    String merchantToken = 'sk_sandbox_VbYQ9ZixkTqhZaz1zRcX7yNsyfSUJMI9hI6uPO8nt6KiX4EF';
   
    var response = await http.post(url,
        headers: {"Content-type": "application/json","Authorization": "Bearer $merchantToken"},
        body: json.encode(body) );
    return response;
  }
//End bleyt URL



  Future<http.StreamedResponse> patchImage(String url,String filepath) async{
    url = formatter(url);
    String token  = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH',Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll(
        { "Content-type": "application/json",
          "Authorization": "Bearer $token"}
    );

    var response = request.send();
    return response;
  }

  String formatter(String url){
    return baseUrl + url;
  }
   String bleytFormatter(String url){
    return bletyUrl + url;
  }


}

