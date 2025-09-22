import 'package:chat_app/chat_page.dart';
import 'package:chat_app/sevices/shared_preferences.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myUser, myname, myprofile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    setState(() {});
  }

  Future<void> loadUserData() async {
    myUser = await addSharedPreferences().getUserName();
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
                padding: const EdgeInsets.only(left: 14, top: 40, right: 14),
                child: Row(
                  children: [
                    Icon(Icons.waving_hand, color: Colors.amber),
                    SizedBox(width: 5),
                    Text(
                      textAlign: TextAlign.center,
                      myUser.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(myprofile.toString()),
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  textAlign: TextAlign.center,
                  " Sai Chat_Up",
                  style: TextStyle(
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
                          decoration: InputDecoration(
                            hintText: "Search User Name..",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage()),
                          );
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(7),
                          elevation: 5,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 244, 244),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
}
