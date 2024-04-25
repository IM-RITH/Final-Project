import "dart:typed_data";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:image_picker/image_picker.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:google_sign_in/google_sign_in.dart";
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

// Loin function
  Future<String> loginUser(String email, String password) async {
    String response = "Something went wrong! Please try again.";

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        // If user's email is not verified
        response = "Please verify your email before login.";
      } else {
        // Successful login
        response = "Login successful";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        response = "Not found user";
      } else if (e.code == "wrong-password") {
        response = "Wrong password";
      } else {
        response = e.message ?? "An error occurred";
      }
    } catch (e) {
      response = e.toString();
    }

    return response;
  }

  // reset password function
  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Password reset email sent. Please check your inbox.";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred while sending the reset email.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // sign in with google and update firestore
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return "User cancelled the sign in";
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user == null) {
        print('Firebase user object was null after Google sign-in.');
        return "Firebase User object was null";
      }

      // Checking if user data exists in Firestore
      final DocumentSnapshot userDoc =
          await _firestore.collection("buyers").doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection("buyers").doc(user.uid).set({
          'username': user.displayName ?? user.email?.split('@')[0],
          'profileImage': user.photoURL ?? '',
          'email': user.email,
          'buyerId': user.uid,
        });
        print('New user data added to Firestore.');
      } else {
        print('User already exists in Firestore.');
      }
      print(
          'Google sign-in successful, user data checked/updated in Firestore.');
      return "Sign in successful";
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during Google sign-in: ${e.message}');
      return e.message ?? "An error occurred during Google sign in.";
    } catch (e) {
      print('Exception during Google sign-in: $e');
      return "An unexpected error occurred.";
    }
  }

  // sign in with facebook
  Future<String> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        // Once signed in, return the UserCredential
        final UserCredential userCredential =
            await _auth.signInWithCredential(facebookAuthCredential);
        final User? user = userCredential.user;

        //check and update Firestore.
        if (user != null) {
          final userData = await FacebookAuth.instance.getUserData();
          final profileImageUrl = userData['picture']['data']['url'];
          final email = userData['email'];
          final username = userData['name'];

          await _firestore.collection("buyers").doc(user.uid).set({
            'username': username,
            'profileImage': profileImageUrl,
            'email': email,
            'buyerId': user.uid,
          }, SetOptions(merge: true));

          return "Sign in successful";
        } else {
          return "User not found";
        }
      } else {
        return "Facebook sign-in failed: ${result.status}";
      }
    } catch (e) {
      // print(e);
      return "An error occurred during Facebook sign in.";
    }
  }

  // logout function
  Future<void> signOut() async {
    await _auth.signOut();
    // Optionally sign out from Google as well
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    // Optionally sign out from Facebook
    await FacebookAuth.instance.logOut();
  }
}
