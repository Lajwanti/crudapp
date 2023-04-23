import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

final postController = TextEditingController();
bool loading = false;

//create table in sql form
//create node in firebase database form
final databaseRef = FirebaseDatabase.instance.ref("Post");

class _AddPostState extends State<AddPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Add Post"),
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

                  databaseRef.child(id).set({
                    "id": id,
                    "description": postController.text.toString(),
                  }).then((value) {
                    postController.text = "";
                    Utils.showToastMessage("Post added");
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
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
