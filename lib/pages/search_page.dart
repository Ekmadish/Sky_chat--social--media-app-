import 'package:Twitter_Clone/pages/viewUser_page.dart';
import 'package:Twitter_Clone/utils/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> searchedUser;
  searchUser(String user) {
    var users =
        userCollection.where('username', isGreaterThanOrEqualTo: user).get();
    setState(() {
      searchedUser = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.withAlpha(77),
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search fo users',
              hintStyle: mystyle(15, Colors.black),
            ),
            onFieldSubmitted: searchUser,
          ),
        ),
        body: searchedUser == null
            ? Center(
                child: Text(
                  "Search for users...",
                  style: mystyle(15, Colors.black),
                ),
              )
            : FutureBuilder(
                future: searchedUser,
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot user = snapshot.data.documents[index];
                        return Card(
                          elevation: 8.0,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(user.data()['profilePic']),
                            ),
                            title: Text(
                              user.data()['username'],
                              style: mystyle(18),
                            ),
                            trailing: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewUser(user.data()['uid']))),
                              child: Container(
                                width: 90,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.lightBlue),
                                child: Center(
                                  child: Text(
                                    "View",
                                    style: mystyle(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ));
  }
}
