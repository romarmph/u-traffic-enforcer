import '../../config/utils/exports.dart';

class TicketPreview extends ConsumerStatefulWidget {
  const TicketPreview({super.key});

  @override
  ConsumerState<TicketPreview> createState() => _TicketPreviewState();
}

class _TicketPreviewState extends ConsumerState<TicketPreview>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool _isSaving = false;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(USpace.space8),
      color: UColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info),
              SizedBox(width: USpace.space12),
              Flexible(
                child: Text(
                  "Please make sure that all details are correct and was checked by the driver before saving.",
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          const SizedBox(height: USpace.space12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                goSignaturePad();
              },
              icon: const Icon(Icons.create_rounded),
              label: const Text("Sign Ticket"),
            ),
          ),
          const SizedBox(height: USpace.space12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: USpace.space16),
              Expanded(
                child: AbsorbPointer(
                  absorbing: _isSaving,
                  child: ElevatedButton(
                    style: _isSaving
                        ? ElevatedButton.styleFrom(
                            backgroundColor: UColors.gray400,
                          )
                        : null,
                    onPressed: _showDialog,
                    child: Text(_isSaving ? "Saving..." : "Save Ticket"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDialog() async {
    final form = ref.watch(createTicketFormProvider);

    final evidence = ref.watch(evidenceChangeNotifierProvider);

    final signature =
        evidence.evidences.where((element) => element.id == "signature");

    if (!form.isDriverNotPresent) {
      if (signature.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Signature not found",
          text: "Please have the driver to sign the ticket.",
        );
        return;
      }
    }

    final value = await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: "Save Ticket",
      text:
          "Once save it cannot be edited anymore.\nAre you sure the ticket is correct?",
      confirmBtnText: "Yes, save",
      showCancelBtn: true,
      cancelBtnText: "No, cancel",
      barrierDismissible: true,
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
    );

    if (value == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await saveTicket();

    setState(() {
      _isSaving = false;
    });
  }

  Future<void> saveTicket() async {
    final evidenceProvider = ref.watch(evidenceChangeNotifierProvider);
    final ticketProvider = ref.watch(ticketChangeNotifierProvider);
    final violationProvider = ref.watch(violationsListProvider);

    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Saving ticket...',
        barrierDismissible: false);
    double totalFine = 0;

    for (var violation in ticketProvider.ticket.issuedViolations) {
      totalFine = violation.fine + totalFine;
    }

    Ticket ticket = ticketProvider.ticket.copyWith(
      totalFine: totalFine,
    );

    final futureTicket = await TicketDBHelper.instance.createTicket(ticket);
    final storageService = StorageService.instance;

    final uploadStatus = await storageService.uploadEvidence(
      evidenceProvider.evidences,
      futureTicket.ticketNumber!,
    );

    if (uploadStatus) {
      _showUploadSucessDialog();
    } else {
      _showUploadFailedDialog();
    }

    popCurrent();

    _showSaveSuccessDialog(futureTicket);
  }

  void _showUploadSucessDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: "Image uploaded successfully.",
      barrierDismissible: false,
    );
  }

  void _showUploadFailedDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: "Image upload failed.",
      barrierDismissible: false,
    );
  }

  void _showSaveSuccessDialog(Ticket ticket) async {
    ref.watch(ticketChangeNotifierProvider).updateTicket(ticket);

    await QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      barrierDismissible: false,
      onConfirmBtnTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/printer/',
          (route) => route.isFirst,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Details"),
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs: _buildTabs(),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _driverDetails(),
                _vehicleDetails(),
                _buildViolationsView(),
                _buildEvidences(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  List<Widget> _buildTabs() {
    return const <Widget>[
      Tab(
        text: "Driver Detials",
      ),
      Tab(
        text: "Vehicle Detials",
      ),
      Tab(
        text: "Violations",
      ),
      Tab(
        text: "Images",
      ),
    ];
  }

  Widget _buildEvidences() {
    final evidenceProvider = ref.watch(evidenceChangeNotifierProvider);

    if (evidenceProvider.evidences.isEmpty ||
        evidenceProvider.evidences
            .where((element) => element.id == "signature")
            .isEmpty) {
      return const Center(
        child: Text("No images found."),
      );
    }

    return ListView.separated(
      itemCount: evidenceProvider.evidences.length,
      itemBuilder: (context, index) {
        final evidence = evidenceProvider.evidences[index];

        return EvidenceCard(
          isPreview: true,
          evidence: evidence,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: USpace.space12,
        );
      },
    );
  }

  Widget _buildViolationsView() {
    final issuedViolations =
        ref.watch(ticketChangeNotifierProvider).ticket.issuedViolations;
    final violations = ref.watch(violationsListProvider);
    return ListView.builder(
      itemCount: issuedViolations.length,
      itemBuilder: (context, index) {
        final IssuedViolation violation = issuedViolations[index];

        final name = violations
            .where((element) => element.id == violation.violationID)
            .first
            .name;

        return ListTile(
          title: Text(name),
          trailing: Text(
            violation.fine.toString(),
            style: const TextStyle(
              color: UColors.red400,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          titleTextStyle: const TextStyle(
            color: UColors.gray600,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _driverDetails() {
    final ticket = ref.watch(ticketChangeNotifierProvider).ticket;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PreviewListTile(
              title: ticket.licenseNumber.replaceNull,
              subtitle: 'License Number',
            ),
            PreviewListTile(
              title: ticket.driverName.replaceNull,
              subtitle: 'Driver Name',
            ),
            PreviewListTile(
              title: ticket.birthDate != null
                  ? ticket.birthDate!.toAmericanDate
                  : "N/A",
              subtitle: 'Birthdate',
            ),
            PreviewListTile(
              title: ticket.address.replaceNull,
              subtitle: 'Address',
            ),
            PreviewListTile(
              title: ticket.phone.replaceNull,
              subtitle: 'Phone Number',
            ),
            PreviewListTile(
              title: ticket.email.replaceNull,
              subtitle: 'Email Address',
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleDetails() {
    final ticket = ref.watch(ticketChangeNotifierProvider).ticket;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(USpace.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PreviewListTile(
              title: ticket.vehicleTypeName,
              subtitle: 'Vehicle Type',
            ),
            PreviewListTile(
              title: ticket.plateNumber.replaceNull,
              subtitle: 'Plate Number',
            ),
            PreviewListTile(
              title: ticket.engineNumber.replaceNull,
              subtitle: 'Engine Number',
            ),
            PreviewListTile(
              title: ticket.chassisNumber.replaceNull,
              subtitle: 'Chassis Number',
            ),
            // Vehicle owner
            PreviewListTile(
              title: ticket.vehicleOwner.replaceNull,
              subtitle: 'Vehicle Owner Name',
            ),
            PreviewListTile(
              title: ticket.vehicleOwnerAddress.replaceNull,
              subtitle: 'Vehicle Owner Address',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> renameAndUpload(String oldPath, String newName) async {
    final newFile = ImagePickerService.instance.rename(
      oldPath,
      newName,
    );

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('licenseImage/$newName.jpg');

    UploadTask uploadTask = ref.putFile(newFile);

    try {
      await uploadTask;

      return true;
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      return false;
    }
  }
}
