import 'package:easyshop/controller/auth_controller.dart';
import 'package:easyshop/views/screens/forgetPassword/send_email.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final AuthController authController = AuthController();

    // Email validation logic
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email address.';
      }
      // Use a regular expression to validate the email
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Enter a valid email address.';
      }
      return null;
    }

    // background color
    const Color backgroundColor = Color(0xFF322F2F);

    // forget pass text
    TextStyle forgetpass = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    );

    // forget pass text
    TextStyle subforgetpass = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );

    // Padding for the entire screen
    const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0);

    // input border
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white, width: 1.0),
    );

    // Define the input border style when the TextField is focused
    OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 41, 87, 124),
        width: 2.0,
      ),
    );

    // lable style
    TextStyle labelStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.white,
    );

    // text input style
    TextStyle inputText = GoogleFonts.roboto(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

    //submit text style
    TextStyle submitTextStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    // error style
    TextStyle errorStyle = GoogleFonts.roboto(
      fontSize: 12,
      height: 0.1,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                ),
                Image.asset(
                  'assets/forgetPassword/forgetpass1.gif',
                  height: 250,
                  width: 250,
                ),
                Text(
                  'Forget Password',
                  style: forgetpass,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  'Enter your email and we will send you a reset password link.',
                  style: subforgetpass,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  style: inputText,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.mark_email_read_sharp,
                      color: Colors.white,
                    ),
                    labelText: 'Email',
                    labelStyle: labelStyle,
                    enabledBorder: inputBorder,
                    focusedBorder: focusedBorder,
                    errorBorder: inputBorder,
                    focusedErrorBorder: focusedBorder,
                    errorStyle: errorStyle,
                  ),
                  validator: validateEmail,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Show a loading dialog
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(width: 20),
                                Text(
                                  'Processing Data',
                                  style: submitTextStyle.copyWith(
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        barrierDismissible: false,
                      );

                      // Send password reset email
                      String result = await authController
                          .sendPasswordResetEmail(emailController.text);

                      // Close the loading dialog
                      Get.back();

                      // Use Get.snackbar to show the result
                      if (result ==
                          "Password reset email sent. Please check your inbox.") {
                        Get.to(
                            () => SendEmailScreen(email: emailController.text));
                      } else {
                        Get.snackbar(
                          "Error", // Title
                          result, // Message
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F7ED9),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: submitTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
