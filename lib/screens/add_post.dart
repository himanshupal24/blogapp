import 'dart:io';

import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final postRef = FirebaseDatabase.instance.reference().child('posts');
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  File? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Upload Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.camera),
                title: Text('Camera'),
              ),
              ListTile(
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                leading: Icon(Icons.image),
                title: Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Blog'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () => showImageDialog(context),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: _image != null
                    ? ClipRect(
                        child: Image.file(
                          _image!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintText: 'Enter post title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: 'Enter post Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  RoundButton(
                    title: 'Publish',
                    onPress: () async {
                      if (_image == null) {
                        toastMessage('Please select an image.');
                        return;
                      }
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        final date = DateTime.now().microsecondsSinceEpoch;
                        final ref =
                            FirebaseStorage.instance.ref('/blogapp$date');
                        final uploadTask = ref.putFile(_image!);

                        await uploadTask.whenComplete(() async {
                          final newUrl = await ref.getDownloadURL();
                          final user = _auth.currentUser;

                          await postRef
                              .child('Post List')
                              .child(date.toString())
                              .set({
                            'pId': date.toString(),
                            'pImage': newUrl.toString(),
                            'pTime': date.toString(),
                            'pTitle': titleController.text,
                            'pDescription': descriptionController.text,
                            'pEmail': user!.email,
                            'uid': user.uid,
                          });

                          toastMessage('Post published');
                        });

                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        toastMessage(e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void toastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: const Color.fromARGB(255, 54, 155, 244),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
