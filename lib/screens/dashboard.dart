import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:place_mate/screens/registration_status.dart';
import 'package:place_mate/services/firebase_service.dart';

class Dashboard extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Placement Dashboard")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("placements").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var placements = snapshot.data!.docs;
          return ListView.builder(
            itemCount: placements.length,
            itemBuilder: (context, index) {
              var placement = placements[index];
              return ListTile(
                title: Text(placement["company"]),
                subtitle: Text("Deadline: ${placement["deadline"]}"),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await firebaseService.registerForPlacement("+1234567890");
                  },
                  child: Text("Register"),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationStatusScreen())),
        child: Icon(Icons.history),
      ),
    );
  }
}
