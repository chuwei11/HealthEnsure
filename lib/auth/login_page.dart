import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthensure/main_layout.dart';
import 'package:healthensure/auth/register_page.dart';
import 'package:healthensure/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import '../pages/Admin_home_page.dart';
import '../pages/agent_home_page.dart';
import '../utils/config.dart';
import 'forgot_pw_page.dart';
import '../pages/patient_screens/patient_main_layout.dart';
import 'package:healthensure/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthensure/main.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback showRegisterPage;
  // const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visible = false;
  bool _isObscure3 = false;

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Future signIn(String email, String password) async {
  //   await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim());
  // }

  // to manage the form state - using formKey to reference the form state & validate user input
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      // login success
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
        // user not found
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          // wrong password
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  //@override
  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('auth')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Admin(),
            ),
          );
        } else if (documentSnapshot.get('role') == "Patient") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatientMainLayout(),
              //Navigator.of(context).pushNamed('main');
            ),
          );
        } else if (documentSnapshot.get('role') == "Agent") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Agent(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.health_and_safety,
                        size: 180,
                      ),
                      SizedBox(height: 80),

                      // Hello again!
                      Text(
                        "Hello Again!",
                        style: GoogleFonts.bebasNeue(
                          fontSize: 50,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Welcome back, you\'ve been missed!',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      SizedBox(height: 50),

                      // email textFormField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_2),
                                  border: InputBorder.none,
                                  hintText: 'Email Address'),
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                      icon: Icon(_isObscure3
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure3 = !_isObscure3;
                                        });
                                      }),
                                  filled: true,
                                  enabled: true),
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "Password cannot be empty";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("please enter valid password min. 6 character");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _passwordController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Forgot Password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ForgotPasswordPage();
                                }));
                              },
                              child: Text('Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      // sign in button
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: GestureDetector(
                      //     onTap: signIn,
                      //     child: Container(
                      //       padding: const EdgeInsets.all(20),
                      //       decoration: BoxDecoration(
                      //           color: Colors.deepPurpleAccent,
                      //           borderRadius: BorderRadius.circular(12)),
                      //       child: Center(
                      //           child: Text('Sign In',
                      //               style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 18))),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 25),

                      // //sign in button
                      // MaterialButton(
                      //   color: Config.primaryColor,
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius:
                      //           BorderRadius.all(Radius.circular(20.0))),
                      //   elevation: 5.0,
                      //   height: 40,
                      //   onPressed: () {
                      //     setState(() {
                      //       visible = true;
                      //     });
                      //     signIn(
                      //         _emailController.text, _passwordController.text);
                      //     // if (_formKey.currentState!.validate()) {
                      //     //   try {
                      //     //     signIn(_emailController.text,
                      //     //         _passwordController.text);
                      //     //   } on FirebaseAuthException catch (e) {}
                      //     //   ;
                      //     //   ;
                      //     // }
                      //   },
                      //   child: Text(
                      //     "Login",
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //     ),
                      //   ),
                      // ),
                      // Config.smallSpacingBox,
                      // // Visibility(
                      // //     maintainSize: true,
                      // //     maintainAnimation: true,
                      // //     maintainState: true,
                      // //     visible: visible,
                      // //     child: Container(
                      // //         child: CircularProgressIndicator(
                      // //             color: Colors.white))),

                      //sign in button
                      Consumer<AuthModel>(builder: (context, auth, child) {
                        return MaterialButton(
                          color: Config.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          elevation: 5.0,
                          height: 40,
                          onPressed: () async {
                            final token = await DioProvider().getToken(
                                _emailController.text,
                                _passwordController.text);
                            if (token) {
                              //auth.loginSuccess(); //update login status
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final tokenValue = prefs.getString('token') ?? '';

                              if (tokenValue.isNotEmpty && tokenValue != '') {
                                //get user data
                                final response =
                                    await DioProvider().getUser(tokenValue);
                                if (response != null) {
                                  setState(() {
                                    //decode to json
                                    Map<String, dynamic> appointment = {};
                                    final user1 = json.decode(response);

                                    // check for today's appointment
                                    for (var doctorData in user1['doctor']) {
                                      // if today's appointment exists
                                      // retrieve the relevant doc info
                                      if (doctorData['appointments'] != null) {
                                        appointment = doctorData;
                                      }
                                    }

                                    auth.loginSuccess(user1, appointment);
                                  });
                                }
                              }
                              signIn(_emailController.text,
                                  _passwordController.text);
                            }
                            setState(() {
                              visible = true;
                            });
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        );
                      }),
                      Config.smallSpacingBox,

                      //Register if not a member
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Config.tinySpacingBox,
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()));
                            },
                            child: Text(
                                ' Sign Up and Connect With Doctor Nearby Now!',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                    ]),
              ),
            ),
          ),
        ));
  }
}
