import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Detect_page extends StatefulWidget {
  const Detect_page({ Key? key }) : super(key: key);

  @override
  State<Detect_page> createState() => _Detect_pageState();
}

class _Detect_pageState extends State<Detect_page> {
  File? selectImage ;
  String? message = ''; 

  upload() async {
    final request = http.MultipartRequest("POST" , Uri.parse("http://10.0.2.2:5000/api"));
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
    message = resJson.toString();
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
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectImage == null ? const Text('please select an image', style: TextStyle(fontSize: 20)) : Image.file(selectImage!),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: getImage, child: Column(children: const [
                  Icon(Icons.camera_alt_rounded, size: 80,),
                  Text("Add file" , style: TextStyle(fontSize: 20)),
                ], )),
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
        )
      ),
      ]
    );
  }
}