import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const UserDetailsScreen({
    super.key,
    required this.userId,
    required this.userData,
  });

  Future<void> _deleteUser(BuildContext context) async {
    try {
      // Show confirmation dialog
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // Get the admin user
        final adminUser = FirebaseAuth.instance.currentUser;
        if (adminUser == null) {
          throw Exception('Admin user not found');
        }

        // Check if the current user is an admin
        final adminDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(adminUser.uid)
            .get();

        if (!adminDoc.exists || adminDoc.data()?['isAdmin'] != true) {
          throw Exception('You do not have permission to delete users');
        }

        // Delete user document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
        
        // Note: We cannot delete the user from Firebase Auth directly
        // This requires Firebase Admin SDK on the backend
        // Instead, we'll just delete their Firestore document

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
          Navigator.pop(context); // Return to previous screen
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = userData['name'] as String? ?? 'No Name';
    final email = userData['email'] as String? ?? 'No Email';
    final phone = userData['phone'] as String? ?? 'No Phone';
    final address = userData['address'] as String? ?? 'No Address';
    final createdAt = userData['createdAt'] as Timestamp?;
    final profileImage = userData['profileImage'] as String?;
    final hasLoanRequest = userData['hasLoanRequest'] as bool? ?? false;
    final loanAmount = userData['loanAmount'] as double? ?? 0.0;
    final loanTenure = userData['loanTenure'] as double? ?? 0.0;
    final loanStatus = userData['loanStatus'] as String? ?? 'No Loan';
    final loanRequestDate = userData['loanRequestDate'] as Timestamp?;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'User Details',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteUser(context),
          ),
        ],
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
                  _buildSectionTitle('Personal Information'),
                  _buildInfoCard(
                    context,
                    [
                      _buildInfoRow(Icons.phone, 'Phone', phone),
                      _buildInfoRow(Icons.location_on, 'Address', address),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Registered',
                        createdAt != null
                            ? DateFormat('MMMM d, y').format(createdAt.toDate())
                            : 'Unknown',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (hasLoanRequest) ...[
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
                          loanRequestDate != null
                              ? DateFormat('MMMM d, y').format(loanRequestDate.toDate())
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
                  ],
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