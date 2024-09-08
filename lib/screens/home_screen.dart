import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:culinote_flutter/theme/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List images = [];
  String generatedRecipe = "";

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      images = result.paths.map((e) => File(e!)).toList();
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  Future<void> uploadMultipleFiles() async {
    var uri = Uri.parse("https://6c4a-103-156-70-67.ngrok-free.app/api/recipe/search");
    var request = http.MultipartRequest('POST', uri);

    for (var file in images) {
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var streamed = await http.Response.fromStream(response);
        Map<String, dynamic> jsonResponse = json.decode(streamed.body);
        if (jsonResponse['data']['choices'].length > 0) {
          setState(() {
            generatedRecipe = jsonResponse['data']['choices'][0]['message']['content'];
          });
        }

        print(jsonResponse['data']['choices']);
      } else {
        print('Failed to upload files. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/background.png', width: double.infinity, fit: BoxFit.cover,),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,),
                  Image.asset('assets/images/logo.png', width: 200),
                  const SizedBox(height: 80,),
                  Text("What’s On Your Refrigerator?", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge,),
                  const SizedBox(height: 30,),
                  OutlinedButton(
                      onPressed: () => pickImage(), child: const Text('Pick Image'),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 8),
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15)
                        ],
                    ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.map((e) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.file(
                              e,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      FilledButton(onPressed: () => uploadMultipleFiles(), child: const Text('Search Recipe')),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Markdown(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    data: generatedRecipe,
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
