import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class ShimmeringLogo extends StatelessWidget {
  const ShimmeringLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        child: Shimmer.fromColors(
            child: Image.network(
                "https://lh3.googleusercontent.com/Iqoa6agJVh_B6KXdj4HdrbWfJHEMvhZCeUwvpkDJsanXAcb4Ex2h4mOtirVhiEYxfuY=w412-h220-rw"),
            baseColor: UniversalVariables.blackColor,
            highlightColor: Colors.white));
  }
}
