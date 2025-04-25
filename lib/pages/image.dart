import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  Uint8List? _imageBytes;
  PlatformFile? _selectedFile;
  String uploadMessage = '';
  String apiResponse = '';
  String inputText = '';
  final TextEditingController _textController = TextEditingController();
  bool isSending = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFile = result.files.single;
        _imageBytes = result.files.single.bytes!;
        uploadMessage = '';
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedFile == null) return;

    final request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/upload/'));
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      _selectedFile!.bytes!,
      filename: _selectedFile!.name,
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(responseBody);
      setState(() {
        uploadMessage = jsonResponse['message'] ?? 'Upload success!';
      });
    } else {
      setState(() {
        uploadMessage = 'Upload failed: ${response.statusCode}';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (inputText.trim().isEmpty) return;

    setState(() {
      isSending = true;
    });

    final response = await http.post(
      Uri.parse('http://localhost:8000/message/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': inputText}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        apiResponse = jsonResponse['response'] ?? '';
      });
    } else {
      setState(() {
        apiResponse = 'Error: ${response.statusCode}';
      });
    }

    setState(() {
      isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(child: Text("Freddie AI", style: TextStyle(fontSize: 35))),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const SizedBox(height: 60),
            const Text(
              "Design to help you with your songs. Never be in trouble anymore.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text("Freddie will assist you by images, pdf's and texts, and if you want",
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 1),
            const Text("you can just talk, cause in the end its freaking Freddie Mercury!",
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
              onPressed: _pickImage,
              child: const Text("Select Image", style: TextStyle(color: Colors.black)),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                onPressed: _uploadImage,
                child: const Text("Upload Image", style: TextStyle(color: Colors.black),),
              ),
              const SizedBox(height: 10),
              Text(uploadMessage),
            ],
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 500,
                    child: TextField(
                      controller: _textController,
                      onChanged: (value) => inputText = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ask Freddie something...',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: isSending ? null : _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(apiResponse),
              ),
            )
          ]),
        ),
      ));
  }
}
