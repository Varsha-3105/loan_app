import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../model/profile_user_model.dart';

class ProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cloudinary config
  final String cloudName = "dgpijwbnr";
  final String uploadPreset = "flutter_unsigned";

  Future<ProfileUserModel?> getUserProfile(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID is empty");
      }

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return ProfileUserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }

  Future<String?> uploadImageToCloudinary(File imageFile, {String folder = 'profile_pictures'}) async {
    final url = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..fields['folder'] = folder
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final resJson = json.decode(responseBody);
        return resJson['secure_url'];
      } else {
        final errorJson = json.decode(responseBody);
        print("Cloudinary error: ${errorJson['error']['message']}");
        return null;
      }
    } catch (e) {
      print("Error uploading to Cloudinary: $e");
      return null;
    }
  }

  Future<void> saveUserProfile({
    required String userId,
    required String name,
    required String phoneNumber,
    required int age,
    File? imageFile,
    File? salarySlipFile,
    File? documentFile,
    File? passportFile,
  }) async {
    try {
      if (userId.isEmpty) {
        throw Exception("User ID is empty. Cannot save profile.");
      }

      String? imageUrl;
      String? salarySlipUrl;
      String? documentUrl;
      String? passportUrl;

       
      if (imageFile != null) {
        imageUrl = await uploadImageToCloudinary(imageFile);
        if (imageUrl == null) throw Exception("Profile image upload failed");
      }

       
      if (salarySlipFile != null) {
        salarySlipUrl = await uploadImageToCloudinary(salarySlipFile, folder: 'salary_slips');
        if (salarySlipUrl == null) throw Exception("Salary slip upload failed");
      }

       
      if (documentFile != null) {
        documentUrl = await uploadImageToCloudinary(documentFile, folder: 'documents');
        if (documentUrl == null) throw Exception("Document upload failed");
      }

       
      if (passportFile != null) {
        passportUrl = await uploadImageToCloudinary(passportFile, folder: 'passports');
        if (passportUrl == null) throw Exception("Passport upload failed");
      }

      final existingDoc = await _firestore.collection('users').doc(userId).get();
      final existingMap = existingDoc.data() ?? {};

      final user = ProfileUserModel(
        name: name,
        phoneNumber: phoneNumber,
        age: age,
        profileImage: imageUrl ?? existingMap['profileImage'] ?? '',
        salarySlip: salarySlipUrl ?? existingMap['salarySlip'],
        document: documentUrl ?? existingMap['document'],
        passport: passportUrl ?? existingMap['passport'],
      );

      await _firestore.collection('users').doc(userId).set(
            user.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print("Error saving profile: $e");
      rethrow;
    }
  }
}
