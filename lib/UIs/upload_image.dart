import 'dart:io';

import 'package:blaze_link/Utils/utils.dart';
import 'package:blaze_link/Widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage ref = firebase_storage.FirebaseStorage.instance;
  DatabaseReference database = FirebaseDatabase.instance.ref('Post');
  Future getImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('Nothing Selected');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color:Colors.black)
                  ),
                  child: Center(child: _image != null ? Image.file(_image!.absolute):Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Upload', loading: loading,onTap: ()async{
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/'+DateTime.now().millisecondsSinceEpoch.toString());
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
              Future.value(uploadTask).then((value) async {
                var newUrl =await ref.getDownloadURL();
                database.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
                  'id': DateTime.now().millisecondsSinceEpoch,
                  'title':newUrl.toString(),

                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Uploaded');
                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });


            })
          ],
        ),
      ),
    );
  }
}
