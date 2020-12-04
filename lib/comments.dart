import 'package:Blog_App/utils/variables.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentPage extends StatefulWidget {
  final String docId;
  CommentPage(this.docId, {Key key}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  var commentController = TextEditingController();

  addComment() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await userCollection.doc(currentUser.uid).get();

    tweetColection.doc(widget.docId).collection('comments').doc().set({
      'comment': commentController.text,
      'username': userDoc.data()['username'],
      'uid': userDoc.data()['uid'],
      'profilePic': userDoc.data()['profilePic'],
      'time ': DateTime.now(),
    });
    DocumentSnapshot commentCount =
        await tweetColection.doc(widget.docId).get();
    tweetColection.doc(widget.docId).update({
      'commentcount': commentCount.data()['commentcount'] + 1,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Comment Page",
      //     style: mystyle(20),
      //   ),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: tweetColection
                        .doc(widget.docId)
                        .collection('comments')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot commentsDoc =
                                snapshot.data.documents[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: CachedNetworkImageProvider(
                                    commentsDoc.data()['profilePic']),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    commentsDoc.data()['username'],
                                    style: mystyle(20),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                    //height: 7,
                                    child: Text(
                                      ' /  ',
                                      style: mystyle(
                                          9, Colors.black, FontWeight.w900),
                                    ),
                                  ),
                                  Text(
                                    commentsDoc.data()['comment'],
                                    style: mystyle(
                                        18, Colors.grey, FontWeight.w500),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                tAgo
                                    .format(
                                        commentsDoc.data()['time '].toDate())
                                    .toString(),
                                style: mystyle(13),
                              ),
                            );
                          });
                    }),
              ),
              Divider(
                color: Colors.amberAccent,
              ),
              ListTile(
                title: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                      hintStyle: mystyle(18),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    autocorrect: true),
                trailing: OutlineButton(
                  onPressed: () => addComment(),
                  borderSide: BorderSide.none,
                  child: Text(
                    "Publish ",
                    style: mystyle(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
