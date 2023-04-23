import 'dart:io';

import 'package:crudapp/Widgets/round_button.dart';
import 'package:crudapp/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

File? _image;
bool loading = false;
final picker = ImagePicker();
firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
final databaseRef = FirebaseDatabase.instance.ref("Post");



class _UploadImageState extends State<UploadImage> {

  Future getGalleryImage() async{

    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

   setState(() {
     if(pickedFile != null){
       _image = File(pickedFile.path);

     }else{
       print("no image picked");
     }

   });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload image"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: InkWell(
              onTap: (){
                getGalleryImage();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: _image != null ? Image.file(_image!.absolute)  :Center(child: Icon(Icons.image),)
              ),
            ),
          ),
          const SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundButton(title: "Upload", loading: loading, onPress: ()async{
              setState(() {
                loading = true;
              });

              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
                  .ref("/foldername/"+DateTime.now().millisecondsSinceEpoch.toString());
              firebase_storage.UploadTask  uploadTask = ref.putFile(_image!.absolute);

              Future.value(uploadTask).then((value)async{
                var url = await ref.getDownloadURL();

                databaseRef.child("1").set({
                  "id" : "123",
                  "title" : url.toString(),
                }).then((value){
                  setState(() {
                    loading = false;
                  });

                  Utils.showToastMessage("Uploaded");

                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });

                  Utils.showToastMessage(error.toString());

                });




              }).onError((error, stackTrace){
                setState(() {
                  loading = false;
                });

                Utils.showToastMessage(error.toString());

              });




              

            }),
          )

        ],
      ),
    );
  }
}
