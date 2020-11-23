import 'package:flutter/material.dart';
import 'package:skype_clone/models/call.dart';
import 'package:skype_clone/resources/call_methods.dart';
import 'package:skype_clone/screens/callscreens/call_screen.dart';
import 'package:skype_clone/utils/permission.dart';

class PickUpScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();
  PickUpScreen({@required this.call, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Incoming",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Image.network(
            call.callerPic,
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            call.callerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 75,
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.call_end,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  await callMethods.endCall(call: call);
                },
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                icon: Icon(
                  Icons.call,
                  color: Colors.green,
                ),
                onPressed: () async =>
                    await Permissions.cameraAndMicrophonePermissionsGranted()
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CallScreen(call: call),
                            ))
                        : {},
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      ),
    ));
  }
}
