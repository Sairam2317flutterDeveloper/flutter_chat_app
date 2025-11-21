import 'package:Sai_chat_app/sevices/database.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
// import 'package:chat_app/sevices/database.dart';
// import 'package:chat_app/sevices/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  String name, imageUrl, userName, uid;
  ChatPage({
    required this.userName,
    required this.imageUrl,
    required this.name,
    required this.uid,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String? myUser, myname, myprofile, chatRoomId, messageId, myUId;
  Stream? messageStrem;

  Future<void> loadUserData() async {
    myUser = await addSharedPreferences().getUserUserName();
    myname = await addSharedPreferences().getUserName();
    myprofile = await addSharedPreferences().getUserImage();
    myUId = await addSharedPreferences().getUserId();
    chatRoomId = getChatRoomIdByUsername(widget.userName, myUser!);

    setState(() {
      // userName = name;
      print(" raju:${widget.userName}");
      print(" raju1:$myUser");
      print(" raju3:$chatRoomId");
    });
  }

  onload() {}

  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataAndStartStream();
    setState(() {
      print(" raju4: ${widget.userName}");
    });
  }

  void loadDataAndStartStream() async {
    await loadUserData(); // chatRoomId is ready
    messageStrem = databaseMethods().getChatroommMessages(chatRoomId!);
    setState(() {});
  }

  String getChatRoomIdByUsername(String a, String b) {
    a = a.toLowerCase().trim();
    b = b.toLowerCase().trim();

    if (a.compareTo(b) > 0) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
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
        if (isClicked) {
          message = "";
        }
      });
    }
  }

  getAndSetMessage() async {
    messageStrem = await databaseMethods().getChatroommMessages(chatRoomId);
    setState(() {});
  }

  Widget chatMessageType(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment: sendByMe
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: sendByMe
                    ? Radius.circular(0)
                    : Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: sendByMe ? Radius.circular(20) : Radius.circular(0),
              ),
              color: sendByMe ? Colors.grey : Colors.blue,
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
      stream: messageStrem,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,

                reverse: true,
                itemBuilder: (context, index) {
                  print("Stream snapshot: ${snapshot.data}");
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageType(ds["message"], myUser == ds["sendBy"]);
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          widget.name,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.teal,
        child: Column(
          children: [
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
                    Container(
                      // color: Colors.red,
                      height: MediaQuery.of(context).size.height / 1.37,
                      child: chatMessage(),
                    ),
                    SizedBox(height: 30),
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
                              // textAlign: TextAlign.cente
                              // r,
                              controller: messageController,
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
                        GestureDetector(
                          onTap: () {
                            addMessage(true);
                          },
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.send, color: Colors.white),
                          ),
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
