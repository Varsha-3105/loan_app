import 'package:flutter/material.dart';
import 'employment_details_screen.dart';

class IncomeDetailsScreen extends StatefulWidget {
  const IncomeDetailsScreen({super.key});

  @override
  State<IncomeDetailsScreen> createState() =>
      _IncomeDetailsScreenState();
}

class _IncomeDetailsScreenState extends State<IncomeDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _monthlySalaryController = TextEditingController();
  final _additionalIncomeController = TextEditingController();
  String? _selectedPaymentMode;

  final List<String> _paymentModes = ['Bank transfer', 'Cash', 'Cheque', 'UPI'];

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
          'Income Details',
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
                        index == 2 ? Color(0xFF5F5ED2) : Colors.white,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: index == 2 ? Colors.white : Color(0xFF5F5ED2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Fields
              _buildTextField(
                'Net Monthly Salary',
                _monthlySalaryController,
              ).paddingBottom(12),
              _buildTextField(
                'Additional Income (If any)',
                _additionalIncomeController,
              ).paddingBottom(12),
              _buildDropdownField(
                'Mode of Salary Payment',
                _paymentModes,
              ).paddingBottom(20),

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
                              (context) =>
                                  const EmploymentDetailsScreen(),
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

  // Text Field with Validation
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }

  // Dropdown Field
  Widget _buildDropdownField(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      value: _selectedPaymentMode,
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
          _selectedPaymentMode = value;
        });
      },
      validator:
          (value) => value == null ? 'Please select a payment mode' : null,
    );
  }
}

// Extension for Padding
extension PaddingExtension on Widget {
  Widget paddingBottom(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);
}
