import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> company;
  final String companyId;

  const CompanyDetailsScreen({
    Key? key,
    required this.company,
    required this.companyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = company['details'] ?? {};
    
    return Scaffold(
      appBar: AppBar(
        title: Text(company['name'] ?? 'Company Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            SizedBox(height: 16),
            _buildDetailsCard(details),
            SizedBox(height: 16),
            _buildCutoffsCard(details),
            SizedBox(height: 16),
            _buildDatesCard(details),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: company['registered'] == true ? Colors.green : Colors.grey,
              size: 36,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    company['registered'] == true ? 'Registered' : 'Not Registered',
                    style: TextStyle(
                      fontSize: 18,
                      color: company['registered'] == true ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(Map<String, dynamic> details) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Compensation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Intern Stipend', details['internStipend'] ?? 'N/A'),
            _buildDetailRow('Fulltime CTC', details['fulltimeCTC'] ?? 'N/A'),
            _buildDetailRow('Backlogs Allowed', details['backlogsAllowed'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildCutoffsCard(Map<String, dynamic> details) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eligibility Criteria',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('10th Cutoff', details['cutoff10th'] ?? 'N/A'),
            _buildDetailRow('12th Cutoff', details['cutoff12th'] ?? 'N/A'),
            _buildDetailRow('BE Cutoff', details['cutoffBE'] ?? 'N/A'),
            _buildDetailRow('PG Cutoff', details['cutoffPG'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesCard(Map<String, dynamic> details) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Important Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Registration Deadline', details['deadline'] ?? 'N/A'),
            _buildDetailRow('Drive Date', details['date'] ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}