import 'package:crudapp/UI/auth/verify_code.dart';
import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneNumberState createState() => _LoginWithPhoneNumberState();
}

final phoneNumberController = TextEditingController();
bool loading = false;
final auth = FirebaseAuth.instance;

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration:const InputDecoration(
                  hintText: "Phone number",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.deepPurple
                      )
                  )
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(title: "Login",
                loading: loading,
                onPress: (){
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });

                  },
                  verificationFailed: (e){
                  Utils.showToastMessage(e.toString());
                  },
                  codeSent: (String verificationId ,int? token){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                    setState(() {
                      loading = false;
                    });

                  },
                  codeAutoRetrievalTimeout: (e){

                    Utils.showToastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },
              );
            })

          ],
        ),
      ),
    );
  }
}
