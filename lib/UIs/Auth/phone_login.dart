import 'package:blaze_link/UIs/Auth/verification.dart';
import 'package:blaze_link/Utils/utils.dart';
import 'package:blaze_link/Widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool loading = false;
  final phoneNumbercontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          SizedBox(height: 80,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: phoneNumbercontroller,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.none,
              obscureText: false,
              autofocus: false,
              style: GoogleFonts.poppins(fontSize: 15),
              keyboardType: TextInputType.phone,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                prefixIcon: Icon(Icons.call),
                prefixIconColor: Colors.grey,
                hintText: 'Phone',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey),
                helperText: 'e.g +1 234 3455 234',
                helperStyle: GoogleFonts.poppins(
                    fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Phone Number';
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
              title: 'Login',
              onTap: (){
                setState(() {
                  loading = true;
                });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumbercontroller.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                  Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationScreen(verificationId: verificationId,),),);
                  setState(() {
                    loading = false;
                  });
                  },
                  codeAutoRetrievalTimeout: (e){
                    Utils().toastMessage(e.toString());
                    setState(() {
                      loading = false;
                    });
                  },);
            },),
          ),
        ],
      ),
    );
  }
}
