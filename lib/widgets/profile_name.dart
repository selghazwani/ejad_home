import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileName extends StatelessWidget {
  @override
  Future getReq() async {
    var url = Uri.parse('https://ejad-home.ly/readUser.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: getReq(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List list = snapshot.data;
                  return GestureDetector(
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Card(
                              margin: EdgeInsets.all(25),
                              child: Column(children: [
                                ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                list[index]['first_name'] ?? '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      ],
                                    ),
                                  ),
                                ),
                              ]))));
                })
            : CircularProgressIndicator();
      },
    ));
  }
}
