import '../../config/utils/exports.dart';

class TicketPreview extends StatefulWidget {
  const TicketPreview({super.key});

  @override
  State<TicketPreview> createState() => _TicketPreviewState();
}

class _TicketPreviewState extends State<TicketPreview>
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
    final form = Provider.of<CreateTicketFormNotifier>(context, listen: false);

    final evidenceProvider = Provider.of<EvidenceProvider>(
      context,
      listen: false,
    );

    final signature = evidenceProvider.evidences
        .where((element) => element.id == "signature");

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
    final evidenceProvider = Provider.of<EvidenceProvider>(
      context,
      listen: false,
    );
    final ticketProvider = Provider.of<TicketProvider>(
      context,
      listen: false,
    );

    final violationsProvider = Provider.of<ViolationProvider>(
      context,
      listen: false,
    );

    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Saving ticket...',
        barrierDismissible: false);
    double totalFine = 0;
    final temp = ticketProvider.ticket;

    for (var violation in violationsProvider.getViolations) {
      if (temp.violationsID.contains(violation.id)) {
        totalFine += violation.fine;
      }
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
    Provider.of<TicketProvider>(context, listen: false).updateTicket(ticket);

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
      body: Consumer<CreateTicketFormNotifier>(
        builder: (context, form, child) {
          return Column(
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
                    Consumer<EvidenceProvider>(
                      builder: (context, provider, child) {
                        if (provider.evidences.isEmpty) {
                          return const Center(
                            child: Text("No signature found."),
                          );
                        }
                        return ListView.separated(
                          itemCount: provider.evidences.length,
                          itemBuilder: (context, index) {
                            final evidence = provider.evidences[index];

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
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        },
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

  Widget _buildViolationsView() {
    return Consumer<ViolationProvider>(
      builder: (context, value, child) {
        final List<Violation> selected =
            value.getViolations.where((element) => element.isSelected).toList();

        return ListView.builder(
          itemCount: selected.length,
          itemBuilder: (context, index) {
            final Violation violation = selected[index];

            return ListTile(
              title: Text(violation.name),
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
      },
    );
  }

  Widget _driverDetails() {
    final ticket = Provider.of<TicketProvider>(context, listen: false).ticket;
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
    final ticket = Provider.of<TicketProvider>(context, listen: false).ticket;
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
