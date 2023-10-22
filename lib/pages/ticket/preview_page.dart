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
    final imageProvider = Provider.of<UTrafficImageProvider>(
      context,
      listen: false,
    );
    final ticketProvider = Provider.of<TicketProvider>(
      context,
      listen: false,
    );

    QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        text: 'Saving ticket...',
        barrierDismissible: false);

    Ticket ticket = ticketProvider.ticket;

    final futureTicket = await TicketDBHelper.instance.createTicket(ticket);

    if (imageProvider.licenseImagePath.isNotEmpty) {
      final uploadStatus = await renameAndUpload(
        imageProvider.licenseImagePath,
        futureTicket.id!,
      );

      if (uploadStatus) {
        _showUploadSucessDialog();
      } else {
        _showUploadFailedDialog();
      }
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
                    Consumer<UTrafficImageProvider>(
                      builder: (context, value, child) {
                        if (value.signatureImagePath.isEmpty) {
                          return const Center(
                            child: Text("No signature found."),
                          );
                        }
                        return Image.file(
                          File(value.signatureImagePath),
                          fit: BoxFit.cover,
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
              title: ticket.licenseNumber,
              subtitle: 'License Number',
            ),
            PreviewListTile(
              title: ticket.driverName,
              subtitle: 'Driver Name',
            ),
            PreviewListTile(
              title: ticket.birthDate.toAmericanDate,
              subtitle: 'Birthdate',
            ),
            PreviewListTile(
              title: ticket.address,
              subtitle: 'Address',
            ),
            PreviewListTile(
              title: ticket.phone,
              subtitle: 'Phone Number',
            ),
            PreviewListTile(
              title: ticket.email,
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
              title: ticket.vehicleTypeID,
              subtitle: 'Vehicle Type',
            ),
            PreviewListTile(
              title: ticket.plateNumber,
              subtitle: 'Plate Number',
            ),
            PreviewListTile(
              title: ticket.engineNumber,
              subtitle: 'Engine Number',
            ),
            PreviewListTile(
              title: ticket.chassisNumber,
              subtitle: 'Chassis Number',
            ),
            // Vehicle owner
            PreviewListTile(
              title: ticket.vehicleOwner,
              subtitle: 'Vehicle Owner Name',
            ),
            PreviewListTile(
              title: ticket.vehicleOwnerAddress,
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
