import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 6),
      child: Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            width: 100,
          ),
        ],
      ),
    );
  }
}
