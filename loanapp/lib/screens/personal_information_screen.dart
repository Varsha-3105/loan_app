import 'package:flutter/material.dart';
import '../model/loan_type_model.dart';
import 'verify_account_screen.dart'; // Import the next screen

class PersonalInformationScreen extends StatefulWidget {
  final LoanType loanType;

  const PersonalInformationScreen({super.key, required this.loanType});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Please fill the personal information",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Step Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return CircleAvatar(
                      backgroundColor:
                          index == 0 ? Color(0xFF5F5ED2) : Colors.white,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Color(0xFF5F5ED2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Form Fields
                _buildTextField("Full name", _fullNameController),
                _buildTextField("Mobile number", _mobileController),
                _buildTextField("Email Address", _emailController),
                _buildTextField("Age", _ageController, keyboardType: TextInputType.number),
                _buildDatePicker(context, "Date of Birth", _dobController),
                _buildDropdownField("Gender", ["Male", "Female", "Other"]),
                _buildTextField("Address", _addressController, maxLines: 3),

                const SizedBox(height: 30),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5F5ED2),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const VerifyAccountScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          if (label == "Age") {
            final age = int.tryParse(value);
            if (age == null) {
              return "Please enter a valid age";
            }
            if (age < 18) {
              return "Age must be at least 18";
            }
            if (age > 100) {
              return "Please enter a valid age";
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Date of Birth is required";
          }
          return null;
        },
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            controller.text =
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
          }
        },
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: _selectedGender,
        items:
            options.map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return "Gender is required";
          }
          return null;
        },
      ),
    );
  }
}
