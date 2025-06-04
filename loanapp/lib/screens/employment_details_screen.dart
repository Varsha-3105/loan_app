import 'package:flutter/material.dart';
import 'loan_amount_screen.dart';

class EmploymentDetailsScreen extends StatefulWidget {
  const EmploymentDetailsScreen({super.key});

  @override
  State<EmploymentDetailsScreen> createState() =>
      _EmploymentDetailsScreenState();
}

class _EmploymentDetailsScreenState
    extends State<EmploymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _companyNameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _totalExperienceController = TextEditingController();
  final _yearsInCurrentJobController = TextEditingController();

  String? _selectedEmploymentType;
  final List<String> _employmentTypes = [
    'Salaried',
    'Self-employed',
    'Freelancer',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Employment Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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

              // Step Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (index) => CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        index == 4 ? Color(0xFF5F5ED2) : Colors.white,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index == 4 ? Colors.white : Color(0xFF5F5ED2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Fields
              _buildTextField('Company Name', _companyNameController),
              const SizedBox(height: 12),
              _buildTextField('Job Title', _jobTitleController),
              const SizedBox(height: 12),
              _buildDropdownField('Employment Type', _employmentTypes),
              const SizedBox(height: 12),
              _buildTextField(
                'Total Work Experience',
                _totalExperienceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'Years in Current Job',
                _yearsInCurrentJobController,
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
                              (context) => const LoanAmountScreen(),
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
          return '$label is required';
        }
        return null;
      },
    );
  }

  // Dropdown Field with Validation
  Widget _buildDropdownField(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      value: _selectedEmploymentType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items:
          options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEmploymentType = value;
        });
      },
      validator:
          (value) => value == null ? 'Please select an employment type' : null,
    );
  }
}
