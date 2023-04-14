import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'scan.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 File? selectImage ;
    String? message = ''; 

    upload() async {
      final request = http.MultipartRequest("POST" , Uri.parse("http://10.0.2.2:5000/text"));
      final header = {"Content-type" : "multipart/form-data"};
      request.files.add(
        http.MultipartFile(
          'file' , 
          selectImage!.readAsBytes().asStream(), 
          selectImage!.lengthSync() , 
          filename: selectImage!.path.split("/").last));
      request.headers.addAll(header);
      final response = await request.send();
      http.Response res = await http.Response.fromStream(response);
      final resJson = jsonDecode(res.body);
      message = resJson['message'];
      setState(() {
        
      });
    }

    Future getImage() async {
      final pickedImg = await ImagePicker().getImage(source: ImageSource.gallery);
      selectImage = File(pickedImg!.path);
      setState(() {
        
      });
    }

  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
        body: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(onPressed: getImage, child: Column(children: const [
                    Icon(Icons.camera_alt_rounded, size: 80,),
                    Text("Add file" , style: TextStyle(fontSize: 20)),
                  ], )),
            ),
            selectImage == null ? const Text('please select an image', style: TextStyle(fontSize: 20)) : Image.file(selectImage!),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(onPressed: upload , child: Column(children: const [
                  Icon(Icons.upload_file , size: 80,),
                  Text("Upload" , style: TextStyle(fontSize: 20)),
                ],)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraPage(cameras: value,),
                        ),
                      ),
                    );
                  },
                  child: const Text('Launch Camera'),
                ),
              ),
              message == '' ? const Text('the result is :', style: TextStyle(fontSize: 20)) : Text(message! , style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ]
      ),
    );
  }
}