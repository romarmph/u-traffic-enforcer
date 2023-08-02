import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_traffic_enforcer/config/themes/spacing.dart';

import '../../providers/ticket_provider.dart';
import '../../services/image_picker.dart';

class ScannedLicensePreview extends StatefulWidget {
  const ScannedLicensePreview({super.key});

  @override
  State<ScannedLicensePreview> createState() => _ScannedLicensePreviewState();
}

class _ScannedLicensePreviewState extends State<ScannedLicensePreview> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(USpace.space16),
          child: Column(
            children: [
              Image.file(
                File(provider.getTicket.licenseImageUrl!),
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await ImagePickerService.instance.pickImage();

                  if (image == null) {
                    showNoImagePickError();
                    return;
                  }

                  final croppedImage =
                      await ImagePickerService.instance.cropImage(image);

                  if (croppedImage == null) {
                    showNoImagePickError();
                    return;
                  }

                  provider.setLicenseImagePath(croppedImage.path);
                },
                child: const Text("Retake"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNoImagePickError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No image picked"),
      ),
    );
  }
}
