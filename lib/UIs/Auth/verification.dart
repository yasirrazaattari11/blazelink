import 'package:blaze_link/UIs/Posts/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/utils.dart';
import '../../Widgets/round_button.dart';
class VerificationScreen extends StatefulWidget {
  final String verificationId;
   VerificationScreen({required this.verificationId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool loading = false;
  final verificationcodecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: verificationcodecontroller,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.none,
              obscureText: false,
              autofocus: false,
              style: GoogleFonts.poppins(fontSize: 15),
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                hintText: 'Sent Code',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Verification Code';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
              loading: loading,
              title: 'Verify',
              onTap: ()async {
                setState(() {
                  loading = true;
                });
                final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationcodecontroller.text.toString(),
                );
                try{
                  await auth.signInWithCredential(credentials);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()),);
                }catch(e){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              },),
          ),
        ],
      ),
    );
  }
}

