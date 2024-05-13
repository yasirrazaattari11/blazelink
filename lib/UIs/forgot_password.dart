import 'package:blaze_link/Utils/utils.dart';
import 'package:blaze_link/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
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
            SizedBox(height: 50,),
            RoundButton(title: 'Forgot', onTap: (){
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                Utils().toastMessage('Email Sent');
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }),
          ],
        ),
      ),
    );
  }
}
