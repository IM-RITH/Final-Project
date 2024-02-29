import 'package:easyshop/models/onboarding.dart';
import 'package:easyshop/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: contents.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(contents[index].image.toString()),
                      Text(
                        contents[index].title.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                      Text(
                        contents[index].description.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.grey),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  contents.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 7,
                    width: currentIndex == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color:
                          currentIndex == index ? Colors.blue : Colors.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                // After finish onboarding page => naviagte to login page
                if (currentIndex == contents.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
                pageController.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
              },
              child: Text(
                currentIndex == contents.length - 1 ? "Get Started" : "Next",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
