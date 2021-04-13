import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Gif extends StatelessWidget {
  Map data;

  Gif(this.data); //Construtor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(data["title"]),
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(data["images"]["fixed_height"]["url"]);
                })
          ],
        ),
        body: Center(
          child: Image.network(data["images"]["fixed_height"]["url"]),
        ));
  }
}
