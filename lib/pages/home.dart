import 'package:flutter/material.dart';
import 'package:ia_gemini_freddie/pages/pdf.dart';
import 'package:ia_gemini_freddie/pages/talk.dart';
import 'package:ia_gemini_freddie/pages/text_page.dart';

import 'image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(child: Text("Freddie AI", style: TextStyle(fontSize: 35, fontStyle: FontStyle.normal),)),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text("Design to help you with your songs. Never be in trouble anymore.", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("Freddie will assist you by images, pdf's and texts, and if you want", style: TextStyle(fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text("you can just talk, cause in the end its freaking Freddie Mercury!", style: TextStyle(fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 110),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Talk()));
                        },
                        child: Text("Talk", style: TextStyle(color: Colors.black),)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePage()));
                        },
                        child: Text("Image", style: TextStyle(color: Colors.black))
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfPage()));
                        },
                        child: Text("PDF", style: TextStyle(color: Colors.black))
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TextPage()));
                        },
                        child: Text("Text", style: TextStyle(color: Colors.black))
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Image.asset(
                    'assets/images/freddie.png',
                    height: 360
                )
            )
          ],
        ),
      ),
    );
  }
}
