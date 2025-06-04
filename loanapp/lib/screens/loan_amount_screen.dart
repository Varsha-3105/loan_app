import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loan_successfull_screen.dart';

class LoanAmountScreen extends StatefulWidget {
  const LoanAmountScreen({super.key});

  @override
  State<LoanAmountScreen> createState() => _SelectLoanAmountScreenState();
}

class _SelectLoanAmountScreenState extends State<LoanAmountScreen> {
  double _loanAmount = 15000;
  double _loanTenure = 6;
  bool _isLoading = false;

  final Map<String, String> _uploadedUrls = {
    "passport": "",
    "photo": "",
    "propertydocument": "",
    "salaryslip": "",
  };

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUpload(String docType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    String cloudinaryUrl = 'https://api.cloudinary.com/v1_1/dgpijwbnr/image/upload';
    String uploadPreset = 'flutter_unsigned';

    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
    request.fields['upload_preset'] = uploadPreset;
    request.fields['folder'] = docType;

    request.files.add(await http.MultipartFile.fromPath('file', pickedFile.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseData);
        final url = decoded['secure_url'];
        if (url != null) {
          setState(() {
            _uploadedUrls[docType] = url;
          });
          print("$docType uploaded: $url");
        } else {
          print("URL not found in response: $responseData");
        }
      } else {
        print("Upload failed (${response.statusCode}): $responseData");
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }

  Future<void> _submitLoanApplication() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("User not logged in.");
      return;
    }

    setState(() => _isLoading = true);

    // Optional: Notify if some documents are missing
    if (_uploadedUrls.values.any((url) => url.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Some documents are missing, but proceeding."),
        ),
      );
    }

    try {
      // First, save the loan documents in the subcollection
      final loanDocRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('loan_documents')
          .add({
        'passport': _uploadedUrls['passport'],
        'photo': _uploadedUrls['photo'],
        'propertydocument': _uploadedUrls['propertydocument'],
        'salaryslip': _uploadedUrls['salaryslip'],
        'loanAmount': _loanAmount,
        'loanTenure': _loanTenure,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Then update the user document with loan application status
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'hasLoanRequest': true,
        'loanStatus': 'pending',
        'loanAmount': _loanAmount,
        'loanTenure': _loanTenure,
        'loanRequestDate': FieldValue.serverTimestamp(),
        'loanRequestId': loanDocRef.id,
        'loanDocuments': {
          'passport': _uploadedUrls['passport'],
          'photo': _uploadedUrls['photo'],
          'propertydocument': _uploadedUrls['propertydocument'],
          'salaryslip': _uploadedUrls['salaryslip'],
        }
      });

      print("Loan application saved successfully.");
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoanSubmittedScreen()),
        );
      }
    } catch (e) {
      print("Error saving loan application: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error submitting loan application: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F5ED2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Loan Amount',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF5F5ED2),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Based on your profile you are eligible for the following.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                _buildSlider(
                  'Loan Amount',
                  _loanAmount,
                  15000,
                  100000,
                  (value) => setState(() => _loanAmount = value),
                  'Rs. ${_loanAmount.toStringAsFixed(0)}/-',
                ),
                _buildSlider(
                  'Loan Tenure',
                  _loanTenure,
                  6,
                  360,
                  (value) => setState(() => _loanTenure = value),
                  '${_loanTenure.toInt()} months',
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Document',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  _buildUploadButton('NRIC / Passport', 'passport'),
                  _buildUploadButton('Photo', 'photo'),
                  _buildUploadButton('Property Document', 'propertydocument'),
                  _buildUploadButton('Salary Slip', 'salaryslip'),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitLoanApplication,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5F5ED2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    String displayValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(min.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white70)),
            Text(displayValue, style: const TextStyle(color: Colors.white)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 10,
          activeColor: Colors.white,
          inactiveColor: Colors.white24,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildUploadButton(String label, String docType) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          ElevatedButton(
            onPressed: () => _pickAndUpload(docType),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5F5ED2),
            ),
            child: const Text('Upload', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
