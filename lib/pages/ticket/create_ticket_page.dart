import 'package:u_traffic_enforcer/config/extensions/date_time_extension.dart';

import 'package:u_traffic_enforcer/config/extensions/timestamp_extension.dart';

import '../../../config/utils/exports.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({
    super.key,
    this.qrDetails,
  });

  final QRDetails? qrDetails;

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late CreateTicketFormNotifier _formNotifier;
  late ScannedDetails _scannedDetails;
  late UTrafficImageProvider _imageProvider;

  final _formKey = GlobalKey<FormState>();

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

  String _cancelButtonText = "Cancel";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _formNotifier = Provider.of<CreateTicketFormNotifier>(
      context,
      listen: false,
    );
    _scannedDetails = Provider.of<ScannedDetails>(
      context,
      listen: false,
    );
    _imageProvider = Provider.of<UTrafficImageProvider>(
      context,
      listen: false,
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

    _formNotifier.addListener(() {
      if (_formNotifier.isDriverNotPresent) {
        _nameController.clear();
        _addressController.clear();
        _phoneController.clear();
        _emailController.clear();
        _licenseNumberController.clear();
        _birthDateController.clear();
        _vehicleOwnerAddressController.clear();
        _vehicleOwnerController.clear();
        _formNotifier.setIsVehicleOwnedByDriver(false);
      }

      if (_formNotifier.isVehicleOwnedByDriver) {
        _vehicleOwnerController.text = _nameController.text;
        _vehicleOwnerAddressController.text = _addressController.text;
      } else {
        _vehicleOwnerController.clear();
        _vehicleOwnerAddressController.clear();
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

  @override
  void dispose() {
    _tabController.dispose();
    _formNotifier.reset();

    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licenseNumberController.dispose();
    _birthDateController.dispose();
    _plateNumberController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    _vehicleOwnerController.dispose();
    _vehicleOwnerAddressController.dispose();
    _vehicleTypeController.dispose();
    _scannedDetails.clearDetails();
    _imageProvider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ticket"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTabs(),
          Expanded(
            child: Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(USpace.space16),
                      child: Consumer<ScannedDetails>(
                          builder: (context, details, child) {
                        if (details.details.isNotEmpty) {
                          _nameController.text =
                              details.details['fullname'] ?? "";
                          _addressController.text =
                              details.details['address'] ?? "";

                          _licenseNumberController.text =
                              details.details['licensenumber'] ?? "";
                          _birthDateController.text = details
                                      .details['birthdate'] !=
                                  null
                              ? DateTime.parse(
                                      details.details['birthdate'].toString())
                                  .toAmericanDate
                              : "";
                        }
                        return DriverDetailsForm(
                          nameController: _nameController,
                          addressController: _addressController,
                          phoneController: _phoneController,
                          emailController: _emailController,
                          licenseNumberController: _licenseNumberController,
                          birthDateController: _birthDateController,
                        );
                      }),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(USpace.space16),
                      child: VehiecleDetailsForm(
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
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
              onPressed: _handleNextButtonClick,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "Driver Details"),
        Tab(text: "Vehicle Details"),
      ],
    );
  }

  void _handleBackButtonClick() {
    if (_tabController.index == 0) {
      Navigator.pop(context);
    } else {
      _tabController.animateTo(_tabController.index - 1);
    }
  }

  void _handleNextButtonClick() {
    if (_tabController.index == 0 && _formKey.currentState!.validate()) {
      _tabController.animateTo(1);
      return;
    }

    if (_tabController.index == 1 && _formKey.currentState!.validate()) {
      _selectViolation();
    }
  }

  void _selectViolation() async {
    final enforcer = Provider.of<EnforcerProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    String enforcerName =
        "${enforcer.enforcer.firstName} ${enforcer.enforcer.middleName} ${enforcer.enforcer.lastName}";

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: "Please wait...",
    );

    ULocation location = await LocationServices.instance.getLocation();

    final ticket = Ticket(
      driverName: _nameController.text,
      address: _addressController.text,
      birthDate: _birthDateController.text.toTimestamp,
      email: _emailController.text,
      phone: _phoneController.text,
      licenseNumber: _licenseNumberController.text,
      vehicleType: _vehicleTypeController.text,
      plateNumber: _plateNumberController.text,
      engineNumber: _engineNumberController.text,
      chassisNumber: _chassisNumberController.text,
      vehicleOwner: _vehicleOwnerController.text,
      vehicleOwnerAddress: _vehicleOwnerAddressController.text,
      enforcerID: enforcer.enforcer.id,
      enforcerName: enforcerName,
      status: TicketStatus.unpaid,
      dateCreated: Timestamp.now(),
      ticketDueDate: Timestamp.now().getDueDate,
      violationDateTime: Timestamp.now(),
      violationPlace: location,
      violationsID: [],
      ticketNumber: 0,
    );
    ticketProvider.updateTicket(ticket);

    popCurrent();

    goSelectViolation();
  }

  @override
  bool get wantKeepAlive => true;
}
