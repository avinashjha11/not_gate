import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_input_border/gradient_input_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../colours.dart';
import '../error_handler.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final formKey = new GlobalKey<FormState>();

  String notice, message;

  bool loading = false;

  File selectedImage;
  final imagepicker = ImagePicker();

  Future getImage() async {
    final pickedFile = await imagepicker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      }
    });
  }

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void checkimage() {
    if (selectedImage == null) {
      Fluttertoast.showToast(
        msg: 'Please add an image.',
      );
    } else {
      setState(() {
        loading = true;
      });
      uploadImage();
    }
  }

  void uploadImage() {
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference =
    FirebaseStorage.instance.ref().child('Images').child(imageFileName);

    final UploadTask uploadTask = storageReference.putFile(selectedImage);

    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        saveData(imageUrl);
      });
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      ErrorHandler().errorDialog(context, error);
    });
  }

  void saveData(String imageUrl) {
    var dateFormat = DateFormat('MMM d, yyyy');
    var timeFormat = DateFormat('EEEE, hh:mm a');

    String date = dateFormat.format(DateTime.now()).toString();
    String time = timeFormat.format(DateTime.now()).toString();
    String index = DateTime.now().toString();

    FirebaseFirestore.instance.collection('not_gate').add({
      'imageUrl': imageUrl,
      'notice': notice,
      'message': message,
      'date': date,
      'time': time,
      'index': index,
    }).whenComplete(() {
      Fluttertoast.showToast(
        msg: 'Notice added successfully.',
      );
      Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        loading = false;
      });
      ErrorHandler().errorDialog(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(child: Form(key: formKey, child: _buildUploadForm())));
  }

  _buildUploadForm() {
    var textStyle2 = TextStyle(color: Colors.white, fontSize: 18);
    var linearGradient =
    LinearGradient(colors: [Constants.oorange, Constants.orange]);
    var gradientOutlineInputBorder = GradientOutlineInputBorder(
        borderRadius: BorderRadius.circular(18.0),
        focusedGradient: linearGradient,
        unfocusedGradient:
        LinearGradient(colors: [Constants.black_s3, Constants.black_s3]));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.black_s1,
        appBar: AppBar(
          title: Center(
            child: Text('not_gate'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.upload_outlined),
              onPressed: () {
                if (checkFields()) {
                  checkimage();
                }
              },
            ),
          ],
        ),
        body: loading
            ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ))
            : Container(
          padding:
          const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: selectedImage != null
                      ? Container(
                    height: 210,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(8)),
                      child: Image.file(
                        selectedImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    height: 210,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                    width: double.infinity,
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: textStyle2,
                  maxLength: 100,
                  decoration: InputDecoration(
                      hintText: 'Enter Title',
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 16.0),
                      fillColor: Constants.black_s2,
                      border: gradientOutlineInputBorder),
                  onChanged: (value) {
                    this.notice = value;
                  },
                  validator: (value) =>
                  value.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 10,
                  maxLength: 500,
                  style: textStyle2,
                  decoration: InputDecoration(
                      hintText: 'Enter Message',
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 16.0),
                      fillColor: Constants.black_s2,
                      border: gradientOutlineInputBorder),
                  onChanged: (value) {
                    this.message = value;
                  },
                  validator: (value) =>
                  value.isEmpty ? 'Message is required' : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
