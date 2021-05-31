import 'package:balu_sto/screens/mobile/login/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeMobilePage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: ElevatedButton(
        child: Text("Выйти"),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginMobilePage.PAGE_NAME,
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
