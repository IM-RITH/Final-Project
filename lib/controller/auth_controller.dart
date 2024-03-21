import "dart:typed_data";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // select or pick an image

  Future<Map<String, dynamic>?> pickProfile(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      Uint8List imagaData = await file.readAsBytes();
      String fileName = file.name;
      String fileExtension = fileName.split('.').last;

      return {
        "imageData": imagaData,
        "fileExtension": fileExtension,
      };
    } else {
      print('No image selected.');
      return null;
    }
  }

  // function to store image to firebase store
  Future<String> uploadImageToFirebase(
      Uint8List? image, String? fileExtension) async {
    // determine the MIME type
    String mineType = 'image/$fileExtension';
    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      mineType = 'image/jpeg';
    } else if (fileExtension == 'png') {
      mineType = 'image/png';
    }
    // create a reference for storage
    Reference ref = _storage
        .ref()
        .child('profileImages')
        .child('${_auth.currentUser!.uid}.$fileExtension');

    // set custome metadata
    SettableMetadata metaData = SettableMetadata(contentType: mineType);
    UploadTask uploadTask = ref.putData(image!, metaData);

    // Await completion and download url
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> createNewUser(String username, String email, String password,
      Uint8List? image, String? fileName) async {
    String response = "Opp! Something wrong!";

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String url = await uploadImageToFirebase(image, fileName);

      // send an email to verify
      User? user = userCredential.user;
      await user?.sendEmailVerification();

      // create colllection
      await _firestore.collection("buyers").doc(user?.uid).set({
        'username': username,
        'profileImage': url,
        "email": email,
        "buyerId": user?.uid,
      });

      if (user != null && user.emailVerified == false) {
        response = "Create success. Please verify your email";
      } else {
        response = "User created, but we could not send a verification email.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        response = "The account already exist";
      } else {
        response = e.message ?? "An error occurred";
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }
}
