import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            height: 120,
            width: 120,
            child: Image.asset('assets/logonew.png'),
          ),
        ],
      ),
    );
  }
}
