import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({Key? key}) : super(key: key);

  @override
  _AddFirestoreDataState createState() => _AddFirestoreDataState();
}

final postController = TextEditingController();
bool loading = false;
final fireStore = FirebaseFirestore.instance.collection("users");

class _AddFirestoreDataState extends State<AddFirestoreData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Add firestore data"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "What is in your mind",
                  border: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.deepPurple, width: 2))),
            ),
            const SizedBox(height: 30),
            RoundButton(
                title: "Add",
                loading: loading,
                onPress: () {
                  setState(() {
                    loading = true;
                  });
                  //add post in firebase database

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    "title" : postController.text.toString(),
                    "id" : id,

                  }).then((value){
                    postController.clear();
                    Utils.showToastMessage("Data added");
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace){
                    Utils.showToastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });

                }),
          ],
        ),
      ),
    );
  }

}
