import 'package:flutter/material.dart';


class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Text Wrapping Example")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This is a very long text that should wrap to the next line instead of overflowing off the screen. Let's see how Flutter handles it.",
                style: TextStyle(fontSize: 18),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 20),
              Text(
                "This is another long text but with an ellipsis (...) when it overflows.",
                style: TextStyle(fontSize: 18),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
