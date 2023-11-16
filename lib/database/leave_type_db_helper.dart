import 'package:u_traffic_enforcer/config/utils/exports.dart';

class LeaveTypeDBHelper {
  const LeaveTypeDBHelper._();

  static const LeaveTypeDBHelper _instance = LeaveTypeDBHelper._();

  static LeaveTypeDBHelper get instance => _instance;

  Stream<List<LeaveType>> getLeaveTypes() {
    final firestore = FirebaseFirestore.instance;

    return firestore
        .collection("leave-types")
        .orderBy("type", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return LeaveType.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    });
  }
}
