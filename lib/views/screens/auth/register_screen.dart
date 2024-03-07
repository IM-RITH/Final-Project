import "package:easyshop/views/screens/auth/login_screen.dart";
import "package:easyshop/views/screens/privacy/privacy_policy.dart";
import "package:easyshop/views/screens/privacy/terms.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // background color
    const Color backgroundColor = Color(0xFF322F2F);

// main text
    TextStyle mainText = GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
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

    // lable style
    TextStyle labelStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 17,
      color: Colors.white,
    );
    // text input style
    TextStyle inputText = GoogleFonts.roboto(
        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
// create account text style
    TextStyle createAccountTextStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

// Already have an account text stye
    TextStyle alreadyTextStyle = GoogleFonts.roboto(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    // login text stye
    TextStyle loginTextStyle = GoogleFonts.roboto(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.lightBlue,
    );

    // error style
    TextStyle errorStyle = GoogleFonts.roboto(
      fontSize: 12,
      height: 0.1,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );

    // Validation section
    // Username Validator
    String? validateUsername(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

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

    // Password Validator
    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      } else if (value.length < 8) {
        return 'Password must be at least 8 characters';
      }
      return null;
    }

    // Confirm Password Validator
    String? validateConfirmPassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      } else if (_passwordController.text != value) {
        return 'Passwords do not match';
      }
      return null;
    }

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) => Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Image.asset(
                      'assets/images/loginlogo1.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Let's Create Your Account!",
                      style: mainText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      style: inputText,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_add_alt_sharp,
                          color: Colors.white,
                        ),
                        labelText: 'Username',
                        labelStyle: labelStyle,
                        enabledBorder: inputBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: inputBorder,
                        focusedErrorBorder: focusedBorder,
                        errorStyle: errorStyle,
                      ),
                      validator: validateUsername,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: inputText,
                      controller: _emailController,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      style: inputText,
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password_sharp,
                          color: Colors.white,
                        ),
                        labelText: 'Password',
                        labelStyle: labelStyle,
                        enabledBorder: inputBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: inputBorder,
                        focusedErrorBorder: focusedBorder,
                        errorStyle: errorStyle,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Colors.white,
                        ),
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: inputText,
                      // controller: _passwordController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password_sharp,
                          color: Colors.white,
                        ),
                        labelText: 'Confirm Password',
                        labelStyle: labelStyle,
                        enabledBorder: inputBorder,
                        focusedBorder: focusedBorder,
                        errorBorder: inputBorder,
                        focusedErrorBorder: focusedBorder,
                        errorStyle: errorStyle,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
                          },
                          icon: Icon(_confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Colors.white,
                        ),
                      ),
                      validator: validateConfirmPassword,
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      // textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 15),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            //  add a recognizer here if you want to handle taps

                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PrivacyPolicyScreen(),
                                  ),
                                );
                              },
                          ),
                          const TextSpan(
                            text: ' and ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Terms of use',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TermsOfUseScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F7ED9),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                        if (_formKey.currentState!.validate()) {}
                      },
                      child: Text(
                        'Create Account',
                        style: createAccountTextStyle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account?",
                            style: alreadyTextStyle,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              " Login",
                              style: loginTextStyle,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
