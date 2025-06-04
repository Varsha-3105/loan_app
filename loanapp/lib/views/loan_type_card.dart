import 'package:flutter/material.dart';
import '../model/loan_type_model.dart';
// import '/screens/personal_information_screen.dart';


class LoanTypeCard extends StatelessWidget {
  final LoanType loanType;
  final VoidCallback onTap;

  const LoanTypeCard({required this.loanType, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: loanType.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(loanType.icon, size: 40, color: Colors.black),
              const SizedBox(height: 10),
              Text(
                loanType.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
