import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfState();
}

class _PdfState extends State<PdfPage> {
  final TextEditingController _questionController = TextEditingController();
  String _response = "";
  bool _isLoading = false;
  String _uploadMessage = "";
  File? _selectedPdf;
  Uint8List? _pdfBytes;
  String? _pdfName;

  // Uploading
  Future<void> _uploadPdf() async {
    if (_pdfBytes == null || _pdfName == null) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:8000/upload/'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      _pdfBytes!,
      filename: _pdfName!,
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);
      setState(() {
        _uploadMessage = data['message'];
      });
    } else {
      setState(() {
        _uploadMessage = 'Failed to upload PDF.';
      });
    }
  }


  // Picking the pdf
  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _pdfBytes = result.files.single.bytes;
        _pdfName = result.files.single.name;
      });
    }
  }


  // Ask question to /message/
  Future<void> _sendQuestion() async {
    setState(() {
      _isLoading = true;
      _response = "";
    });

    final res = await http.post(
      Uri.parse('http://localhost:8000/message/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': _questionController.text}),
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        _response = data['response'];
      });
    } else {
      setState(() {
        _response = "Failed to get a response.";
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
      body: SingleChildScrollView(
        child:Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Design to help you with your songs. Never be in trouble anymore.",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                "Freddie will assist you by images, pdf's and texts, and if you want",
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const Text(
                "you can just talk, cause in the end its freaking Freddie Mercury!",
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                onPressed: _pickPdf,
                child: const Text("Select PDF", style: TextStyle(color: Colors.black),),
              ),
              if (_pdfBytes != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                    onPressed: _uploadPdf,
                    child: const Text("Upload PDF", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(_uploadMessage),
              ],
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ask Freddie something...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: _isLoading ? null : _sendQuestion,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  _response,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
