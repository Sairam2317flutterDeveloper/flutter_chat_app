import 'package:Sai_chat_app/sevices/auth.dart';
// import 'package:chat_app/sevices/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Container(child: Image.asset("images/chat1.jpg")),
            SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              "Stay Connected, Anytime, Anywhere",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              textAlign: TextAlign.center,
              "Chat instantly with friends and family, share moments, and build conversations that matter — all in one place",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                AuthMethods().signInWithGoogle(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 58,

                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // color: Colors.amber,
                      child: Image.asset("images/google.png"),
                    ),
                    SizedBox(width: 20),
                    Text(
                      textAlign: TextAlign.center,
                      "Login With Google chat app",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
