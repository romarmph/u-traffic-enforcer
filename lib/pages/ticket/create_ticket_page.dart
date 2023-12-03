import '../../../config/utils/exports.dart';

final scanFinishFlagProvider = StateProvider<bool>((ref) => false);

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({
    super.key,
    this.qrDetails,
  });

  final QRDetails? qrDetails;

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _driverFormKey = GlobalKey<FormState>();
  final _vehicleFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _vehicleOwnerController = TextEditingController();
  final _vehicleOwnerAddressController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _conductionController = TextEditingController();

  bool isScrollable = false;
  String _cancelButtonText = "Cancel";

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      initialIndex: 0,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          _cancelButtonText = "Cancel";
        });
      } else {
        setState(() {
          _cancelButtonText = "Back";
        });
      }
    });

    if (widget.qrDetails != null) {
      _nameController.text = widget.qrDetails!.driverName;
      _addressController.text = widget.qrDetails!.address;
      _phoneController.text = widget.qrDetails!.phone ?? "";
      _emailController.text = widget.qrDetails!.email ?? "";
      _licenseNumberController.text = widget.qrDetails!.licenseNumber;
      _birthDateController.text = widget.qrDetails!.birthDate;
    }
  }

  void clearField() {
    _nameController.clear();
    _addressController.clear();
    _phoneController.clear();
    _emailController.clear();
    _licenseNumberController.clear();
    _birthDateController.clear();
    _plateNumberController.clear();
    _engineNumberController.clear();
    _chassisNumberController.clear();
    _vehicleOwnerController.clear();
    _vehicleOwnerAddressController.clear();
    _vehicleTypeController.clear();
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(scannedDetailsProvider);


    if (details.details.isNotEmpty) {
      _nameController.text = details.details['fullname'] ?? "";
      _addressController.text = details.details['address'] ?? "";

      _licenseNumberController.text = details.details['licensenumber'] ?? "";
      _birthDateController.text =
          _parseScannedDate(details.details['birthdate']);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(scannedDetailsProvider).clearDetails();
      });
    }
    return WillPopScope(
      onWillPop: _showCancelConfirm,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Ticket"),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildTabs(),
              SizedBox(
                height: constraints.maxHeight - 64,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    KeepAliveWrapper(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(USpace.space16),
                          child: Form(
                            key: _driverFormKey,
                            child: DriverDetailsForm(
                              nameController: _nameController,
                              addressController: _addressController,
                              phoneController: _phoneController,
                              emailController: _emailController,
                              licenseNumberController: _licenseNumberController,
                              birthDateController: _birthDateController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    KeepAliveWrapper(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(USpace.space16),
                          child: Form(
                            key: _vehicleFormKey,
                            child: VehiecleDetailsForm(
                              conductionController: _conductionController,
                              plateNumberController: _plateNumberController,
                              engineNumberController: _engineNumberController,
                              chassisNumberController: _chassisNumberController,
                              vehicleOwnerController: _vehicleOwnerController,
                              vehicleOwnerAddressController:
                                  _vehicleOwnerAddressController,
                              vehicleTypeController: _vehicleTypeController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    KeepAliveWrapper(
                      child: Container(
                        color: UColors.gray100,
                        padding: const EdgeInsets.all(USpace.space16),
                        child: const EvidenceForm(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
        bottomNavigationBar: _buildActionButtons(),
      ),
    );
  }

  String _parseScannedDate(var date) {
    if (date.runtimeType == DateTime) {
      return date.toString().split(' ')[0];
    }

    try {
      final parsedDate = DateTime.parse(date);
      return parsedDate.toString().split(' ')[0];
    } catch (e) {
      return "";
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(USpace.space12),
      decoration: const BoxDecoration(
        color: UColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(USpace.space24),
          topRight: Radius.circular(USpace.space24),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset.zero,
            blurRadius: 4,
            blurStyle: BlurStyle.outer,
            color: UColors.gray200,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: _handleBackButtonClick,
              child: Text(_cancelButtonText),
            ),
          ),
          const SizedBox(width: USpace.space16),
          Expanded(
            child: ElevatedButton(
              onPressed: _handleNextButtonClick(),
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 64,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: "Driver Details"),
          Tab(text: "Vehicle Details"),
          Tab(text: "Evidences"),
        ],
      ),
    );
  }

  bool _isDriverFormValid() {
    final form = ref.watch(createTicketFormProvider);
    final licenseImage = ref.watch(licenseImageProvider);

    if (!form.isDriverNotPresent &&
        licenseImage.licenseImagePath.isEmpty &&
        !form.hasNoLicense) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "License Image",
        text: "Please add a license image",
      );

      return false;
    }

    if (form.isDriverNotPresent) {
      return true;
    }

    return _driverFormKey.currentState!.validate();
  }

  bool _isVehicleFormValid() {
    if (_plateNumberController.text.isEmpty &&
        _engineNumberController.text.isEmpty &&
        _chassisNumberController.text.isEmpty &&
        _conductionController.text.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Vehicle Identity",
        text: "Please add at least one of the following: \n"
            "Plate Number, Engine Number, Chassis Number, Conduction Sticker or File Number",
      );
      return false;
    }

    return _vehicleFormKey.currentState!.validate();
  }

  void _handleBackButtonClick() async {
    if (_tabController.index == 0) {
      await _showCancelConfirm();
    } else if (_tabController.index == 1) {
      _tabController.animateTo(0);
    } else {
      _tabController.animateTo(1);
    }
  }

  void Function()? _handleNextButtonClick() {
    if (_tabController.index == 0) {
      return () {
        if (_isDriverFormValid()) {
          _tabController.animateTo(1);
        } else {
          return;
        }
      };
    }

    if (_tabController.index == 1) {
      return () {
        if (!_isDriverFormValid()) {
          _tabController.animateTo(0);
          return;
        }

        if (_isVehicleFormValid()) {
          _tabController.animateTo(2);
        } else {
          return;
        }
      };
    }

    return () {
      final evidenceProvider = ref.watch(evidenceListProvider);

      if (!_isDriverFormValid()) {
        _tabController.animateTo(0);
        return;
      }
      if (!_isVehicleFormValid()) {
        _tabController.animateTo(1);
        return;
      }

      if (evidenceProvider.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Evidences",
          text: "Please add at least one evidence",
        );
        return;
      }

      _selectViolation();
    };
  }

  void _showLoading() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: "Please wait...",
    );
  }

  void _selectViolation() async {
    final form = ref.watch(createTicketFormProvider);
    final enforcer = ref.watch(enforcerProvider);
    final ticketProvider = ref.watch(ticketChangeNotifierProvider);

    String enforcerName =
        "${enforcer.firstName} ${enforcer.middleName} ${enforcer.lastName}";

    _showLoading();

    ULocation location = await LocationServices.instance.getLocation();

    final ticket = Ticket(
      driverName: _nameController.text,
      address: _addressController.text,
      birthDate: _birthDateController.text.isEmpty
          ? null
          : _birthDateController.text.toTimestamp,
      email: _emailController.text,
      phone: _phoneController.text,
      licenseNumber: _licenseNumberController.text,
      vehicleTypeID: form.vehicleTypeID,
      vehicleTypeName: _vehicleTypeController.text,
      plateNumber: _plateNumberController.text,
      conductionOrFileNumber: _conductionController.text,
      engineNumber: _engineNumberController.text,
      chassisNumber: _chassisNumberController.text,
      vehicleOwner: _vehicleOwnerController.text,
      vehicleOwnerAddress: _vehicleOwnerAddressController.text,
      enforcerID: enforcer.id,
      enforcerName: enforcerName,
      status: TicketStatus.unpaid,
      dateCreated: Timestamp.now(),
      ticketDueDate: Timestamp.now().getDueDate,
      violationDateTime: Timestamp.now(),
      violationPlace: location,
      issuedViolations: [],
      ticketNumber: 0,
      totalFine: 0,
    );
    ticketProvider.updateTicket(ticket);

    popCurrent();

    goSelectViolation();
  }

  Future<bool> _showCancelConfirm() async {
    final result = await QuickAlert.show(
      context: context,
      title: "Cancel Ticket",
      text: "Are you sure you want to cancel this ticket?",
      type: QuickAlertType.confirm,
      showCancelBtn: true,
      confirmBtnText: "Yes",
      cancelBtnText: "No",
      onConfirmBtnTap: () => Navigator.of(context).pop(true),
    );

    if (result != null && result) {
      ref.watch(createTicketFormProvider).reset();
      ref.watch(evidenceListProvider.notifier).state = [];
      ref.watch(licenseImageProvider).resetLicense();
      ref.watch(selectedViolationsProvider.notifier).state = [];
      clearField();
      popCurrent();
      return true;
    }

    return false;
  }
}
