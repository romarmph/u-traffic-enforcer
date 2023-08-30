import 'dart:io';

import '../../../config/utils/exports.dart';

class ImageScannerButton extends StatefulWidget {
  const ImageScannerButton({
    super.key,
  });

  @override
  State<ImageScannerButton> createState() => _ImageScannerButtonState();
}

class _ImageScannerButtonState extends State<ImageScannerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: UColors.gray100,
            borderRadius: BorderRadius.circular(
              USpace.space12,
            ),
            border: Border.all(
              color: UColors.gray200,
              width: 2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Center(
            child: Consumer<CreateTicketFormNotifier>(
              builder: (context, form, widget) {
                if (form.licenseImagePath.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: UColors.gray400,
                        size: 48,
                      ),
                      SizedBox(height: USpace.space12),
                      Text(
                        "Tap here to scan license",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: UColors.gray400,
                        ),
                      )
                    ],
                  );
                }
                return Image.file(
                  File(form.licenseImagePath),
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void onTap(BuildContext context) async {
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    final XFile? image = await ImagePickerService.instance.pickImage();

    if (image == null) {
      showError(
        "Please capture a license image.",
        "Error!",
      );
      return;
    }

    final CroppedFile? cropped =
        await ImagePickerService.instance.cropImage(image);

    if (cropped == null) {
      showError(
        "Please save the image after cropping.",
        "Error!",
      );
      return;
    }
    form.setLicenseImagePath(cropped.path);
  }

  void showError(
    String message,
    String title,
  ) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: message,
      title: title,
    );
  }
}
