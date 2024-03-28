import "package:easyshop/controller/auth_controller.dart";
import 'package:easyshop/views/screens/auth/register_screen.dart';
import 'package:easyshop/views/screens/forgetPassword/forget_pass.dart';
import 'package:easyshop/views/screens/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  // complete mail suggest... auto mail complete
  final List<String> _emailSuggestions = [
    '@gmail.com',
    '@outlook.com',
    '@yahoo.com',
    '@hotmail.com',
    '@icloud.com',
    '@protonmail.com',
  ];

  // clean up controller when widget disposed
  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // login function
  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      // Show loading dialog or indicator before the request
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      String email = _emailContoller.text.trim();
      String password = _passwordController.text.trim();

      String response = await _authController.loginUser(email, password);

      // Dismiss the loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      // Determine the color and icon based on the response
      Color snackBarColor =
          response == "Login successful" ? Colors.green : Colors.red;
      IconData snackBarIcon =
          response == "Login successful" ? Icons.check_circle : Icons.error;

      // Define the style for the message text
      TextStyle messageTextStyle = GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

      // Navigate to the home screen or stay based on the response
      if (response == "Login successful") {
        // Handle response with a styled Get.snackbar
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Success",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(snackBarIcon, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  response,
                  textAlign: TextAlign.start,
                  style: messageTextStyle,
                ),
              ),
            ],
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: snackBarColor,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        );
        Get.to(() => const MapScreen());
      } else {
        // Handle response with a styled Get.snackbar
        Get.snackbar(
          "",
          "",
          titleText: const Text(
            "Try Again!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          messageText: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(snackBarIcon, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  response,
                  textAlign: TextAlign.start,
                  style: messageTextStyle,
                ),
              ),
            ],
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackBarColor,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
          borderRadius: 10,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.easeInBack,
          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Styles for text
    TextStyle welcomeTextStyle = GoogleFonts.roboto(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    TextStyle subtitleTextStyle = GoogleFonts.lato(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    // forget password
    TextStyle forgetPassword = GoogleFonts.lato(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    // background color
    const Color backgroundColor = Color(0xFF322F2F);
    // lable style
    TextStyle labelStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.white,
    );

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

    // text input style
    TextStyle inputText = GoogleFonts.roboto(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

    // Padding for the entire screen
    const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 10.0);

    // login text style
    TextStyle loginTextStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    // create account text style
    TextStyle createAccTextStyle = GoogleFonts.roboto(
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

// Email Validator
    String? validateEmail(String? value) {
      RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      } else if (!emailRegExp.hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    }

    // validation
    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      } else if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
      return null;
    }

    Widget buildSocialMediaSignInButton({
      required String label,
      required IconData iconData,
      required Color bgColor,
      required Color textColor,
      required VoidCallback onPressed,
    }) {
      return ElevatedButton.icon(
        icon: Icon(iconData, size: 24, color: textColor),
        label: Text(label,
            style: GoogleFonts.roboto(
                color: textColor, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          minimumSize: const Size(180, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
      );
    }

    Widget buildSocialMediaSignInRow() {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Google Sign-In Button
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: buildSocialMediaSignInButton(
                label: 'Google',
                iconData: FontAwesomeIcons.google,
                bgColor: Colors.white,
                textColor: const Color.fromARGB(255, 196, 48, 48),
                onPressed: () async {
                  // Google Sign-In
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  String result = await _authController.signInWithGoogle();
                  // Dismiss the loading indicator
                  if (Get.isDialogOpen ?? false) Get.back();
                  if (result == "Sign in successful") {
                    Get.offAll(() => const MapScreen());
                    Get.snackbar(
                      "Login Success",
                      "You have successfully signed in with Google.",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      "Sign In Error",
                      result,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ),
            // Facebook Sign-In Button
            buildSocialMediaSignInButton(
              label: 'Facebook',
              iconData: FontAwesomeIcons.facebookF,
              bgColor: const Color(0xFF3b5998),
              textColor: Colors.white,
              onPressed: () async {
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );
                String result = await _authController.signInWithFacebook();
                if (Get.isDialogOpen ?? false) Get.back();
                if (result == "Sign in successful") {
                  Get.offAll(() => const MapScreen());
                  Get.snackbar(
                    "Login Success",
                    "You have successfully signed in with Facebook.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    "Sign In Error",
                    result,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      );
    }

    Widget buildOrDivider() {
      return Row(
        children: <Widget>[
          const Expanded(
            child: Divider(
              color: Colors.white,
              height: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Or Sign In With',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.white,
              height: 20,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: screenPadding,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Image.asset(
                    'assets/images/LoginIcon.png',
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const SizedBox(height: 5),
                  Text('Welcome back!', style: welcomeTextStyle),
                  const SizedBox(height: 8),
                  Text(
                    'Discover limitless Choices and Unmatched Convenience.',
                    textAlign: TextAlign.center,
                    style: subtitleTextStyle,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 60,
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _emailSuggestions.map((String option) {
                          final String email =
                              textEditingValue.text.toLowerCase() + option;
                          return email;
                        });
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: _emailContoller,
                          focusNode: focusNode,
                          style: inputText,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.mark_email_read_sharp,
                              color: Colors.white,
                            ),
                            labelText: 'Email Address',
                            labelStyle: labelStyle,
                            enabledBorder: inputBorder,
                            focusedBorder: focusedBorder,
                            errorBorder: inputBorder,
                            focusedErrorBorder: focusedBorder,
                            errorStyle: errorStyle,
                          ),
                          validator: validateEmail,
                          onFieldSubmitted: (String value) {
                            onFieldSubmitted();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      controller: _passwordController,
                      style: inputText,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            FontAwesomeIcons.lock,
                            color: Colors.white,
                            size: 20,
                          ),
                          labelText: 'Password',
                          labelStyle: labelStyle,
                          enabledBorder: inputBorder,
                          focusedBorder: focusedBorder,
                          errorBorder: inputBorder,
                          focusedErrorBorder: focusedBorder,
                          errorStyle: errorStyle,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          )),
                      validator: validatePassword,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Forgot password logic
                        Get.off(() => const ForgotPasswordScreen());
                      },
                      child: Text(
                        'Forget Password?',
                        style: forgetPassword,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F7ED9),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: loginTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Create account logic
                      Get.to(
                        () => const RegisterScreen(),
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
                      'Create Account',
                      style: createAccTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildOrDivider(),
                  const SizedBox(height: 2),
                  buildSocialMediaSignInRow()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
