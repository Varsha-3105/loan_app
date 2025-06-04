import 'package:flutter/material.dart';
import 'income_details_screen.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() =>
      _PersonalLoanVerifyScreenState();
}

class _PersonalLoanVerifyScreenState
    extends State<VerifyAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each text field
  final _fullNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();
  final _branchCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verify Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Please fill the personal information',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Step Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          index == 1 ? Color(0xFF5F5ED2) : Colors.white,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index == 1 ? Colors.white : Color(0xFF5F5ED2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields with Validation
                _buildTextField(
                  'Full name (As per the bank)',
                  _fullNameController,
                ),
                const SizedBox(height: 12),
                _buildTextField('Bank Name', _bankNameController),
                const SizedBox(height: 12),
                _buildTextField(
                  'Account Number',
                  _accountNumberController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Bank Code',
                  _bankCodeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Branch Code',
                  _branchCodeController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const IncomeDetailsScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5F5ED2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text Field with Validation Logic
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }
}
