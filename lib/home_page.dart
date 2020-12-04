import 'package:Blog_App/pages/search_page.dart';
import 'package:Blog_App/pages/tweets_page.dart';
import 'package:Blog_App/utils/variables.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Blog_App/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  int page = 0;
  List pageOptions = [Tweets(), Search(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions[page],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black,
          currentIndex: page,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
              ),
              title: Text(
                "Home",
                style: mystyle(20),
              ),
            ),

            ///
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 32,
              ),
              title: Text(
                "Search",
                style: mystyle(20),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 32,
              ),
              title: Text(
                "Profile",
                style: mystyle(20),
              ),
            )
          ]),
    );
  }
}
