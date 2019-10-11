import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offsset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if(_search == null) {
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=u39kzexBCeOqAnGzGmkFtvZKdRkEIteR&limit=25&rating=G");
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=u39kzexBCeOqAnGzGmkFtvZKdRkEIteR&q=$_search&limit=25&offset=$_offsset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    this._getGifs().then((map) {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui!",
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      )
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(snapshot.data["data"].length, (index) {
        return GestureDetector(
          child: Image.network(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"],
            height: 300,
            fit: BoxFit.cover
          ),
        );
      }),
    );
  }
}