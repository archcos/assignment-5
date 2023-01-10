import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  String? label;

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    statuses[Permission.storage];
  }

  getGallery() async {
    XFile pickedFile = (await ImagePicker().pickImage(
      source: ImageSource.gallery,
    )) as XFile;
    setState(() {
      imageFile = File(pickedFile.path);
      label = "Image Loaded Successfully";
    });
  }

  getCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image == null) {
      return;
    }
      setState(() {
        imageFile = File(image.path);
        label = "Image Captured Successfully";
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/logo.png', fit: BoxFit.cover),
        title: const Text("Photos"),
      ),
      body: imageFile == null
          ? Container(
                  constraints: const BoxConstraints.expand(),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: const Image(
                      image: AssetImage("assets/logo.png")
                  ),
          )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Image.file(imageFile!, fit: BoxFit.cover),
                const SizedBox(height: 20,),
                Center(
                    child: Text("$label",
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.red, fontSize: 20)
                    )
                )
              ]
      ),
      floatingActionButton: PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text("Take Photo"),
                  onTap: (){
                    getCamera();
                  },
                )
            ),
            PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text("Select Photo"),
                  onTap: () {
                    getGallery();
                  }
                )
            )
          ],
          icon: Container(
            height: 700,
            width: 1000,
            decoration: const ShapeDecoration(
                color: Colors.redAccent,
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.red, width: 2),
                )
            ),
          child: const Icon(Icons.add, color: Colors.white),
      ),
      )
    );
  }
}
