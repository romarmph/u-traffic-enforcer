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
  late CreateTicketFormNotifier _notifier;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _notifier = Provider.of<CreateTicketFormNotifier>(context, listen: false);

    if (widget.licenseDetail != null) {
      _notifier.formSettings[TicketField.licenseNumber]!.controller!.text =
          widget.licenseDetail!.licenseNumber;
      _notifier.formSettings[TicketField.firstName]!.controller!.text =
          widget.licenseDetail!.firstName;
      _notifier.formSettings[TicketField.middleName]!.controller!.text =
          widget.licenseDetail!.middleName;
      _notifier.formSettings[TicketField.lastName]!.controller!.text =
          widget.licenseDetail!.lastName;
      _notifier.formSettings[TicketField.address]!.controller!.text =
          widget.licenseDetail!.address;
      _notifier.formSettings[TicketField.birthDate]!.controller!.text =
          widget.licenseDetail!.birthdate.toDate().toString();
    }

    _tabController.addListener(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notifier.clearDriverFields();
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
                  children: const [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: USpace.space12),
                          DriverDetailsForm(),
                          SizedBox(height: USpace.space12),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: USpace.space12),
                          VehiecleDetailsForm(),
                          SizedBox(height: USpace.space12),
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
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ),
          const SizedBox(width: USpace.space16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _tabController.index == 0) {
                  _tabController.animateTo(1);
                  return;
                }

                if (_formKey.currentState!.validate() &&
                    _tabController.index == 1) {
                  getFieldValues();
                }
              },
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

  void getFieldValues() {
    final formData =
        Provider.of<CreateTicketFormNotifier>(context, listen: false);
    formData.driverFormData.forEach((key, value) {
      formData.driverFormData[key] =
          formData.formSettings[key]!.controller!.text;
    });
    formData.vehicleFormData.forEach((key, value) {
      if (key != TicketField.violationsID) {
        formData.vehicleFormData[key] =
            formData.formSettings[key]!.controller!.text;
      }
    });

    goSelectViolation();
  }
}
