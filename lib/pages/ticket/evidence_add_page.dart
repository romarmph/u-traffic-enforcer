import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EvidenceAddPage extends StatefulWidget {
  const EvidenceAddPage({super.key});

  @override
  State<EvidenceAddPage> createState() => _EvidenceAddPageState();
}

class _EvidenceAddPageState extends State<EvidenceAddPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  late File file;

  void takeImage() async {
    final image = await ImagePickerService.instance.pickImage();

    if (image == null) return;

    setState(() => file = File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Evidence"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                  const SizedBox(
                    height: USpace.space16,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 1,
                    maxLines: 3,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: USpace.space16,
            ),
            GestureDetector(
              onTap: file.existsSync() ? null : takeImage,
              child: _buildImage(),
            ),
            const SizedBox(
              height: USpace.space8,
            ),
            _buildRemoveAndRetakeButtons(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Back"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {},
                    child: const Text("Save Evidence"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: UColors.gray100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: UColors.gray200,
          width: 1,
        ),
      ),
      child: file.existsSync()
          ? Image.file(
              file,
              fit: BoxFit.cover,
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: 48,
                  ),
                  Text("Take a photo"),
                ],
              ),
            ),
    );
  }

  Widget _buildRemoveAndRetakeButtons() {
    return file.existsSync()
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: UColors.red400,
                    side: const BorderSide(
                      color: UColors.red400,
                      width: 1.5,
                    ),
                  ),
                  onPressed: () => setState(() => file = File("")),
                  child: const Text("Remove"),
                ),
              ),
              const SizedBox(
                width: USpace.space8,
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: takeImage,
                  child: const Text("Retake"),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
