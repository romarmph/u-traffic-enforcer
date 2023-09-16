import '../../../config/utils/exports.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({
    super.key,
    this.licenseDetail,
  });

  final LicenseDetails? licenseDetail;

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CreateTicketFormNotifier _formNotifier;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _formNotifier.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ticket"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: USpace.space12),
                          DriverDetailsForm(
                            nameController: _nameController,
                            addressController: _addressController,
                            phoneController: _phoneController,
                            emailController: _emailController,
                            licenseNumberController: _licenseNumberController,
                            birthDateController: _birthDateController,
                          ),
                          const SizedBox(height: USpace.space12),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: USpace.space12),
                          VehiecleDetailsForm(
                            plateNumberController: _plateNumberController,
                            engineNumberController: _engineNumberController,
                            chassisNumberController: _chassisNumberController,
                            vehicleOwnerController: _vehicleOwnerController,
                            vehicleOwnerAddressController:
                                _vehicleOwnerAddressController,
                            vehicleTypeController: _vehicleTypeController,
                          ),
                          const SizedBox(height: USpace.space12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      onTap: (index) {
        if (index == 1 && !_formKey.currentState!.validate()) {
          // Prevent the tab change
          _tabController.animateTo(0);
        } else {
          // Allow the tab change
          _tabController.animateTo(index);
        }
      },
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
    if (_formKey.currentState!.validate()) {
      print('valid');
    }
  }
}
