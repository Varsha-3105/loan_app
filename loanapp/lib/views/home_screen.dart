import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'profile_screen.dart';
import 'location_screen.dart';
import 'calculator_screen.dart';
import 'logout_screen.dart';
import '../model/loan_type_model.dart';
import '/views/loan_type_card.dart';
import '../screens/personal_information_screen.dart';
 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Obx(
      () {
        // Wait until userId is initialized
        if (controller.userId.value.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final List<Widget> screens = [
          const HomeContent(),
          ProfileScreen(userId: controller.userId.value),
          const LocationScreen(),
          const CalculatorScreen(),
          LogoutScreen(
  name: controller.username.value,
  email: controller.email.value,
  profileImageUrl: controller.profileImageUrl.value,
),

        ];

        return Scaffold(
          body: screens[controller.selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) => controller.changeIndex(index),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'LoanTracking'),
              BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator'),
              BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Log Out'),
            ],
          ),
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0xFF5F5ED2),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          'Hello ${controller.username.value},',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    const SizedBox(height: 5),
                    const Text(
                      'You have no current loan',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 55,
                              color: Color(0xFF5F5ED2),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Easy Access',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'My loan app allows you easy access to loans up to the amount of 10Lakh',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? const Color(0xFF5F5ED2)
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Loan Types',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: controller.loanTypes.length,
                    itemBuilder: (context, index) {
                      final colors = [
                        Colors.pink[100],
                        Colors.green[100],
                        Colors.blue[100],
                        Colors.purple[100],
                      ];

                      final icons = [
                        Icons.account_balance_wallet_outlined,
                        Icons.home_work_outlined,
                        Icons.directions_car_outlined,
                        Icons.school_outlined,
                      ];

                       return LoanTypeCard(
  loanType: LoanType(
    name: controller.loanTypes[index],
    color: colors[index % colors.length]!,
    icon: icons[index % icons.length],
  ),
  onTap: () {
    Get.to(() => PersonalInformationScreen(
      loanType: LoanType(
        name: controller.loanTypes[index],
        color: colors[index % colors.length]!,
        icon: icons[index % icons.length],
      ),
    ));
  },
);

                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
