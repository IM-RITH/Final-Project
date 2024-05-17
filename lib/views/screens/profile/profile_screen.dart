import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/controller/auth_controller.dart';
import 'package:easyshop/views/screens/auth/login_screen.dart';
import 'package:easyshop/views/screens/profile/my_order.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');
    return FutureBuilder<DocumentSnapshot>(
      future: buyers.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Background with gradient and blur
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF153167),
                              const Color(0xFF153167).withOpacity(0.7)
                            ],
                          ),
                        ),
                      ),
                      // Profile Image
                      Positioned(
                        top: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              data['profileImage'],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Text(
                    data['username'],
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF153167),
                    ),
                  ),
                  Text(
                    data['email'],
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile Menu Items
                  const ProfileMenuItem(
                    icon: Icons.edit,
                    text: 'Edit Profile',
                    color: Colors.white,
                    backgroundColor: Color(0xFF153167),
                  ),
                  ProfileMenuItem(
                    icon: Icons.shopping_cart,
                    text: 'My Order',
                    color: Colors.white,
                    backgroundColor: const Color(0xFF153167),
                    onTap: () {
                      Get.to(
                        () => const MyOrderScreen(),
                      );
                    },
                  ),
                  const ProfileMenuItem(
                    icon: Icons.history,
                    text: 'Order History',
                    color: Colors.white,
                    backgroundColor: Color(0xFF153167),
                  ),
                  const ProfileMenuItem(
                    icon: Icons.favorite,
                    text: 'Wishlist',
                    color: Colors.white,
                    backgroundColor: Color(0xFF153167),
                  ),
                  ProfileMenuItem(
                    icon: Icons.exit_to_app,
                    text: 'Log Out',
                    color: Colors.white,
                    backgroundColor: const Color(0xFF153167),
                    onTap: () async {
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );
                      await Future.delayed(
                        const Duration(seconds: 2),
                      );
                      await _authController.signOut();

                      Get.back();
                      Get.offAll(() => const LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.backgroundColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.1),
          onTap: onTap,
          child: ListTile(
            leading: Icon(icon, color: color),
            title: Text(
              text,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
