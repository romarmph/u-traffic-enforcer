// import '../../../config/utils/exports.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// class QRCodeScanner extends StatelessWidget {
//   const QRCodeScanner({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('QR Code Scanner'),
//       ),
//       body: QRCodeDartScanView(
//         typeCamera: TypeCamera.back,
//         typeScan: TypeScan.takePicture,
//         onCapture: (Result data) async {
//           print(data);
//           try {
//             final licenseNumber = data.toString().split(':')[0];
//             final uid = data.toString().split(':')[1];

//             await FirebaseFirestore.instance
//                 .collection('licenses')
//                 .where('userID', isEqualTo: uid)
//                 .where('licenseNumber', isEqualTo: licenseNumber)
//                 .get()
//                 .then(
//               (value) {
//                 final license = LicenseDetails.fromJson(
//                   value.docs.first.data(),
//                 );

//                 goCreateTicket(context, license);
//               },
//             );
//           } catch (e) {
//             print(e);
//           }
//         },
//       ),
//     );
//   }

//   void goCreateTicket(BuildContext context, LicenseDetails licenseDetails) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => CreateTicketPage(
//           licenseDetail: licenseDetails,
//         ),
//       ),
//     );
//   }
// }
