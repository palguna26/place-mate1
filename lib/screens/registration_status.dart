import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registration Status")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("registrations").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var registrations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              var registration = registrations[index];
              return ListTile(
                title: Text(registration["company"]),
                subtitle: Text("Status: ${registration["status"]}"),
              );
            },
          );
        },
      ),
    );
  }
}
