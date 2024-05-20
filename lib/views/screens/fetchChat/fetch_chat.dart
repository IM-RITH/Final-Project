import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FetchChat extends StatefulWidget {
  const FetchChat({super.key});

  @override
  State<FetchChat> createState() => _FetchChatState();
}

class _FetchChatState extends State<FetchChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF153167),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Chat',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Center(
          child: Text('Fetch chat'),
        ));
  }
}
