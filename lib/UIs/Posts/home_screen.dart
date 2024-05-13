import 'package:blaze_link/UIs/Auth/login_screen.dart';
import 'package:blaze_link/UIs/Posts/add_post.dart';
import 'package:blaze_link/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchfilter = TextEditingController();
  final editcontroller = TextEditingController();
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()),);
      },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              controller: searchfilter,
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
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.grey,
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 15, color: Colors.grey),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
            SizedBox(height: 30,),
            Expanded(
              child: FirebaseAnimatedList(
                  query: ref,
                  defaultChild: Text('Loading..'),
                  itemBuilder: (context,snapshot,animation,index){
                    final title =snapshot.child('title').value.toString();
                    if(searchfilter.text.isEmpty){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString(),),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        hoverColor: Colors.grey,
                        tileColor: Colors.orange,
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context)=>[
                            PopupMenuItem(
                              value: 1,
                                child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    showMyDialog(title,snapshot.child('id').value.toString());
                                  },
                            ),),
                            PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('Delete'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                                ))
                          ],
                        ),
                      );
                    }else if(title.toLowerCase().contains(searchfilter.text.toLowerCase().toString())){
                      return ListTile(
                        title: Text(snapshot.child('title').value.toString(),),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        hoverColor: Colors.grey,
                        tileColor: Colors.orange,
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (context)=>[
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                                onTap: (){
                                  Navigator.pop(context);
                                  showMyDialog(title,snapshot.child('id').value.toString());
                                },
                              ),),
                            PopupMenuItem(
                                value: 2,
                                child: ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('Delete'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.child(snapshot.child('id').value.toString()).remove();
                                  },
                                ),)
                          ],
                        ),
                      );
                    }else{
                      return Container();
                    }

                  }),
            ),
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
                Navigator.pop(context);
                ref.child(id).update({
                  'title': editcontroller.text.toLowerCase()
                }).then((value){
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }, child: Text('Update'))
            ],
          );
        });
  }
}
/*Expanded(child: StreamBuilder(
stream: ref.onValue,
builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
if(!snapshot.hasData){
return CircularProgressIndicator();
}else{
Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
List<dynamic> list = [];
list.clear();
list = map.values.toList();
return ListView.builder(
itemCount: snapshot.data!.snapshot.children.length,
itemBuilder: (context,index){
return ListTile(
title: Text(list[index]['title']),
subtitle: Text(list[index]['id']),
hoverColor: Colors.grey,
tileColor: Colors.orange,
);
} );
}

},
)),*/
