import 'package:cloud_firestore/cloud_firestore.dart';

class InsuranceServices {
  CollectionReference insurances =
      FirebaseFirestore.instance.collection('insurance');

  Future<void> updateOrderStatus(documentId, status) {
    var result = insurances.doc(documentId).update({
      // update the status
      'applicationStatus': status
    });

    return result;
  }
}
