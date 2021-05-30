import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
