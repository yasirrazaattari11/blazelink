import 'package:blaze_link/UIs/Auth/phone_login.dart';
import 'package:blaze_link/UIs/Auth/signup_screen.dart';
import 'package:blaze_link/UIs/Posts/home_screen.dart';
import 'package:blaze_link/UIs/forgot_password.dart';
import 'package:blaze_link/Utils/utils.dart';
import 'package:blaze_link/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool flag = true;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
          Utils().toastMessage(value.user!.email.toString());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
          setState(() {
            loading = false;
          });
    })
        .onError((error, stackTrace) {
          debugPrint(error.toString());
      Utils().toastMessage(error.toString());
          setState(() {
            loading = false;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
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
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Login',
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
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey),
                        helperText: 'e.g john@gmail.com',
                        helperStyle: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.grey),
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
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 15, color: Colors.grey),
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
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
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
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange),
                    ),
                  ),
                ],
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneLogin()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.orange
                    )
                  ),
                  child: Center(child: Text('Login with Phone Number',style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.orange
                  ),),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
