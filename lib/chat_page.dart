import 'package:Sai_chat_app/sevices/database.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
// import 'package:chat_app/sevices/database.dart';
// import 'package:chat_app/sevices/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  String name, imageUrl, userName;
  ChatPage({
    required this.userName,
    required this.imageUrl,
    required this.name,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUser, myname, myprofile, chatRoomId, messageId;

  Future<void> loadUserData() async {
    myUser = await addSharedPreferences().getUserUserName();
    myname = await addSharedPreferences().getUserName();
    myprofile = await addSharedPreferences().getUserImage();
    chatRoomId = getChatRoomIdByUsername(widget.name, myUser!);

    setState(() {
      // userName = name;
      print(" raju:$myUser");
      print(" raju1:$myprofile");
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    setState(() {});
  }

  getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  addMessage(bool isClicked) {
    if (messageController.text != "") {
      String message = messageController.text;
      messageController.text = "";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat("h:mma").format(now);
      Map<String, dynamic> messageInfo = {
        "message": message,
        "sendBy": myUser,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imageUrl": myprofile,
      };
      messageId = randomAlphaNumeric(10);
      databaseMethods().addMessage(chatRoomId!, messageId!, messageInfo).then((
        value,
      ) {
        Map<String, dynamic> lastMessageInfo = {
          "lastMessage": message,
          "lastMessagets": formattedDate,
          "lastMessageTime": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUser,
        };
        databaseMethods().lastMessage(chatRoomId!, lastMessageInfo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 1, top: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  SizedBox(width: 70),
                  Text(
                    textAlign: TextAlign.center,
                    "  Sairam",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 12,
                  top: 14,
                  right: 8,
                  bottom: 12,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Hey how are you ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Hi im fine",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.mic, color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 236, 236, 236),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              // textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(5),
                                hintText: "Send a message...",
                                suffixIcon: Icon(Icons.attach_file),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
