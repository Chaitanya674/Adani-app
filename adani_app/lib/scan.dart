import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;
  String? message = ''; 

  upload() async {
    final request = http.MultipartRequest("POST" , Uri.parse("http://10.0.2.2:5000/text"));
    final header = {"Content-type" : "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file' , 
        File(pictureFile!.path).readAsBytes().asStream(), 
        File(pictureFile!.path).lengthSync(), 
        filename: pictureFile!.path.split("/").last));
    request.headers.addAll(header);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return 
        Scaffold(
        appBar: AppBar(title: const Text('Adani Product Proctor'),),
        body: ListView(
        shrinkWrap: true,
        children : <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: CameraPreview(controller),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                pictureFile = await controller.takePicture();
                setState(() {});
              },
              child: const Text('Capture Image'),
            ),
          ),
          if (pictureFile != null)
            Image.file(
              File(pictureFile!.path),
              height: 200,
            ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(onPressed: upload , child: Column(children: const [
                Icon(Icons.upload_file , size: 80,),
                Text("Upload" , style: TextStyle(fontSize: 20)),
              ],)),
            ),
            message == '' ? const Text('the result is :', style: TextStyle(fontSize: 20)) : Text(message! , style: TextStyle(fontSize: 20)),
          ],
        ),
      );
  }
}