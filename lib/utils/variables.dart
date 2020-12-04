import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mystyle(double size, [Color color, FontWeight fontWeight]) {
  return GoogleFonts.montserrat(
    fontSize: size,
    fontWeight: fontWeight,
    color: color,
  );
}

CollectionReference userCollection = Firestore.instance.collection("users");
CollectionReference tweetColection = Firestore.instance.collection("tweets");
StorageReference tweetpic =
    FirebaseStorage.instance.ref().child('tweeetpictures');
var exampleImage =
    'https://thumbs.dreamstime.com/b/example-red-tag-example-red-square-price-tag-117502755.jpg';
