import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/screens/chatscreens/widgets/cached_image.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      height: 50,
      width: 50,
      child: Shimmer.fromColors(
          child: CachedImage(user.profilePhoto),
          baseColor: UniversalVariables.blackColor,
          highlightColor: Colors.white),
    );
  }
}
