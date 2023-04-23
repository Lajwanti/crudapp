import 'package:crudapp/UI/auth/login_screen.dart';
import 'package:crudapp/UI/firestore/add_firestore_data.dart';
import 'package:crudapp/UI/posts/add_post.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  _FireStoreScreenState createState() => _FireStoreScreenState();
}

final auth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance.collection("users");
final searchFilterController = TextEditingController();
final editController = TextEditingController();
CollectionReference ref = FirebaseFirestore.instance.collection("users");


class _FireStoreScreenState extends State<FireStoreScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ref.onValue.listen((event) { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text("Data screen"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils.showToastMessage(error.toString());
              });
            },
            icon: const Icon(Icons.logout),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: const InputDecoration(
                  hintText: "Search", border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            //work real time database as stream builder
            child: StreamBuilder<QuerySnapshot>(
                stream: fireStore.snapshots() ,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child:  CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    );
                  }
                  else if(snapshot.hasError){
                    return const Text("Something went wrong");
                  }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,

                  itemBuilder: (context, index) {
                // if(searchFilterController.text.isEmpty){
                //   return  ListTile(
                //     title: Text(dataSnapshot.child("description").value.toString()),
                //     subtitle: Text(dataSnapshot.child("id").value.toString()),
                //     trailing: PopupMenuButton(
                //       icon: const Icon(Icons.more_vert),
                //       itemBuilder: (context)=>[
                //         PopupMenuItem(
                //
                //             child: ListTile(
                //               onTap:(){
                //                 Navigator.pop(context);
                //                 showMyDialog(title, dataSnapshot.child("id").value.toString());
                //               },
                //               trailing:  const Icon(Icons.edit),
                //               title: const Text("Edit"),
                //             )),
                //         PopupMenuItem(
                //             child: ListTile(
                //               onTap:(){
                //                 Navigator.pop(context);
                //                 ref.child(dataSnapshot.child("id").value.toString()).remove();
                //               },
                //               trailing: const Icon(Icons.delete),
                //               title: const Text("Delete"),
                //             )),
                //       ],
                //     ),
                //   );
                //
                // }
                // else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase().toString())){
                //   return  ListTile(
                //     title: Text(dataSnapshot.child("description").value.toString()),
                //     subtitle: Text(dataSnapshot.child("id").value.toString()),
                //   );
                // }
                // else{
                //   return Container();
                // }
                return ListTile(
                  title: Text(snapshot.data!.docs[index]["title"].toString()),
                  subtitle: Text(snapshot.data!.docs[index].id.toString()),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context)=>[
                      PopupMenuItem(

                          child: ListTile(
                            onTap:(){
                              Navigator.pop(context);
                              showMyDialog(snapshot.data!.docs[index].id.toString(),
                                  snapshot.data!.docs[index]["title"].toString()
                              );
                            },
                            trailing:  const Icon(Icons.edit),
                            title: const Text("Edit"),
                          )),
                      PopupMenuItem(
                          child: ListTile(
                            onTap:(){

                              Navigator.pop(context);
                              fireStore.doc(snapshot.data!.docs[index].id.toString()).delete();
                            },
                            trailing: const Icon(Icons.delete),
                            title: const Text("Delete"),
                          )),
                    ],

                  ),

                );
              });
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddFirestoreData()));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String id,String title) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            actions: [
              //cancel btn
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),

              //update btn
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                   fireStore.doc(id).update({
                   "title" : editController.text.toString(),
                   }).then((value){
                     Utils.showToastMessage("Data updated");
                   }).onError((error, stackTrace){
                     Utils.showToastMessage(error.toString());
                   });
                  },
                  child: Text("Update")),
            ],
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                    hintText: "Edit here", border: OutlineInputBorder()),
              ),
            ),
          );
        });
  }
}
