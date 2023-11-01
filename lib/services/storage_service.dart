import '../config/utils/exports.dart';

class StorageService {
  StorageService._();

  static StorageService get instance => StorageService._();

  final _storageReference = FirebaseStorage.instance.ref();

  Future<Uint8List?> fetchProfileImage(String uid) async {
    final Reference profileImagesRef =
        _storageReference.child("$profileImage/$uid.png");

    const oneMegabyte = 1024 * 1024;
    try {
      final Uint8List? data = await profileImagesRef.getData(oneMegabyte);
      return data;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        print("The requested file doesn't exist.");
      } else if (e.code == 'unauthenticated') {
        print('The user is not authenticated.');
      } else {
        print('An unknown error occurred.');
      }
      rethrow;
    }
  }

  Future<bool> uploadEvidence(
      List<Evidence> evidences, int ticketNumber) async {
    final firestore = FirebaseFirestore.instance;
    const evidenceRoot = "ticket-evidences";

    try {
      for (Evidence evidence in evidences) {
        final Reference evidenceRef = _storageReference.child(
          "$evidenceRoot/$ticketNumber/${evidence.name}.png",
        );
        firestore.collection("evidences").add(
              evidence
                  .copyWith(
                    ticketNumber: ticketNumber,
                  )
                  .toJson(),
            );

        await evidenceRef.putFile(File(evidence.path));
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Evidence>> fetchEvidences(int ticketNumber) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final evidences = await firestore
          .collection("evidences")
          .where("ticketNumber", isEqualTo: ticketNumber)
          .get();

      final List<Evidence> evidenceList = [];

      for (final evidence in evidences.docs) {
        evidenceList.add(Evidence.fromMap(evidence.data(), evidence.id));
      }

      return evidenceList;
    } catch (e) {
      rethrow;
    }
  }
}
