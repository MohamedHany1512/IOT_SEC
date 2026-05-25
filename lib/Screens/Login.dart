import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Screens/devices.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:graduationproject/model_dec/dec.dart';

class LoginPage extends StatefulWidget {
  LoginPage({ this.username});
  static String id = 'LoginPage';
  String? username;
  @override
  State<LoginPage> createState() => _LoginPageState();
}


TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
String? currentUser;
String? currentPassword;
int count = 0;
Decryption dec = Decryption();
late DatabaseReference referenceDatabase;

class _LoginPageState extends State<LoginPage> {
   GlobalKey<FormState> formKey = GlobalKey();
  void updateUi() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey[400],
        body: 
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [const Text('Hey,                  Welcome                          Back',style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold),),
                const SizedBox(height: 15,),
               
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(color: Colors.white))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: passwordController,
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(color: Colors.white))),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.grey[200]!),
                      
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        widget.username = emailController.text;
                        String password = passwordController.text;
              
                        try {
                          referenceDatabase = FirebaseDatabase.instance.ref();
              
                          // Fetch user data from Firebase based on entered username
                          DataSnapshot snapshot = await referenceDatabase.get();
              
                          // Check if the username exists in the database
                          currentUser = snapshot
                              .child('users')
                              .child(widget.username!)
                              .child('username')
                              .value as String?;
              
                          if (currentUser == null) {
                        
                            // Username does not exist in the database
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              title: 'User Not Found',
                              desc: 'The entered username does not exist.',
                              btnOkText: 'OK',
                               btnOkOnPress: () {
                              
                            },
                            ).show();
                          } else {
                            // Username exists, proceed to check password
                            currentPassword = snapshot
                                .child('users')
                                .child(widget.username!)
                                .child('password')
                                .value as String?;
                            currentPassword =
                                dec.decryption(currentPassword!).trim();
              
                            // Validate password
                            if (password == currentPassword!) {
                              // Password matches, navigate to DevicesScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DevicesScreen(
                                    username: widget.username,
                                    updateUi: updateUi,
                                  ),
                                ),
                              );
                                emailController.clear();
                                  passwordController.clear();
                            } else {
                              // Incorrect password
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: 'Invalid Password',
                                desc: 'The password you entered is incorrect.',
                                btnOkText: 'OK',
                                 btnOkOnPress: () {
                              
                            },
                              ).show();
                            }
                          }
                        } catch (e) {
                          // Error occurred during login or database access
                          print('Error: $e');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: 'Error',
                            desc: 'An error occurred during login.',
                            btnOkText: 'OK',
                            btnOkOnPress: () {
                              
                            },
                          ).show();
                        }
                      }
                    },
                  ),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
