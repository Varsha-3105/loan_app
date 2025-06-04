import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  Widget _buildTrackingStep(String label, bool isCompleted, bool isCurrent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green : (isCurrent ? Colors.green.withOpacity(0.1) : Colors.grey[200]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted ? Colors.green : (isCurrent ? Colors.green : Colors.grey),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.green : (isCurrent ? Colors.green : Colors.grey),
            ),
            child: Icon(
              isCompleted ? Icons.check : (isCurrent ? Icons.radio_button_checked : Icons.circle),
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isCompleted ? Colors.white : (isCurrent ? Colors.green : Colors.black87),
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status'),
        backgroundColor: const Color(0xFF5F5ED2),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data available'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final trackingSteps = userData['trackingSteps'] as Map<String, dynamic>? ?? {};
          final currentStatus = userData['loanStatus'] as String? ?? 'pending';

          // Check if all steps are completed
          final bool allStepsCompleted = trackingSteps['applicationForm'] == true &&
              trackingSteps['documentsSubmitted'] == true &&
              trackingSteps['underReview'] == true &&
              trackingSteps['loanTransactions'] == true &&
              trackingSteps['distributed'] == true;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Application Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTrackingStep(
                  'Application Form',
                  trackingSteps['applicationForm'] ?? false,
                  currentStatus == 'pending',
                ),
                const SizedBox(height: 12),
                _buildTrackingStep(
                  'Documents Submitted',
                  trackingSteps['documentsSubmitted'] ?? false,
                  currentStatus == 'documents_submitted',
                ),
                const SizedBox(height: 12),
                _buildTrackingStep(
                  'Under Review',
                  trackingSteps['underReview'] ?? false,
                  currentStatus == 'under_review',
                ),
                const SizedBox(height: 12),
                _buildTrackingStep(
                  'Loan Transactions',
                  trackingSteps['loanTransactions'] ?? false,
                  currentStatus == 'approved',
                ),
                const SizedBox(height: 12),
                _buildTrackingStep(
                  'Distributed',
                  trackingSteps['distributed'] ?? false,
                  currentStatus == 'distributed',
                ),
                const SizedBox(height: 24),
                if (currentStatus == 'rejected')
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your loan application has been rejected. Please contact support for more information.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (allStepsCompleted)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 12),
                            Text(
                              'Congratulations!',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your loan application has been fully processed. Please visit our office with the following:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRequirementItem('Valid government-issued ID'),
                        _buildRequirementItem('Original copies of submitted documents'),
                        _buildRequirementItem('Bank account details for loan disbursement'),
                        const SizedBox(height: 12),
                        const Text(
                          'Office Hours: Monday to Friday, 9:00 AM - 5:00 PM',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
