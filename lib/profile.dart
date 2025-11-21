import 'package:Sai_chat_app/sevices/auth.dart';
import 'package:Sai_chat_app/sevices/shared_preferences.dart';
import 'package:Sai_chat_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? myUser, myname, myprofile, email;
  Future<void> loadUserData() async {
    myUser = await addSharedPreferences().getUserUserName();
    myname = await addSharedPreferences().getUserName();
    myprofile = await addSharedPreferences().getUserImage();
    email = await addSharedPreferences().getUserEmail();

    setState(() {
      // userName = name;
      print(" raju:$myUser");
      print(" raju1:$myprofile");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Profile Page",
            style: GoogleFonts.spaceGrotesk(fontSize: 28, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: myname == null
            ? CircularProgressIndicator(color: Colors.white)
            : Column(
                children: [
                  SizedBox(height: 60),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                myprofile.toString(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Card(
                            elevation: 5,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8),
                              leading: Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.blue,
                              ),
                              title: Text(
                                "Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                myUser!.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Card(
                            elevation: 5,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8),
                              leading: Icon(
                                Icons.email,
                                size: 30,
                                color: Colors.blue,
                              ),
                              title: Text(
                                "Email",
                                style: TextStyle(fontSize: 16),
                              ),
                              subtitle: Text(
                                email.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () async {
                              await AuthMethods().signOut().then((Value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashScreen(),
                                  ),
                                );
                              });
                            },

                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                trailing: Icon(
                                  Icons.chevron_right,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                contentPadding: EdgeInsets.all(8),
                                leading: Icon(
                                  Icons.logout,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                // title: Text("Log Out",style: TextStyle(fontSize: 18),),
                                title: Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () async {
                              // await AuthMethods().signOut();
                              await AuthMethods().deleteAccount1().then((
                                value,
                              ) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashScreen(),
                                  ),
                                );
                              });
                            },

                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                trailing: Icon(
                                  Icons.chevron_right,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                contentPadding: EdgeInsets.all(8),
                                leading: Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // subtitle:Text(email.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
    );
  }
}
