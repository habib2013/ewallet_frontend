import 'package:flutter/cupertino.dart';

Widget buildLoaderWidget(){
  return Container(
    child: Column(
      children: [
        CupertinoActivityIndicator()
      ],
    ),
  );
}