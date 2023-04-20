import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthensure/models/auth_model.dart';
import 'package:healthensure/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:healthensure/components/button.dart';
import 'package:healthensure/main.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  // const RegisterPage({Key? key}) : super(key: key);

  // @override
  // State<RegisterPage> createState() => _RegisterPageState();
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState();

  bool showProgress = false;
  bool visible = false;

  RegExp pass_valid =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  bool validatePassword(String pass) {
    String _password = pass.trim();

    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  // for laravel signup
  final _nameController = TextEditingController();
  //final TextEditingController mobile = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;

  File? file;
  var options = [
    'Patient',
    'Admin',
    'Agent',
  ];
  var _currentItemSelected = "Patient";
  var role = "Patient";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Future signUp() async {
  //   if (passwordConfirmed()) {
  //     // create user
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );

  //     // add user details
  //     addUserDetails(
  //       _firstNameContoller.text.trim(),
  //       _lastNameController.text.trim(),
  //       _emailController.text.trim(),
  //       int.parse(_ageController.text.trim()),
  //     );
  //   }
  // }

  Future signUp(String email, String password, String role) async {
    passwordConfirmed() == false;
    CircularProgressIndicator();
    if (passwordConfirmed()) {
      if (_formkey.currentState!.validate()) {
        try {
          // create user
          await _auth
              .createUserWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim())
              .then((value) => {postDetailsToFirestore(email, role)})
              .catchError((e) {});

          // add user details
          await addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            int.parse(_ageController.text.trim()),
          );
        } on FirebaseAuthException catch (e) {
          print(e.message);
        }
      }
    }
  }

  postDetailsToFirestore(String email, String role) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('auth');
    ref.doc(user!.uid).set({
      'email': _emailController.text.trim(),
      'role': role,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future addUserDetails(
      String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  void showIncorrectPwdFormatDialog(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect password format'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showPwdNotMatchDialog(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Text('Please double check your password input'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                key: _formkey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Hello again!
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Welcome!",
                            style: GoogleFonts.bebasNeue(
                              fontSize: 50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Register below with your details',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      SizedBox(height: 50),

                      // first name textfield
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
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_2),
                                    border: InputBorder.none,
                                    hintText: 'First Name'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter first name";
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // last name textfield
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
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_2),
                                    border: InputBorder.none,
                                    hintText: 'Last Name'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter last name";
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // age textfield
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
                                controller: _ageController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person_2),
                                    border: InputBorder.none,
                                    hintText: 'Age'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter age";
                                  }
                                  return null;
                                }),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // email textfield
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
                                    prefixIcon: Icon(Icons.email),
                                    border: InputBorder.none,
                                    hintText: 'Email Address'),
                                validator: (value) {
                                  if (value!.length == 0) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                          // email validation
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
                                keyboardType: TextInputType.emailAddress),
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
                                obscureText: _isObscure,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        }),
                                    border: InputBorder.none,
                                    hintText: 'Password'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  } else {
                                    // call fx to check password
                                    bool result = validatePassword(value);
                                    if (result) {
                                      // create account event
                                      return null;
                                    } else {
                                      return "Password should contain at least 1 capital, small letter, number & special character and more than 8 characters";
                                    }
                                  }
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      // confirm password textfield
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
                                controller: _confirmPasswordController,
                                obscureText: _isObscure2,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscure2
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure2 = !_isObscure2;
                                          });
                                        }),
                                    border: InputBorder.none,
                                    hintText: 'Confirm Password'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (value != _passwordController.text) {
                                    // String message = "Password did not match";
                                    // // showPwdNotMatchDialog(message);
                                    // return message;
                                    return "Password did not match";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your Role : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          DropdownButton<String>(
                            dropdownColor: Colors.blueAccent,
                            isDense: true,
                            isExpanded: false,
                            iconEnabledColor: Colors.blueAccent,
                            focusColor: Colors.blueAccent,
                            items: options.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 5, 5, 5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              setState(() {
                                _currentItemSelected = newValueSelected!;
                                role = newValueSelected;
                              });
                            },
                            value: _currentItemSelected,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // sign up button
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      //   child: GestureDetector(
                      //     onTap: signUp,
                      //     child: Container(
                      //       padding: const EdgeInsets.all(20),
                      //       decoration: BoxDecoration(
                      //           color: Colors.deepPurpleAccent,
                      //           borderRadius: BorderRadius.circular(12)),
                      //       child: Center(
                      //           child: Text('Sign Up',
                      //               style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 18))),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 25),

                      //Login if member
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('I am a member?',
                      //         style: TextStyle(fontWeight: FontWeight.bold)),
                      //     GestureDetector(
                      //       onTap: widget.showLoginPage,
                      //       child: Text(' Login Now!',
                      //           style: TextStyle(
                      //               color: Colors.blue,
                      //               fontWeight: FontWeight.bold)),
                      //     ),
                      //   ],
                      // ),

                      // Sign Up button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            elevation: 5.0,
                            height: 40,
                            onPressed: () {
                              setState(() {
                                showProgress = true;
                              });
                              signUp(_emailController.text,
                                  _passwordController.text, role);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            color: Colors.deepPurpleAccent,
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      // Login Button
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       MaterialButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius:
                      //                 BorderRadius.all(Radius.circular(20.0))),
                      //         elevation: 5.0,
                      //         height: 40,
                      //         onPressed: () {
                      //           CircularProgressIndicator();
                      //           Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => LoginPage(),
                      //             ),
                      //           );
                      //         },
                      //         child: Text(
                      //           "Login",
                      //           style: TextStyle(
                      //             fontSize: 20,
                      //           ),
                      //         ),
                      //         color: Colors.deepPurpleAccent,
                      //       )
                      //     ]),

                      //Login if member
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('I am a member?',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          GestureDetector(
                            //onTap: widget.showLoginPage,
                            onTap: () {
                              CircularProgressIndicator();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(' Login Now!',
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
