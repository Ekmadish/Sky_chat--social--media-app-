import 'dart:io';

import 'package:Blog_App/utils/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddTweet extends StatefulWidget {
  AddTweet({Key key}) : super(key: key);

  @override
  _AddTweetState createState() => _AddTweetState();
}

class _AddTweetState extends State<AddTweet> {
  TextEditingController tweetcontroller = TextEditingController();
  File imagepath;
  bool uploading = false;

  pickImage(ImageSource imGsource) async {
    final image = await ImagePicker().getImage(source: imGsource);
    setState(() {
      imagepath = File(image.path);
    });
    Navigator.pop(context);
  }

  optionDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.gallery),
                child: Text(
                  "Image from gallery",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickImage(ImageSource.camera),
                child: Text(
                  "Image from camera",
                  style: mystyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: mystyle(20),
                ),
              ),
            ],
          );
        });
  }

  uploadImage(String id) async {
    StorageUploadTask storageUploadTask = tweetpic.child(id).putFile(imagepath);
    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadurl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  posttweet() async {
    setState(() {
      uploading = true;
    });
    var currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc = await userCollection.doc(currentUser.uid).get();
    var alldocs = await tweetColection.get();
    int length = alldocs.docs.length;

    if (tweetcontroller.text != '' && imagepath == null) {
      tweetColection.doc('Tweet $length').set({
        'username': userdoc.data()["username"],
        'profilepic': userdoc.data()['profilePic'],
        'uid': currentUser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 1
      });
      Navigator.pop(context);
    }
    if (tweetcontroller.text == '' && imagepath != null) {
      String url = await uploadImage('Tweet $length');
      tweetColection.doc('Tweet $length').set({
        'username': userdoc.data()["username"],
        'profilepic': userdoc.data()['profilePic'],
        'uid': currentUser.uid,
        'id': 'Tweet $length',
        'image': url,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 2
      });
      Navigator.pop(context);
    }
    if (tweetcontroller.text != '' && imagepath != null) {
      String url = await uploadImage('Tweet $length');
      tweetColection.doc('Tweet $length').set({
        'username': userdoc.data()["username"],
        'profilepic': userdoc.data()['profilePic'],
        'uid': currentUser.uid,
        'id': 'Tweet $length',
        'tweet': tweetcontroller.text,
        'image': url,
        'likes': [],
        'commentcount': 0,
        'shares': 0,
        'type': 3
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => posttweet(),
          child: Icon(
            Icons.publish,
            size: 32,
          ),
        ),
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              size: 32,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Add Post",
            style: mystyle(20),
          ),
          actions: [
            InkWell(
              onTap: () => optionDialog(),
              child: Icon(
                Icons.photo,
                size: 40,
              ),
            )
          ],
        ),
        body: uploading == false
            ? Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tweetcontroller,
                      maxLines: null,
                      style: mystyle(20),
                      decoration: InputDecoration(
                          labelText: "What's happning now ?",
                          labelStyle: mystyle(20),
                          border: InputBorder.none),
                    ),
                  ),
                  imagepath == null
                      ? Container()
                      : MediaQuery.of(context).viewInsets.bottom > 0
                          ? Container()
                          : Image(
                              width: 200,
                              height: 200,
                              image: FileImage(imagepath),
                            ),
                ],
              )
            : Center(
                child: Text(
                  "Uploading.....",
                  style: mystyle(25),
                ),
              ));
  }
}
