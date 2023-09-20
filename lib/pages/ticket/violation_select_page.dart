import '../../config/utils/exports.dart';

class ViolationsList extends StatefulWidget {
  const ViolationsList({super.key});

  @override
  State<ViolationsList> createState() => _ViolationsListState();
}

class _ViolationsListState extends State<ViolationsList> {
  @override
  void initState() {
    super.initState();

    Provider.of<ViolationProvider>(context, listen: false).listenToViolations();
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(USpace.space12),
      color: UColors.white,
      child: Row(
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
            child: ElevatedButton(
              onPressed: _previewTicket,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationsList() {
    final ticket = Provider.of<TicketProvider>(context, listen: false).ticket;

    return Consumer<ViolationProvider>(
      builder: (context, violation, child) {
        if (ticket.licenseNumber.isEmpty) {
          violation.getViolations
              .where((element) => element.id == '2z8KdHRfLapkAeAhbjOt')
              .first
              .isSelected = true;
        }

        if (ticket.plateNumber.isEmpty) {
          violation.getViolations
              .where((element) => element.id == 'V0ORjFu2Y0H9Hu88WgbO')
              .first
              .isSelected = true;
        }

        return SearchableList<Violation>(
          inputDecoration: const InputDecoration(
            labelText: "Search Violations",
          ),
          initialList: violation.getViolations,
          filter: (query) => violation.getViolations
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList(),
          builder: (displayedList, itemIndex, item) {
            if (item.id == '2z8KdHRfLapkAeAhbjOt' &&
                ticket.licenseNumber.isEmpty) {
              return CheckboxListTile(
                enabled: false,
                value: item.isSelected,
                onChanged: (value) {
                  violation.selectViolation(item.id);
                },
                title: Text(item.name),
                subtitle: Text(
                  "Fine: ${item.fine.toString()}",
                ),
              );
            }

            if (item.id == 'V0ORjFu2Y0H9Hu88WgbO' &&
                ticket.plateNumber.isEmpty) {
              return CheckboxListTile(
                enabled: false,
                value: item.isSelected,
                onChanged: (value) {
                  violation.selectViolation(item.id);
                },
                title: Text(item.name),
                subtitle: Text(
                  "Fine: ${item.fine.toString()}",
                ),
              );
            }

            return CheckboxListTile(
              value: item.isSelected,
              onChanged: (value) {
                violation.selectViolation(item.id);
              },
              title: Text(item.name),
              subtitle: Text(
                "Fine: ${item.fine.toString()}",
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Violations"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(USpace.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please select the violations below:",
              style: const UTextStyle().textlgfontmedium,
            ),
            const SizedBox(height: USpace.space16),
            Expanded(
              child: _buildViolationsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(),
    );
  }

  void _previewTicket() {
    final provider = Provider.of<ViolationProvider>(context, listen: false);
    final ticketProvier = Provider.of<TicketProvider>(context, listen: false);

    if (provider.getViolations.where((element) => element.isSelected).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one violation"),
        ),
      );
      return;
    }

    final List<String?> selectedViolations = provider.getViolations
        .where((element) => element.isSelected)
        .map((e) => e.id)
        .toList();

    Ticket updatedTicket = ticketProvier.ticket.copyWith(
      violationsID: selectedViolations,
    );

    ticketProvier.updateTicket(updatedTicket);

    goPreviewTicket();
  }
}
