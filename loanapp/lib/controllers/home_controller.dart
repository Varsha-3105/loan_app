import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var loanTypes = <String>[].obs;
  var username = ''.obs;
  var email = ''.obs;
  var profileImageUrl = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLoanTypes();
    loadUserData();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void loadLoanTypes() {
    loanTypes.value = [
      'Personal Loan',
      'Home Loan',
      'Car Loan',
      'Education Loan',
    ];
  }

  void setUsername(String name) {
    username.value = name;
  }

  void loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId.value = user.uid;
      email.value = user.email ?? 'guest@example.com';
      
      // Fetch user data from Firestore
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
            
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          username.value = userData['name'] ?? 'Guest';
          profileImageUrl.value = userData['profileImage'] ?? '';
        }
      } catch (e) {
        print('Error loading user data: $e');
      }
    }
  }
}
