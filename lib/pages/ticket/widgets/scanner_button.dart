import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';
import 'package:u_traffic_enforcer/services/license_scan_services.dart';

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
      onTap: () async {
        await onTap();
      },
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Container(
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
                return ClipRRect(
                  borderRadius: BorderRadius.circular(USpace.space12),
                  child: Image.file(
                    File(form.licenseImagePath),
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTap() async {
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);
    showLoading(
      'Scanning License',
    );
    final XFile? image = await ImagePickerService.instance.pickImage();

    if (image == null) {
      popCurrent();

      if (form.licenseImagePath.isEmpty) {
        showError(
          "Please take an image of the Driver's License",
          "No License Image",
        );
      }

      return;
    }

    final CroppedFile? cropped =
        await ImagePickerService.instance.cropImage(image);

    if (cropped == null) {
      popCurrent();

      showError(
        "Please crop the image and save to continue",
        "License not cropped.",
      );
      return;
    }

    form.setLicenseImagePath(cropped.path);
    final scanApi = LicenseScanServices.instance;
    try {
      final data = await scanApi.sendRequest(cropped.path);

      if (data!['lastname'].toString().isNotEmpty) {
        form.formSettings[TicketField.lastName]!.controller!.text =
            data['lastname'];
      }

      if (data['fullname'].toString().isNotEmpty) {
        if (data['fullname'].toString().contains(',')) {
          form.formSettings[TicketField.firstName]!.controller!.text =
              data['fullname'].toString().split(',')[1];
        } else {
          form.formSettings[TicketField.firstName]!.controller!.text =
              data['fullname'];
        }
      }

      if (data['licensenumber'].toString().isNotEmpty) {
        form.formSettings[TicketField.licenseNumber]!.controller!.text =
            data['licensenumber'];
      }

      if (data['address'].toString().isNotEmpty) {
        form.formSettings[TicketField.address]!.controller!.text =
            data['address'];
      }

      if (data['birthdate'].toString().isNotEmpty) {
        form.formSettings[TicketField.birthDate]!.controller!.text =
            data['birthdate'].toString().split(' ').first.formtDate;
      }

      popCurrent();
      showSuccess();
    } catch (e) {
      if (e.toString().contains('error-occured-while-sending-request')) {
        popCurrent();

        showError(
          "Please check your internet connection.",
          "An error occured",
        );
      } else if (e.toString().contains('failed-to-send-request')) {
        showError(
          "Please try again.",
          "Unable to connect",
        );
      } else {
        showError(
          "Unknown error occured please contact your system administrator",
          "FATAL",
        );
      }
    }
  }

  void showLoading([String? title = '', String? text = '']) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: text,
      title: title,
    );
  }

  void showSuccess() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
    );
  }

  void showError(
    String text,
    String title,
  ) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: text,
      title: title,
    );
  }
}
