import 'package:crudapp/UI/auth/login_with_phone.dart';
import 'package:crudapp/UI/auth/signup_screen.dart';
import 'package:crudapp/UI/posts/post_screen.dart';
import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

final _auth = FirebaseAuth.instance;
bool loading = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void userLogin() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
          Utils.showToastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen()));

    })
        .onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
          //automatically debug exception remove
          debugPrint(error.toString());
          Utils.showToastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text("Login"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
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
                          } else if (value.length < 6) {
                            return "Enter a digit large than 6 digits";
                          }

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
                  title: "Login",
                  loading: loading,
                  onPress: () {
                    print("hello");
                    if (_formKey.currentState!.validate()) {
                      userLogin();
                      emailController.clear();
                      passwordController.clear();
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                  },
                  child: const Text(
                    "Forget password",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
               InkWell(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber()));


                 },
                 child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.deepPurple,
                        width: 2
                      ),

                    ),
                    child: const Center(
                      child: Text("Login with phone"),
                    ),
                  ),
               ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
