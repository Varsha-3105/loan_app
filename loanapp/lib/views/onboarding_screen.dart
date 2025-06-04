import 'package:flutter/material.dart';
import 'package:loanapp/views/selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Easy Access",
      "description":
          "My loan app allows you easy access to loans up to the amount of 1 Crore",
      "icon": "assets/image/onboard_icon_1.png",
      "image": "assets/image/onboard1.jpg",
    },
    {
      "title": "Interest",
      "description":
          "My loan app allows you easy access to loans up to the amount of 1 Crore",
      "icon": "assets/image/onboard_icon_2.png",
      "image": "assets/image/onboard2.jpg",
    },
    {
      "title": "Flexible Repayment",
      "description":
          "My loan app allows you easy access to loans up to the amount of 1 Crore",
      "icon": "assets/image/onboard_icon_3.png",
      "image": "assets/image/onboard3.jpg",
    },
    {
      "title": "Speedy Loan Process",
      "description":
          "My loan app allows you easy access to loans up to the amount of 1 Crore",
      "icon": "assets/image/onboard_icon_4.png",
      "image": "assets/image/onboard4.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
                icon: onboardingData[index]["icon"]!,
                image: onboardingData[index]["image"]!,
              );
            },
          ),

          // Dot Indicator
          Positioned(
            bottom: 130, // Positioned above the FAB
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),

          // Custom Floating Action Button
          Positioned(
            bottom: 50, // Moves the FAB higher
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  if (_currentIndex < onboardingData.length - 1) {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    // Navigate to Selection Screen when reaching the last onboarding page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectionScreen()),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentIndex == index ? 12 : 8,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150),
          Image.asset(icon, height: 80, color: Colors.white),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
