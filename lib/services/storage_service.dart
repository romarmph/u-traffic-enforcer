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
}
