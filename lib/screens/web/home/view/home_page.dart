import 'package:balu_sto/screens/web/login/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeWebPage extends StatelessWidget {
  static const PAGE_NAME = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        child: Text("Выйти"),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginWebPage.PAGE_NAME,
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
