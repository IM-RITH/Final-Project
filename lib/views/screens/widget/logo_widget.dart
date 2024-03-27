import "package:flutter/material.dart";

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 4.0, right: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 100,
          ),
          ChatBubbleIcon(
            onTap: () {
              print("Chat");
              // _navigateToChatScreen(context);
            },
          ),
        ],
      ),
    );
  }
}

// void _navigateToChatScreen(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const ChatScreen()),
//   );
// }

// ChatBubble Icon
class ChatBubbleIcon extends StatelessWidget {
  final VoidCallback onTap;

  const ChatBubbleIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
