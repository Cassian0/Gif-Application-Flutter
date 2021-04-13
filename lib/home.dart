import 'package:another_app/pagegif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int index = 0;

  Future<Map> _getData() async {
    http.Response response;
    if (_search.isEmpty || _search == null) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=SPo5deIGElyI4wEplvMgQQ9YOwk8LoH4&limit=20&rating=g");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=SPo5deIGElyI4wEplvMgQQ9YOwk8LoH4&q=$_search&limit=20&offset=$index&rating=g&lang=en");
    }
      return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getData(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Container(
                            color: Colors.white,
                          );
                        }
                        return MyGrid(context, snapshot);
                    }
                  })),
        ],
      ),
    );
  }

  Widget MyGrid(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            Share.share(
                snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Gif(snapshot.data["data"][index])));
          },
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
