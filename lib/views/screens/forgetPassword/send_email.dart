import 'package:easyshop/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendEmailScreen extends StatelessWidget {
  const SendEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'testing@gmail.com',
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
                onPressed: () {
                  // resend function logic
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
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
