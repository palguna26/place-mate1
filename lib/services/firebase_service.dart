import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<void> registerForPlacement(String phone) async {
    final HttpsCallable callable = functions.httpsCallable('makeCall');
    await callable.call({"phone": phone});
  }
}

