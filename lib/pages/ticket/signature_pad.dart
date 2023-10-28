import 'dart:ui' as ui;
import 'package:u_traffic_enforcer/services/signature.dart';

import '../../config/utils/exports.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final _signaturePadKey = GlobalKey<SfSignaturePadState>();
  EvidenceProvider _evidenceProvider = EvidenceProvider();

  @override
  void initState() {
    super.initState();
    _evidenceProvider = Provider.of<EvidenceProvider>(
      context,
      listen: false,
    );

    final signatureImage = _evidenceProvider.evidences
        .where((element) => element.id == "signature");

    if (signatureImage.isNotEmpty) {
      SignatureServices().deleteFile(
        File(
          signatureImage.first.path,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Ticket'),
        actions: [
          IconButton(
            onPressed: () {
              _signaturePadKey.currentState!.clear();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SfSignaturePad(
        key: _signaturePadKey,
        backgroundColor: UColors.gray50,
        strokeColor: UColors.black,
      ),
      bottomNavigationBar: Container(
        color: UColors.white,
        padding: const EdgeInsets.all(USpace.space12),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  ui.Image image =
                      await _signaturePadKey.currentState!.toImage();
                  File file = await SignatureServices().saveImage(image);

                  _evidenceProvider.addEvidence(
                    Evidence(
                      id: 'signature',
                      name: "Driver Signature",
                      path: file.path,
                    ),
                  );

                  popCurrent();
                },
                child: const Text('Save Signature'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
