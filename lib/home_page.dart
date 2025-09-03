import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 20, right: 14),
              child: Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.amber),
                  SizedBox(width: 5),
                  Text(
                    textAlign: TextAlign.center,
                    " Hello Sairam",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Text(
                textAlign: TextAlign.center,
                "Chat Up",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30),
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
                          color: Colors.grey,
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
                    Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 5,
                      child: Container(
                        width: double.infinity,
                        height: 80,
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
