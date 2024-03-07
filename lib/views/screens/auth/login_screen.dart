import 'package:easyshop/views/screens/auth/register_screen.dart';
import 'package:easyshop/views/screens/forgetPassword/forget_pass.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Image.asset(
                    'assets/images/loginlogo1.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  const SizedBox(height: 10),
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
                    child: TextFormField(
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: TextFormField(
                      style: inputText,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
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
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed with the login logic
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
                      'Login',
                      style: loginTextStyle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Create account logic
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8A9418),
                      minimumSize:
                          const Size(double.infinity, 60), // button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: createAccTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
