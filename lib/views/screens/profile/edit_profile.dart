import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _profileImageController;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _profileImageController = TextEditingController();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _profileImageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');
    DocumentSnapshot userDoc = await buyers.doc(_auth.currentUser!.uid).get();
    Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

    setState(() {
      _usernameController.text = data['username'];
      _emailController.text = data['email'];
      _profileImageController.text = data['profileImage'];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload to Firebase Storage and get the download URL
      String downloadUrl = await _uploadImageToFirebase(_image!);
      setState(() {
        _profileImageController.text = downloadUrl;
      });
    }
  }

  Future<String> _uploadImageToFirebase(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profileImages')
          .child('${_auth.currentUser!.uid}.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image: $e');
      return '';
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await Future.delayed(const Duration(seconds: 2));
      CollectionReference buyers =
          FirebaseFirestore.instance.collection('buyers');
      await buyers.doc(_auth.currentUser!.uid).update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'profileImage': _profileImageController.text,
      });

      Get.back();

      if (mounted) {
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appbarText = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    TextStyle labelStyle = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.grey[700],
    );

    String? validateUsername(value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your username';
      }
      return null;
    }

    String? validateEmail(value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: appbarText),
        backgroundColor: const Color(0xFF0C2D57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(_profileImageController.text)
                          as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(FontAwesomeIcons.camera,
                          color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: labelStyle,
                  prefixIcon: const Icon(
                    FontAwesomeIcons.user,
                    color: Color(0xFF0C2D57),
                    size: 22,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: validateUsername,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: labelStyle,
                  prefixIcon: const Icon(FontAwesomeIcons.envelope,
                      color: Color(0xFF0C2D57)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _profileImageController,
                style: const TextStyle(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Profile Image URL',
                  labelStyle: labelStyle,
                  prefixIcon: const Icon(FontAwesomeIcons.image,
                      color: Color(0xFF0C2D57)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                enabled: false,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _updateProfile,
                icon: const Icon(
                  FontAwesomeIcons.floppyDisk,
                  color: Colors.white,
                ),
                label: Text('Save Changes',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C2D57),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
