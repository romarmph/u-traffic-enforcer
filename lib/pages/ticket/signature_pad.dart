import 'dart:ui' as ui;
import 'package:u_traffic_enforcer/services/signature.dart';

import '../../config/utils/exports.dart';

class SignaturePad extends ConsumerStatefulWidget {
  const SignaturePad({super.key});

  @override
  ConsumerState<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends ConsumerState<SignaturePad> {
  final _signaturePadKey = GlobalKey<SfSignaturePadState>();

  @override
  Widget build(BuildContext context) {
    final evidenceProvider = ref.watch(evidenceListProvider);

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

                  ref.read(evidenceListProvider.notifier).state = [
                    ...evidenceProvider,
                    Evidence(
                      id: "signature",
                      name: "Signature",
                      path: file.path,
                    ),
                  ];

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
