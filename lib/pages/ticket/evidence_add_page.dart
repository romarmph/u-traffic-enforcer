import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EvidenceAddPage extends ConsumerStatefulWidget {
  const EvidenceAddPage({super.key});

  @override
  ConsumerState<EvidenceAddPage> createState() => _EvidenceAddPageState();
}

class _EvidenceAddPageState extends ConsumerState<EvidenceAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  File _file = File('');

  void takeImage() async {
    final image = await ImagePickerService.instance.pickImage();

    if (image == null) {
      return;
    }

    setState(() => _file = File(image.path));
  }

  @override
  Widget build(BuildContext context) {
    final evidences = ref.watch(evidenceListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Evidence"),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(USpace.space16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  minLines: 1,
                  maxLines: 3,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                  ),
                ),
                const SizedBox(
                  height: USpace.space16,
                ),
                GestureDetector(
                  onTap: _file.existsSync() ? null : takeImage,
                  child: _buildImage(),
                ),
                const SizedBox(
                  height: USpace.space8,
                ),
                _buildRemoveAndRetakeButtons(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
                onPressed: () {
                  if (!_file.existsSync()) {
                    _showNoImageError();
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    final evidenceProvider = ref.watch(evidenceListProvider);

                    final isExisting = evidenceProvider
                        .where((element) => element.path == _file.path)
                        .isNotEmpty;

                    if (isExisting) {
                      QuickAlert.show(
                        context: context,
                        title: "Existing Evidence",
                        text: "This evidence already exists",
                        type: QuickAlertType.error,
                      );
                      return;
                    }

                    final isNameUsed = evidenceProvider
                        .where((element) =>
                            element.name.toLowerCase() ==
                            _nameController.text.toLowerCase())
                        .isNotEmpty;

                    if (isNameUsed) {
                      QuickAlert.show(
                        context: context,
                        title: "Name Used",
                        text: "This name is already used",
                        type: QuickAlertType.error,
                      );
                      return;
                    }

                    ref.read(evidenceListProvider.notifier).state = [
                      ...evidenceProvider,
                      Evidence(
                        id: DateTime.now().toString(),
                        name: _nameController.text,
                        description: _descriptionController.text,
                        path: _file.path,
                      ),
                    ];

                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Save Evidence"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoImageError() {
    QuickAlert.show(
      context: context,
      title: "No Image",
      text: "Please take an image first",
      type: QuickAlertType.error,
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
          color: UColors.gray300,
          width: 1,
        ),
      ),
      child: _file.existsSync()
          ? Image.file(
              _file,
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
    return _file.existsSync()
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
                  onPressed: () => setState(() => _file = File("")),
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
