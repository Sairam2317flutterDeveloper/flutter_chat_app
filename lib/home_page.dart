// import 'package:Sai_chat_app/chatRoomLIte.dart';
import 'package:Sai_chat_app/chat_page.dart';
import 'package:Sai_chat_app/profile.dart';
import 'package:Sai_chat_app/sevices/database.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
// import 'package:chat_app/chat_page.dart';
// import 'package:chat_app/sevices/database.dart';
// import 'package:chat_app/sevices/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? chatRoomstreams;
  String? myUser, myname, myprofile, myemail;
  String? guestName = "", gusetProfile = "", guestId = "", guestUserName = "";
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  var querySearchList = [];
  var temSearchStore = [];
  String getChatRoomIdByUsername(String a, String b) {
    a = a.toLowerCase().trim();
    b = b.toLowerCase().trim();

    if (a.compareTo(b) > 0) {
      return "${b}_$a";
    } else {
      return "${a}_$b";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Guest"$):
    onTheLoad();
    // loadUserData();

    setState(() {});
  }

  // void loadInitialUsers() async {
  //   // Fetch all users or limit to first 10 users
  //   QuerySnapshot docs = await FirebaseFirestore.instance
  //       .collection("users")
  //       .limit(10)
  //       .get();

  //   // Add fetched data to querySearchList
  //   querySearchList = docs.docs.map((doc) => doc.data()).toList();

  //   // Optionally, show all in temSearchStore initially
  //   setState(() {
  //     temSearchStore = List.from(querySearchList);
  //     isSearch = false; // so ListView is displayed
  //   });
  // }

  void intialSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        querySearchList = [];
        temSearchStore = [];
        isSearch = false;
      });
      return;
    }

    setState(() {
      isSearch = true;
    });

    // 👇 lowercase everything to match Firestore `searchKey`
    var searchValue = value.substring(0, 1).toUpperCase() + value.substring(1);
    print("🔎 User typed: $searchValue");

    // first time: fetch from Firestore
    if (querySearchList.isEmpty && value.length == 1) {
      databaseMethods().search(value).then((QuerySnapshot docs) {
        print("📌 Firestore returned ${docs.docs.length} docs");
        for (int i = 0; i < docs.docs.length; ++i) {
          var data = docs.docs[i].data();
          print("✅ Firestore doc: $data");
          querySearchList.add(data);
        }
        setState(() {});
      });
    } else {
      temSearchStore = [];
      querySearchList.forEach((element) {
        var username = element['username'].toString().toLowerCase();
        var searchValue = value.toLowerCase();

        print("🔍 Comparing: $username with $searchValue");

        if (username.startsWith(searchValue)) {
          print("🎯 Match found: $username");
          temSearchStore.add(element);
        }
      });

      setState(() {});
    }
  }

  // intialSearch(value) {
  //   if (value.length == 0) {
  //     setState(() {
  //       querySearchList = [];
  //       temSearchStore = [];
  //     });
  //   }
  //   setState(() {
  //     isSearch = true;
  //   });
  //   var capitalizedValue =
  //       value.substring(0, 2).oUpperCase() + value.substring(1);
  //   if (querySearchList.isEmpty && value.length == 1) {
  //     databaseMethods().search(value).then((QuerySnapshot docs) {
  //       for (int i = 0; i < docs.docs.length; i++) {
  //         querySearchList.add(docs.docs[i].data());
  //       }
  //     });
  //   } else {
  //     temSearchStore = [];
  //     querySearchList.forEach((element) {
  //       if (element['username'].startsWith(capitalizedValue)) {
  //         setState(() {
  //           temSearchStore.add(element);
  //         });
  //       }
  //     });
  //   }
  // }

  Future<void> loadUserData() async {
    myUser = await addSharedPreferences().getUserUserName();
    myname = await addSharedPreferences().getUserName();
    myemail = await addSharedPreferences().getUserEmail();
    myprofile = await addSharedPreferences().getUserImage();

    setState(() {
      // userName = name;
      print(" raju:$myUser");
      print(" raju1:$myprofile");
    });
  }

  onTheLoad() async {
    await loadUserData();
    chatRoomstreams = await databaseMethods().getChatrooms();
    setState(() {});
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomstreams,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Chatroomlite(
                    chatRoomId: ds.id,
                    lastMessage: ds["lastMessage"],
                    myUserName: myUser!,
                    // time: ds["lastMessagets"],
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          color: Colors.teal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, top: 50, right: 14),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(
                      textAlign: TextAlign.center,
                      myUser.toString(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(myprofile.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  textAlign: TextAlign.center,
                  "Welcome To",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  textAlign: TextAlign.center,
                  " Sai Chat_Up",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        // height: 38,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: const Color.fromARGB(255, 211, 208, 208),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: double.infinity,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            intialSearch(value.toUpperCase());
                          },
                          decoration: InputDecoration(
                            hintText: "Search User Name..",
                            prefixIcon: Icon(Icons.search),

                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      isSearch
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: temSearchStore.length,
                              itemBuilder: (context, index) {
                                var data = temSearchStore[index];
                                return GestureDetector(
                                  onTap: () async {
                                    isSearch = false;

                                    var chatRoomId = getChatRoomIdByUsername(
                                      myUser!,
                                      data["username"],
                                    );
                                    Map<String, dynamic> chatInfoMap = {
                                      "users": [myUser, data["username"]],
                                    };
                                    await databaseMethods().createChatRoom(
                                      chatRoomId,
                                      chatInfoMap,
                                    );

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          userName: data["username"],
                                          imageUrl: data["image"],
                                          name: data["Name"],
                                          uid: data["id"],
                                        ),
                                      ),
                                    );
                                    searchController.text = "";

                                    // isSearch = false;
                                  },
                                  child: Card(
                                    borderOnForeground: true,
                                    elevation: 9,

                                    margin: EdgeInsets.all(7),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(4),
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          data['image'],
                                        ),
                                      ),

                                      title: Text(
                                        data['username'],
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(data['Email']),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Expanded(child: chatRoomList()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buuldResults(data) {
  //   return Container(
  //     padding: EdgeInsets.all(8),

  //     child: Container(
  //       padding: EdgeInsets.all(10),
  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //       child: Row(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(60),
  //             child: Image.network(
  //               data["image"],
  //               height: 70,
  //               width: 70,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           SizedBox(width: 20),
  //           Column(
  //             children: [
  //               Text(
  //                 data["Name"],
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black12,
  //                 ),
  //               ),
  //               Text(
  //                 data["username"],
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class Chatroomlite extends StatefulWidget {
  String lastMessage, chatRoomId, myUserName;
  Chatroomlite({
    super.key,
    required this.chatRoomId,
    required this.lastMessage,
    required this.myUserName,
    // required this.time,
  });

  @override
  State<Chatroomlite> createState() => _ChatroomliteState();
}

class _ChatroomliteState extends State<Chatroomlite> {
  String? guestName, gusetProfile, guestId, guestUserName;
  getUserInfo() async {
    guestUserName = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUserName, "");
    QuerySnapshot querySnapshot = await databaseMethods().getUserInfo(
      guestUserName!,
    );
    if (!mounted) return;
    guestName = "${querySnapshot.docs[0]["Name"]}";
    gusetProfile = "${querySnapshot.docs[0]["image"]}";
    guestId = "${querySnapshot.docs[0]["id"]}";
    guestUserName = "${querySnapshot.docs[0]["username"]}";
    if (!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    print("guestname:$guestName");
    print("guestuser:$guestUserName");
    print("guestprofile:$gusetProfile");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),

      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(gusetProfile.toString()),
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Text(
                  guestUserName.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.lastMessage,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
