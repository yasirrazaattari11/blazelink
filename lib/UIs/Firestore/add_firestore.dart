import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blaze_link/Utils/utils.dart';
import 'package:blaze_link/Widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AddFirstoreData extends StatefulWidget {
  const AddFirstoreData({super.key});

  @override
  State<AddFirstoreData> createState() => _AddFirstoreDataState();
}

class _AddFirstoreDataState extends State<AddFirstoreData> {
  bool loading = false;
  final postcontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firstore Data'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: postcontroller,
              textAlign: TextAlign.start,
              textInputAction: TextInputAction.none,
              obscureText: false,
              autofocus: false,
              style: GoogleFonts.poppins(fontSize: 15),
              keyboardType: TextInputType.text,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
                prefixIcon: Icon(Icons.face_2_outlined),
                prefixIconColor: Colors.grey,
                hintText: "What's on Your mind",
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 70,),
            RoundButton(
              loading: loading,
              title: 'Post',
              onTap: (){
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                firestore.doc(id).set({
                  'title':postcontroller.text.toString(),
                  'id': id
                }).then((value){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Post Added');
                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },),
          ],
        ),
      ),
    );
  }
}