import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/themes/colors.dart';
import '../../config/themes/spacing.dart';
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
    final provider = Provider.of<TicketProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("License Preview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.file(
                File(provider.getTicket.licenseImageUrl!),
              ),
            ),
            const SizedBox(height: USpace.space16),
            ElevatedButton.icon(
              onPressed: retakeBtnPressed,
              label: const Text("Retake"),
              icon: const Icon(Icons.repeat_rounded),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(USpace.space12),
      color: UColors.white,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: USpace.space16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/ticket/create");
              },
              child: const Text("Next"),
            ),
          ),
        ],
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

  void retakeBtnPressed() async {
    final provider = Provider.of<TicketProvider>(context);
    final image = await ImagePickerService.instance.pickImage();

    if (image == null) {
      showNoImagePickError();
      return;
    }

    final croppedImage = await ImagePickerService.instance.cropImage(image);

    if (croppedImage == null) {
      showNoImagePickError();
      return;
    }

    // provider.setLicenseImagePath(croppedImage.path);
  }
}
