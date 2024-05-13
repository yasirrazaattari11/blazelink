import 'package:blaze_link/UIs/Firestore/add_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utils/utils.dart';
import '../Auth/login_screen.dart';
import '../Posts/add_post.dart';
class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({super.key});

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final _auth = FirebaseAuth.instance;
  final editcontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Screen'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(onPressed: (){
            _auth.signOut().then((value){
              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10,)
        ],),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFirstoreData()),);
      },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            SizedBox(height: 30,),
            StreamBuilder<QuerySnapshot>(stream: firestore, builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              if(snapshot.hasError){
                return Text('Some Error');
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      onTap: (){
                        ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                          'title':'Yasir Raza'
                        }).then((value) => {
                          Utils().toastMessage('updated')
                        }).onError((error, stackTrace)=>{
                          Utils().toastMessage(error.toString())
                        });
                      },
                      title: Text(snapshot.data!.docs[index]['title'].toString()),
                      subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                    );
                  },),
              );
            }),

          ],
        ),
      ),
    );
  }
  Future<void> showMyDialog(String title, String id)async{
    editcontroller.text = title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextFormField(
                controller: editcontroller,
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
                  prefixIcon: Icon(Icons.edit),
                  prefixIconColor: Colors.grey,
                  hintText: 'Edit Post',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 15, color: Colors.grey),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),
              TextButton(onPressed: (){
              }, child: Text('Update'))
            ],
          );
        });
  }
}
