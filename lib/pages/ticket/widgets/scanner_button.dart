import 'package:u_traffic_enforcer/services/license_scan_services.dart';

import '../../../config/utils/exports.dart';

class ImageScannerButton extends ConsumerStatefulWidget {
  const ImageScannerButton({
    super.key,
  });

  @override
  ConsumerState<ImageScannerButton> createState() => _ImageScannerButtonState();
}

class _ImageScannerButtonState extends ConsumerState<ImageScannerButton> {
  @override
  Widget build(BuildContext context) {
    final form = ref.watch(createTicketFormProvider);

    return GestureDetector(
      onTap: () async {
        if (form.isDriverNotPresent) return;

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
            child: _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageProvider = ref.watch(licenseImageProvider);

    if (imageProvider.licenseImagePath.isEmpty) {
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
        File(imageProvider.licenseImagePath),
        fit: BoxFit.contain,
      ),
    );
  }

  Future<void> onTap() async {
    final imageProvider = ref.watch(licenseImageProvider);

    final scanDetailsProvider = ref.watch(scannedDetailsProvider);
    final evidenceProvider = ref.watch(evidenceChangeNotifierProvider);

    showLoading(
      'Scanning License',
    );
    final XFile? image = await ImagePickerService.instance.pickImage();

    if (image == null) {
      popCurrent();

      if (imageProvider.licenseImagePath.isEmpty) {
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

    evidenceProvider.removeEvidenceByID('default');

    imageProvider.setLicenseImagePath(cropped.path);
    evidenceProvider.addEvidence(
      Evidence(
        id: 'default',
        name: 'License Image - Front',
        path: cropped.path,
      ),
    );

    final scanApi = LicenseScanServices.instance;
    try {
      final data = await scanApi.sendRequest(cropped.path);

      scanDetailsProvider.setDetails(data!);

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
