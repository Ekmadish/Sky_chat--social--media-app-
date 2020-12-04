import 'package:Blog_App/comments.dart';
import 'package:Blog_App/utils/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class ViewUser extends StatefulWidget {
  final String uid;
  ViewUser(this.uid);
  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  String onlineUseruid; //following, followers;
  Stream userstream;
  String username;
  int following;
  int followers;
  String profilepic;
  bool isfollowing;
  bool dataisthere = false;

  initState() {
    super.initState();
    getcurrentuseruid();
    getstream();
    getcurrentuserinfo();
  }

  getcurrentuserinfo() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot userdoc =
        await userCollection.document(widget.uid.trim()).get();
    var folowersDoc =
        await userCollection.doc(widget.uid).collection("followers").get();
    var foloweingDoc =
        await userCollection.doc(widget.uid).collection("following").get();

    userCollection
        .doc(widget.uid)
        .collection('followers')
        .doc(firebaseuser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          isfollowing = true;
        });
      } else {
        isfollowing = false;
      }
    });

    setState(() {
      username = userdoc.data()['username'];
      profilepic = userdoc.data()['profilePic'];
      dataisthere = true;

      followers = folowersDoc.docs.length;
      following = foloweingDoc.docs.length;
    });
  }

  getstream() async {
    // var firebaseuser = await FirebaseAuth.instance.currentUser;
    setState(() {
      userstream =
          tweetColection.where('uid', isEqualTo: widget.uid.trim()).snapshots();
    });
  }

  getcurrentuseruid() async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    setState(() {
      onlineUseruid = firebaseuser.uid;
    });
  }

  followUser() async {
    var docUser = await userCollection
        .doc(widget.uid)
        .collection('followers')
        .doc(onlineUseruid)
        .get();

    if (!docUser.exists) {
      userCollection
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineUseruid)
          .set({});
      userCollection
          .doc(onlineUseruid)
          .collection('following')
          .doc(widget.uid)
          .set({});
      setState(() {
        followers++;
        isfollowing = true;
      });
    } else {
      userCollection
          .doc(widget.uid)
          .collection('followers')
          .doc(onlineUseruid)
          .delete();

      userCollection
          .doc(onlineUseruid)
          .collection('following')
          .doc(widget.uid)
          .delete();
      setState(() {
        followers--;

        isfollowing = false;
      });
    }
  }

  likepost(String documentid) async {
    var firebaseuser = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot document = await tweetColection.document(documentid).get();

    if (document.data()['likes'].contains(firebaseuser.uid)) {
      tweetColection.document(documentid).updateData({
        'likes': FieldValue.arrayRemove([firebaseuser.uid])
      });
    } else {
      tweetColection.document(documentid).updateData({
        'likes': FieldValue.arrayUnion([firebaseuser.uid])
      });
    }
  }

  sharepost(String documentid, String tweet, String pic) async {
    FlutterShare.share(title: 'Flweetter', linkUrl: pic, text: tweet);

    // Share.text('Flitter', tweet, 'text/plain');
    DocumentSnapshot document = await tweetColection.document(documentid).get();
    tweetColection
        .document(documentid)
        .updateData({'shares': document.data()['shares'] + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataisthere == true
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.purple]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 6,
                          left: MediaQuery.of(context).size.width / 2 - 64),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(profilepic),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.7),
                      child: Column(
                        children: [
                          Text(
                            username,
                            style: mystyle(30, Colors.black, FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Following",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                "Followers",
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                following.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              ),
                              Text(
                                followers.toString(),
                                style:
                                    mystyle(20, Colors.black, FontWeight.w600),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () => followUser(),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: [Colors.blue, Colors.lightBlue])),
                              child: Center(
                                child: Text(
                                  isfollowing == false ? "Follow" : "Unfollow",
                                  style: mystyle(
                                      25, Colors.white, FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "User Tweets",
                            style: mystyle(25, Colors.black, FontWeight.w700),
                          ),
                          StreamBuilder(
                              stream: userstream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      DocumentSnapshot tweetdoc =
                                          snapshot.data.documents[index];
                                      return Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                tweetdoc.data()['profilepic']),
                                          ),
                                          title: Text(
                                            tweetdoc.data()['username'],
                                            style: mystyle(20, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (tweetdoc.data()['type'] == 1)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    tweetdoc.data()['tweet'],
                                                    style: mystyle(
                                                        20,
                                                        Colors.black,
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                              if (tweetdoc.data()['type'] == 2)
                                                Image(
                                                    image: NetworkImage(tweetdoc
                                                        .data()['image'])),
                                              if (tweetdoc.data()['type'] == 3)
                                                Column(
                                                  children: [
                                                    Text(
                                                      tweetdoc.data()['tweet'],
                                                      style: mystyle(
                                                          20,
                                                          Colors.black,
                                                          FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Image(
                                                        image: NetworkImage(
                                                            tweetdoc.data()[
                                                                'image'])),
                                                  ],
                                                ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CommentPage(
                                                                        tweetdoc
                                                                            .data()['id']))),
                                                        child:
                                                            Icon(Icons.comment),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc
                                                            .data()[
                                                                'commentcount']
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => likepost(
                                                            tweetdoc
                                                                .data()['id']),
                                                        child: tweetdoc
                                                                .data()['likes']
                                                                .contains(
                                                                    onlineUseruid)
                                                            ? Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Icon(Icons
                                                                .favorite_border),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc
                                                            .data()['likes']
                                                            .length
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () => sharepost(
                                                            tweetdoc
                                                                .data()['id'],
                                                            tweetdoc.data()[
                                                                'tweet'],
                                                            tweetdoc.data()[
                                                                'image']),
                                                        child:
                                                            Icon(Icons.share),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Text(
                                                        tweetdoc
                                                            .data()['shares']
                                                            .toString(),
                                                        style: mystyle(18),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              })
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
