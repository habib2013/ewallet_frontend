import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class PdfDownloader extends StatefulWidget {
  @override
  _PdfDownloaderState createState() => _PdfDownloaderState();
}

class _PdfDownloaderState extends State<PdfDownloader> {
  final pdfUrl = 'http://pdf995.com/samples/pdf.pdf';
  var dio = Dio();

  @override
  void initState() {
    // TODO: implement initState
    getPermission();
    super.initState();
  }

  void getPermission() async {
    print('getPermission');
 await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  Future download2(Dio dio, String url, String savePath) async {
    //get pdf from link
    Response response = await dio.get(
      url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );

    //write in download folder
    File file = File(savePath);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
  }

  void showDownloadProgress(received,total){
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pDF Download '),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('Hello'),
              onPressed: () async {
                String path =
                    await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_DOWNLOADS);

                String fullpath = '$path/newtask1.pdf';
                download2(dio,pdfUrl,fullpath);
              },

            )
          ],
      ),
    );
  }
}
