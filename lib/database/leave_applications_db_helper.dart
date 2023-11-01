// import 'package:u_traffic_enforcer/config/utils/exports.dart';

// class LeaveApplicationsDBHelper {
//   const LeaveApplicationsDBHelper._();

//   static const LeaveApplicationsDBHelper _instance =
//       LeaveApplicationsDBHelper._();

//   static LeaveApplicationsDBHelper get instance => _instance;

//   Stream<List<LeaveApplication>> getLeaveApplications() {
//     final firestore = FirebaseFirestore.instance;

//     return firestore
//         .collection("leave-applications")
//         .orderBy("createdAt", descending: true)
//         .snapshots()
//         .map((snapshot) {
//       return snapshot.docs.map((doc) {
//         return LeaveApplication.fromJson(doc.data()).copyWith(id: doc.id);
//       }).toList();
//     });
//   }

//   Future<void> addLeaveApplication(LeaveApplication leaveApplication) async {
//     final firestore = FirebaseFirestore.instance;

//     await firestore
//         .collection("leave-applications")
//         .add(leaveApplication.toJson());
//   }

//   Future<void> updateLeaveApplication(LeaveApplication leaveApplication) async {
//     final firestore = FirebaseFirestore.instance;

//     await firestore
//         .collection("leave-applications")
//         .doc(leaveApplication.id)
//         .update(leaveApplication.toJson());
//   }

//   Future<void> deleteLeaveApplication(String id) async {
//     final firestore = FirebaseFirestore.instance;

//     await firestore.collection("leave-applications").doc(id).delete();
//   }
// }
