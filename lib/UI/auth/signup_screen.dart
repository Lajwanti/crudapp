import 'package:crudapp/UI/auth/login_screen.dart';
import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

bool loading = false;
final emailController = TextEditingController();
final passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

FirebaseAuth _auth = FirebaseAuth.instance;

class _SignupScreenState extends State<SignupScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void userRegister() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {

      setState(() {
        loading = false;
      });
      Utils.showToastMessage("Registration Successful");
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils.showToastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Sign up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        helperText: "enter email e.g john@gmail.com",
                        prefix: Icon(
                          Icons.alternate_email,
                          size: 15,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter email";
                        } else if (!value.contains("@")) {
                          return "Enter @ in email";
                        } else if (!value.contains(".com")) {
                          return "Enter .com in email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      obscuringCharacter: "*",
                      decoration: const InputDecoration(
                        hintText: "Password",
                        prefix: Icon(
                          Icons.lock_outline,
                          size: 15,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        }
                        // else if(value.length < 6){
                        //   return "Enter a digit large than 6 digits";
                        // }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                title: "Sign up",
                loading: loading,
                onPress: () {
                  print("hello");
                  if (_formKey.currentState!.validate()) {
                    userRegister();
                  }
                  emailController.clear();
                  passwordController.clear();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
