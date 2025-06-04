import 'package:flutter/material.dart';

class ReviewSummaryScreen extends StatelessWidget {
  final String loanType;
  final String name;
  final String mobile;
  final String email;
  final String loanId;
  final String applyDate;
  final String passportNumber;
  final String loanAmount;
  final String loanTenure;

  const ReviewSummaryScreen({
    super.key,
    required this.loanType,
    required this.name,
    required this.mobile,
    required this.email,
    required this.loanId,
    required this.applyDate,
    required this.passportNumber,
    required this.loanAmount,
    required this.loanTenure,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Early and one-time payment increases your loan limit and makes you eligible for higher amounts.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            _buildInfoRow('Loan Type', loanType),
            _buildInfoRow('Name', name),
            _buildInfoRow('Mobile No.', mobile),
            _buildInfoRow('Email', email),
            _buildInfoRow('Loan ID', loanId),
            _buildInfoRow('Apply Date', applyDate),
            _buildInfoRow('NRIC/Passport No.', passportNumber),
            _buildInfoRow('Loan Amount', '₹$loanAmount'),
            _buildInfoRow('Loan Tenure', '$loanTenure months'),

            const Spacer(),

            // Go to Home Button
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  FloatingActionButton(
                    backgroundColor: Color(0xFF5F5ED2),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Download Started...")),
                      );
                    },
                    child: const Icon(Icons.download, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigates back to HomeScreen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5F5ED2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Go to Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget to Build Info Rows
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// Sample Usage for Navigation
class PreviousScreen extends StatelessWidget {
  const PreviousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const ReviewSummaryScreen(
                      loanType: 'Personal Loan',
                      name: 'Maya Anand',
                      mobile: '9825147849',
                      email: 'mayaa2025@gmail.com',
                      loanId: 'HL01245789',
                      applyDate: '20 Feb, 2025',
                      passportNumber: 'J2514784',
                      loanAmount: '7,50,000.00',
                      loanTenure: '20',
                    ),
              ),
            );
          },
          child: const Text('Go to Review Summary'),
        ),
      ),
    );
  }
}
