import 'package:Blog_App/addtweet.dart';
import 'package:Blog_App/comments.dart';
import 'package:Blog_App/utils/variables.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class Tweets extends StatefulWidget {
  Tweets({Key key}) : super(key: key);

  @override
  _TweetsState createState() => _TweetsState();
}

class _TweetsState extends State<Tweets> with AutomaticKeepAliveClientMixin {
  String uid;

  @override
  void initState() {
    super.initState();
    getcurrentUser();
  }

  getcurrentUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      uid = currentUser.uid;
    });
  }

  sharepost(String docId, String tweet, String imageUrl) async {
    FlutterShare.share(text: tweet, title: "Flutweet", linkUrl: imageUrl);

    DocumentSnapshot documentSnapshot = await tweetColection.doc(docId).get();
    tweetColection.doc(docId).update({
      'shares': documentSnapshot.data()['shares'] + 1,
    });
  }

  likepost(String documentId) async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot document = await tweetColection.document(documentId).get();
    if (document.data()['likes'].contains(firebaseuser.uid)) {
      tweetColection.document(documentId).updateData({
        'likes': FieldValue.arrayRemove([firebaseuser.uid])
      });
    } else {
      tweetColection.document(documentId).updateData({
        'likes': FieldValue.arrayUnion([firebaseuser.uid])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTweet()),
        ),
        child: Icon(
          Icons.add,
          size: 34,
        ),
      ),
      appBar: AppBar(
        actions: [
          Icon(
            Icons.star,
            size: 28,
            color: Colors.black,
          )
        ],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Blog",
              style: mystyle(20, Colors.white, FontWeight.w700),
            ),
            SizedBox(
              width: 5.0,
            ),
            // Image(
            //   width: 45,
            //   height: 45,
            //   image: AssetImage('images/logo.png'),
            // ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: tweetColection.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext contex, int index) {
                DocumentSnapshot tweetDoc = snapshot.data.documents[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: CachedNetworkImageProvider(
                          tweetDoc.data()['profilepic']),
                    ),
                    title: Text(
                      tweetDoc.data()['username'],
                      style: mystyle(20, Colors.black, FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (tweetDoc.data()['type'] == 1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tweetDoc.data()['tweet'],
                                style:
                                    mystyle(20, Colors.black, FontWeight.w400),
                              ),
                            ),
                          if (tweetDoc.data()['type'] == 2)
                            Image(
                                image: CachedNetworkImageProvider(
                                    tweetDoc.data()['image'])),
                          if (tweetDoc.data()['type'] == 3)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tweetDoc.data()['tweet'],
                                  style: mystyle(
                                      20, Colors.black, FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Image(
                                    image: CachedNetworkImageProvider(
                                        tweetDoc.data()['image'])),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (contex) => CommentPage(
                                                  tweetDoc.data()['id']))),
                                      child: Icon(Icons.comment)),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    tweetDoc.data()['commentcount'].toString(),
                                    style: mystyle(18),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      likepost(tweetDoc.data()['id']);
                                      // print(tweetDoc.data()['id']);
                                    },
                                    child:
                                        tweetDoc.data()['likes'].contains(uid)
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                              ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    tweetDoc.data()['likes'].length.toString(),
                                    style: mystyle(18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => sharepost(
                                        tweetDoc.data()['id'],
                                        tweetDoc.data()['tweet'],
                                        tweetDoc.data()['image']),
                                    child: Icon(Icons.share),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    tweetDoc.data()['shares'].toString(),
                                    style: mystyle(18),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
