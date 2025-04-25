import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final TextEditingController _questionController = TextEditingController();
  String _response = "";
  bool _isLoading = false;

  // Make API request
  Future<void> _sendQuestion() async {
    setState(() {
      _isLoading = true;
      _response = "";
    });

    final url = Uri.parse("http://127.0.0.1:8000/message/");
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": _questionController.text}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _response = data["response"] ?? "No response field found.";
        });
      } else {
        setState(() {
          _response = "Error: ${res.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error: ${e.toString()}";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(
          child: Text(
            "Freddie AI",
            style: TextStyle(fontSize: 35, fontStyle: FontStyle.normal),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                "Design to help you with your songs. Never be in trouble anymore.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Freddie will assist you by images, pdf's and texts, and if you want",
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                "you can just talk, cause in the end its freaking Freddie Mercury!",
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.blueAccent),
                ),
                onPressed: null,
                child: Text(
                  "Text",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    height: 50,
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ask Freddie something...',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: _isLoading ? null : _sendQuestion,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                _response,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
