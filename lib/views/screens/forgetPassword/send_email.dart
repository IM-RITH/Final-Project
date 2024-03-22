import 'package:easyshop/controller/auth_controller.dart';
import 'package:easyshop/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SendEmailScreen extends StatelessWidget {
  final String email;

  const SendEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController();
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
    TextStyle subforgetpass2 = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );
    // Padding for the entire screen
    const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0);

    //submit text style
    TextStyle submitTextStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: screenPadding,
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
                'assets/forgetPassword/forgetpass2.gif',
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 20),
              Text(
                'Password Reset Email Sent',
                style: forgetpass,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: subforgetpass,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Your Account Security is Our Priority! We’ve sent you a secure link to safety change your password and keep your account protected.',
                style: subforgetpass2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  // resend function
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
                              'Resending email...',
                              style: submitTextStyle.copyWith(
                                  color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierDismissible: false,
                  );
                  String result =
                      await authController.sendPasswordResetEmail(email);
                  Get.back();
                  Get.snackbar(
                    "Password Reset Email",
                    result,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey[900]!,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(10),
                    borderRadius: 10,
                    snackStyle: SnackStyle.FLOATING,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F7ED9),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Resend',
                  style: submitTextStyle,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(() => const LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A9418),
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: submitTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
