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
  String? myUser, myname, myprofile;
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  var querySearchList = [];
  var temSearchStore = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    // loadInitialUsers();
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
    myUser = await addSharedPreferences().getUserName();
    myname = await addSharedPreferences().getUserName();
    myprofile = await addSharedPreferences().getUserImage();

    setState(() {
      // userName = name;
      print(" raju:$myUser");
      print(" raju1:$myprofile");
    });
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
      MaterialPageRoute(
        builder: (context) => Profile(),
      ),
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          userName: "",
                                          imageUrl: "",
                                          name: "",
                                        ),
                                      ),
                                    );
                                    searchController.text = "";
                                    isSearch = false;
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
                                        data['Name'],
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
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      userName: "",
                                      imageUrl: "",
                                      name: "",
                                    ),
                                  ),
                                );
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(7),
                                elevation: 5,
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      245,
                                      244,
                                      244,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      // CircleAvatar(
                                      //   radius: 50,
                                      //   child: Image(
                                      //     fit: BoxFit.cover,
                                      //     image: NetworkImage(
                                      //       "https://tse2.mm.bing.net/th/id/OIP.c5a3PU0Qkq6WT7y5bwvI8AHaKl?rs=1&pid=ImgDetMain&o=7&rm=3",
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 5),
                                      ClipRRect(
                                        child: Image(
                                          height: 80,

                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "https://tse2.mm.bing.net/th/id/OIP.c5a3PU0Qkq6WT7y5bwvI8AHaKl?rs=1&pid=ImgDetMain&o=7&rm=3",
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.center,
                                            "SaiRam Raju",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Hi Raju How are You",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        textAlign: TextAlign.center,
                                        "02:00 PM",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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

  Widget buuldResults(data) {
    return Container(
      padding: EdgeInsets.all(8),

      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                data["image"],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Text(
                  data["Name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black12,
                  ),
                ),
                Text(
                  data["username"],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
