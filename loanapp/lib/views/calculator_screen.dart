import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../views/home_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double loanAmount = 500000;
  double interestRate = 10;
  int tenure = 10;

  double calculateEMI() {
    double monthlyRate = interestRate / 12 / 100;
    int totalMonths = tenure * 12;
    return loanAmount *
        monthlyRate *
        pow(1 + monthlyRate, totalMonths) /
        (pow(1 + monthlyRate, totalMonths) - 1);
  }

  @override
  Widget build(BuildContext context) {
    double monthlyEMI = calculateEMI();
    double totalPayment = monthlyEMI * tenure * 12;
    double totalInterest = totalPayment - loanAmount;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EMI Calculator'),
          backgroundColor: const Color(0xFF5F5ED2),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildSlider('Loan Amount (₹)', loanAmount, 100000, 1000000,
                  (value) {
                setState(() {
                  loanAmount = value;
                });
              }),
              buildSlider('Interest Rate (%)', interestRate, 1, 30, (value) {
                setState(() => interestRate = value);
              }),
              buildSlider('Tenure (Years)', tenure.toDouble(), 1, 30, (value) {
                setState(() {
                  tenure = value.toInt();
                });
              }),
              const SizedBox(height: 30),
              const Text(
                'Breakdown',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: loanAmount,
                        color: Colors.teal,
                        title: 'Principal',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: totalInterest,
                        color: Colors.orangeAccent,
                        title: 'Interest',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        showTitle: true,
                      ),
                    ],
                    sectionsSpace: 5,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildInfoCard('Monthly EMI', '₹${monthlyEMI.toStringAsFixed(2)}'),
              _buildInfoCard(
                  'Principal Amount', '₹${loanAmount.toStringAsFixed(0)}'),
              _buildInfoCard(
                  'Total Interest', '₹${totalInterest.toStringAsFixed(2)}'),
              _buildInfoCard(
                  'Total Payment', '₹${totalPayment.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    final isTenure = label.contains("Tenure");
    final isLoanAmount = label.contains("Loan Amount");

    int? divisions;
    if (isLoanAmount) {
      divisions = ((max - min) / 50000).round();
    } else if (isTenure) {
      divisions = (max - min).round();
    } else {
      divisions = 100;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${isTenure ? value.toInt() : value.toStringAsFixed(1)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label:
                isTenure ? value.toInt().toString() : value.toStringAsFixed(0),
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(title, style: TextStyle(color: Colors.grey[700])),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
