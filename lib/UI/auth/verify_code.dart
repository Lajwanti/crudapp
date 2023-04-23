import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {

  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
