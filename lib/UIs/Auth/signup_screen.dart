import 'package:blaze_link/UIs/Auth/login_screen.dart';
import 'package:blaze_link/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  bool flag = true;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  void signUp(){
    setState(() {
      loading = true;
    });
    _auth.createUserWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),).then((value){
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = true;
      });
      return Future.error(error.toString());
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/splash.png'),
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                'Sign Up',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.orange),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.none,
                    obscureText: false,
                    autofocus: false,
                    style: GoogleFonts.poppins(fontSize: 15),
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      prefixIcon: Icon(Icons.alternate_email),
                      prefixIconColor: Colors.grey,
                      hintText: 'Email',
                      hintStyle:
                          GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                      helperText: 'e.g john@gmail.com',
                      helperStyle:
                          GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.none,
                    obscureText: flag,
                    autofocus: false,
                    style: GoogleFonts.poppins(fontSize: 15),
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.2),
                      filled: true,
                      prefixIcon: Icon(Icons.lock_open),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.visibility_off),
                        onTap: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                      ),
                      suffixIconColor: Colors.grey,
                      prefixIconColor: Colors.grey,
                      label: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                          ),
                        ),
                      ),
                      labelStyle:
                          GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'Signup',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                 signUp();
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign In',
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
