import 'package:chat_app/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 14, right: 14),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 70),
            Container(
              child: Image.network(
                "https://static.vecteezy.com/system/resources/previews/010/549/829/non_2x/girl-texting-on-phone-messaging-chatting-with-friend-online-looking-at-smart-phone-typing-online-conversation-and-communication-concept-illustration-free-vector.jpg",
              ),
            ),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              "Stay Connected, Anytime, Anywhere",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              textAlign: TextAlign.center,
              "Chat instantly with friends and family, share moments, and build conversations that matter — all in one place",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contex) {
                      return HomePage();
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 48,

                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: Colors.amber,
                      child: Image.network(
                        "https://i.pinimg.com/originals/68/3d/9a/683d9a1a8150ee8b29bfd25d46804605.png",
                      ),
                    ),
                    SizedBox(width: 40),
                    Text(
                      textAlign: TextAlign.center,
                      "Login With Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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
