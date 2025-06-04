import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LoanDetailsScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const LoanDetailsScreen({
    super.key,
    required this.userId,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final name = userData['name'] as String? ?? 'No Name';
    final email = userData['email'] as String? ?? 'No Email';
    final loanAmount = userData['loanAmount'] as double? ?? 0.0;
    final loanTenure = userData['loanTenure'] as double? ?? 0.0;
    final loanStatus = userData['loanStatus'] as String? ?? 'pending';
    final requestDate = userData['loanRequestDate'] as Timestamp?;
    final profileImage = userData['profileImage'] as String?;
    final trackingSteps = userData['trackingSteps'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Loan Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF6355DD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF6355DD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: profileImage != null && profileImage.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profileImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Text(
                                    name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6355DD),
                                    ),
                                  ),
                            ),
                          )
                        : Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6355DD),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Loan Information'),
                  _buildInfoCard(
                    context,
                    [
                      _buildInfoRow(
                        Icons.attach_money,
                        'Loan Amount',
                        '\$${loanAmount.toStringAsFixed(2)}',
                      ),
                      _buildInfoRow(
                        Icons.timer,
                        'Loan Tenure',
                        '${loanTenure.toInt()} months',
                      ),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Request Date',
                        requestDate != null
                            ? DateFormat('MMMM d, y').format(requestDate.toDate())
                            : 'Unknown',
                      ),
                      _buildInfoRow(
                        Icons.info,
                        'Status',
                        loanStatus.toUpperCase(),
                        valueColor: _getStatusColor(loanStatus),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Application Progress'),
                  _buildTrackingStepsCard(context, trackingSteps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6355DD),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6355DD),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStepsCard(BuildContext context, Map<String, dynamic> trackingSteps) {
    final steps = [
      {'key': 'application_form', 'label': 'Application Form'},
      {'key': 'documents_submitted', 'label': 'Documents Submitted'},
      {'key': 'under_review', 'label': 'Under Review'},
      {'key': 'loan_transactions', 'label': 'Loan Transactions'},
      {'key': 'distributed', 'label': 'Distributed'},
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: steps.map((step) {
            final isCompleted = trackingSteps[step['key']] == true;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF6355DD)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.radio_button_unchecked,
                      color: isCompleted ? Colors.white : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step['label']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? const Color(0xFF6355DD) : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'distributed':
        return Colors.blue;
      case 'under_review':
        return Colors.purple;
      case 'documents_submitted':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
} 