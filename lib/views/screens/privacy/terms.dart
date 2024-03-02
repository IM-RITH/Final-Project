import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Text style for the content
    const TextStyle contentStyle = TextStyle(fontSize: 16, height: 1.5);
    // Header style for section titles
    const TextStyle headerStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Terms of Use', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Terms of Use for EasyShop', style: headerStyle),
            SizedBox(height: 10),
            Text('Effective Date:  03.01.2024', style: contentStyle),
            SizedBox(height: 20),
            Text('1. Accounts', style: headerStyle),
            SizedBox(height: 10),
            Text(
              'When you create an account with us, you must provide information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
              style: contentStyle,
            ),
            SizedBox(height: 20),
            Text('2. Intellectual Property', style: headerStyle),
            SizedBox(height: 10),
            Text(
              'The application and its original content (excluding content provided by users), features, and functionality are and will remain the exclusive property of EasyShop and its licensors.',
              style: contentStyle,
            ),
          ],
        ),
      ),
    );
  }
}
