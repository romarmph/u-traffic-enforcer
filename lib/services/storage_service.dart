import '../config/utils/exports.dart';

class StorageService {
  StorageService._();

  static StorageService get instance => StorageService._();

  final _storageReference = FirebaseStorage.instance.ref();

  Future<bool> uploadEvidence(
    List<Evidence> evidences,
    int ticketNumber,
  ) async {
    final firestore = FirebaseFirestore.instance;
    const evidenceRoot = "ticket-evidences";

    try {
      for (Evidence evidence in evidences) {
        print(evidence.name);
        print(evidence.path);
        final Reference evidenceRef = _storageReference.child(
          "$evidenceRoot/$ticketNumber/${evidence.name}.png",
        );

        await evidenceRef.putFile(File(evidence.path));

        final path = await evidenceRef.getDownloadURL();
        firestore.collection("evidences").add(
              evidence
                  .copyWith(
                    ticketNumber: ticketNumber,
                    path: path,
                  )
                  .toJson(),
            );
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
