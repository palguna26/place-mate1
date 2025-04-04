import 'package:cloud_firestore/cloud_firestore.dart';

class PlacementModel {
  final String id;
  final String company;
  final DateTime deadline;
  final DateTime testDate;
  final String description;
  final bool isRegistered;

  PlacementModel({
    required this.id,
    required this.company,
    required this.deadline,
    required this.testDate,
    required this.description,
    this.isRegistered = false,
  });

  factory PlacementModel.fromMap(Map<String, dynamic> map, String docId) {
    return PlacementModel(
      id: docId,
      company: map['company'] ?? '',
      deadline: (map['deadline'] as Timestamp).toDate(),
      testDate: (map['testDate'] as Timestamp).toDate(),
      description: map['description'] ?? '',
      isRegistered: map['isRegistered'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'deadline': deadline,
      'testDate': testDate,
      'description': description,
      'isRegistered': isRegistered,
    };
  }
}
