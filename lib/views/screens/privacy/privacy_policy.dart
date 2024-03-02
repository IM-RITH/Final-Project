import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Text style for the privacy policy content
    const TextStyle contentStyle = TextStyle(fontSize: 16, height: 1.5);
    const TextStyle headerStyle =
        TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Privacy Policy for EasyShop',
              style: headerStyle,
            ),
            SizedBox(height: 10),
            Text(
              'Effective Date: 03.01.2024',
              style: contentStyle,
            ),
            SizedBox(height: 20),
            Text(
              '1. Information Collection',
              style: headerStyle,
            ),
            SizedBox(height: 10),
            Text(
              'We collect information from you when you register on our app, place an order, subscribe to our newsletter, or use certain other app features. The types of information we may collect include:\n\n'
              '- Personal Identification Information: Name, email address, mailing address, phone number, and payment information.\n'
              '- Non-Personal Identification Information: Browser name, type of computer, and technical information about your means of connection to our app, such as the operating system and the Internet service providers utilized.',
              style: contentStyle,
            ),
            SizedBox(height: 20),
            Text(
              '2. Use of Information',
              style: headerStyle,
            ),
            SizedBox(height: 10),
            Text(
              'The information we collect may be used in one of the following ways:\n\n'
              '- To personalize your experience\n'
              '- To improve our app\n'
              '- To improve customer service\n'
              '- To process transactions\n'
              '- To send periodic emails regarding your order or other products and services',
              style: contentStyle,
            ),
            // more sections
            SizedBox(height: 20),
            Text(
              '3. Information Sharing and Disclosure',
              style: headerStyle,
            ),
            SizedBox(height: 10),
            Text(
              'We do not sell, trade, or otherwise transfer to outside parties your personally identifiable information. This does not include trusted third parties who assist us in operating our app, conducting our business, or servicing you, so long as those parties agree to keep this information confidential.',
              style: contentStyle,
            ),
            // Continue adding sections for Data Protection and Security, User Rights and Choices, etc...
          ],
        ),
      ),
    );
  }
}
