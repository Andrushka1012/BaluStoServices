import 'package:balu_sto/helpers/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final _emailTextController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _emailTextController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Емейл', hintText: 'example@gmail.ua'),
          enableSuggestions: false,
          autocorrect: false,
        ),
        ElevatedButton(
          onPressed: () => _resetPassword(context),
          child: Text('Отправить ссылку сброса'),
        )
      ],
    );
  }

  void _resetPassword(BuildContext context) async {
    try {
      if (_emailTextController.text.isValidEmail) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailTextController.text);
        Navigator.of(context).pop();
      } else {
        // TODO: handle errors
      }
    } catch (e) {
      print(e);
      // TODO: handle errors
    }
  }
}
