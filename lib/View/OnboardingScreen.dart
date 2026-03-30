import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finote_program/View/Auth/AuthPage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      "title": "Welcome to Finote",
      "desc": "Manage attendance easily and efficiently.",
      "image": "assets/onboarding/onboarding1.png"
    },
    {
      "title": "Track Programs",
      "desc": "View and manage all your programs in one place.",
      "image": "assets/onboarding/onboarding2.png"
    },
    {
      "title": "Controllers Page",
      "desc": "Keep everything structured and simple.",
      "image": "assets/onboarding/onboarding3.png"
    },
    {
      "title": "Attendance Section",
      "desc": "Keep everything structured and simple.",
      "image": "assets/onboarding/onboarding4.png"
    },
  ];

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background PageView (FULL SCREEN IMAGE)
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (_, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    pages[index]["image"]!,
                    fit: BoxFit.cover,
                  ),

                  /// 🔹 Dark overlay for readability
                  // Container(
                  //   color: Colors.black.withOpacity(0.4),
                  // ),

                  /// 🔹 Text content
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         pages[index]["title"]!,
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 26,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       const SizedBox(height: 12),
                  //       Text(
                  //         pages[index]["desc"]!,
                  //         style: const TextStyle(
                  //           color: Colors.white70,
                  //           fontSize: 16,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            },
          ),

          /// 🔹 Dots Indicator (BOTTOM CENTER)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(4),
                  width: currentPage == index ? 12 : 8,
                  height: currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.white
                        : Colors.white54,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          /// 🔹 Button (BOTTOM)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(

                backgroundColor: currentPage == pages.length - 1 ? Colors.amber: Colors.blueAccent,
                foregroundColor:currentPage == pages.length - 1 ? Colors.black : Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // smaller = less rounded
                ),
              ),
              onPressed: () {
                if (currentPage == pages.length - 1) {
                  finishOnboarding();
                } else {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(
                currentPage == pages.length - 1
                    ? "Get Started"
                    : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}