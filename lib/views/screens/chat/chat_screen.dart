import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Chat",
          style: GoogleFonts.roboto(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
