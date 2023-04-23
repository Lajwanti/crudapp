import 'package:crudapp/UI/auth/login_screen.dart';
import 'package:crudapp/UI/posts/add_post.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

final auth = FirebaseAuth.instance;
final ref = FirebaseDatabase.instance.ref("Post");
final searchFilterController = TextEditingController();
final editController = TextEditingController();


class _PostScreenState extends State<PostScreen> {

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
        title: const Text("Post screen"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){

            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));

            }).onError((error, stackTrace){
              Utils.showToastMessage(error.toString());

            });

          }, icon: const Icon(Icons.logout),),
          SizedBox(width: 5,)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: searchFilterController,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {


                });
              },
            ),
          ),
          // Expanded(child: StreamBuilder(
          //   stream: ref.onValue,
          //   builder: (context, AsyncSnapshot<DatabaseEvent>snapshot) {
          //
          //     Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
          //     List<dynamic> list = [];
          //     list.clear();
          //     list = map.values.toList();
          //
          //     if(!snapshot.hasData){
          //       return Center(child: CircularProgressIndicator(color: Colors.deepPurple,));
          //
          //     }else{
          //       return  ListView.builder(
          //           itemCount: snapshot.data!.snapshot.children.length,
          //           itemBuilder: (context, index) {
          //             return Card(
          //               child: ListTile(
          //                 title: Text(list[index]["description"]),
          //                 subtitle: Text(list[index]["id"]),
          //               ),
          //             );
          //
          //           });
          //     }
          //
          //
          //   }),
          // ),
          Expanded(
            //work real time database as stream builder
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text("Loading"),
                itemBuilder: (context, dataSnapshot , animation , index){
                  final title = dataSnapshot.child("description").value.toString();

                  if(searchFilterController.text.isEmpty){
                    return  ListTile(
                      title: Text(dataSnapshot.child("description").value.toString()),
                      subtitle: Text(dataSnapshot.child("id").value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context)=>[
                          PopupMenuItem(

                              child: ListTile(
                                onTap:(){
                                  Navigator.pop(context);
                                  showMyDialog(title, dataSnapshot.child("id").value.toString());
                                },
                              trailing:  const Icon(Icons.edit),
                                title: const Text("Edit"),
                              )),
                          PopupMenuItem(
                              child: ListTile(
                                onTap:(){
                                  Navigator.pop(context);
                                  ref.child(dataSnapshot.child("id").value.toString()).remove();
                                },
                              trailing: const Icon(Icons.delete),
                                title: const Text("Delete"),
                              )),
                        ],
                      ),
                    );

                  }
                  else if(title.toLowerCase().contains(searchFilterController.text.toLowerCase().toString())){
                    return  ListTile(
                      title: Text(dataSnapshot.child("description").value.toString()),
                      subtitle: Text(dataSnapshot.child("id").value.toString()),
                    );
                  }
                  else{
                    return Container();
                  }

                }

            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddPost()));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {

    editController.text = title;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            actions: [
              //cancel btn
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),

              //update btn
              TextButton(onPressed: (){
                Navigator.pop(context);
                ref.child(id).update({
                  "description" : editController.text.toString(),
                }).then((value) {
                  Utils.showToastMessage("Data updated");
                }).onError((error, stackTrace) {
                  Utils.showToastMessage(error.toString());
                });
              }, child: Text("Update")),
            ],
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(
                  hintText: "Edit here",
                  border: OutlineInputBorder()
                ),
              ),
            ),
          );
        });
  }

}
