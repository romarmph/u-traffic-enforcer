import 'package:intl/intl.dart';

import '../../config/utils/exports.dart';

class RecentTicketView extends ConsumerStatefulWidget {
  const RecentTicketView({super.key, required this.ticket});

  final Ticket ticket;

  @override
  ConsumerState<RecentTicketView> createState() => _RecentTicketViewState();
}

class _RecentTicketViewState extends ConsumerState<RecentTicketView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final timeFormat = DateFormat('hh:mm a');

  @override
  void initState() {
    _tabController = TabController(
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleTypes = ref.watch(vehicleTypeProvider);
    final violations = ref.watch(violationsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Ticket'),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Driver Details',
              ),
              Tab(
                text: 'Vehicle Details',
              ),
              Tab(
                text: 'Violations',
              ),
              Tab(
                text: 'Evidence',
              ),
              Tab(
                text: 'Other Detials',
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    children: [
                      PreviewListTile(
                        title: widget.ticket.licenseNumber ?? "N/A",
                        subtitle: 'License Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.driverName ?? "N/A",
                        subtitle: 'Driver Name',
                      ),
                      PreviewListTile(
                        title: widget.ticket.birthDate != null
                            ? widget.ticket.birthDate!.toAmericanDate
                            : "N/A",
                        subtitle: 'Birthdate',
                      ),
                      PreviewListTile(
                        title: widget.ticket.address ?? "N/A",
                        subtitle: 'Address',
                      ),
                      PreviewListTile(
                        title: widget.ticket.phone ?? "N/A",
                        subtitle: 'Contact Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.email ?? "N/A",
                        subtitle: 'Email Address',
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      PreviewListTile(
                        title: vehicleTypes
                            .firstWhere((element) =>
                                element.id == widget.ticket.vehicleTypeID)
                            .typeName,
                        subtitle: 'Vehicle Type',
                      ),
                      PreviewListTile(
                        title: widget.ticket.plateNumber ?? "N/A",
                        subtitle: 'Plate Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.engineNumber ?? "N/A",
                        subtitle: 'Engine Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.chassisNumber ?? "N/A",
                        subtitle: 'Chassis Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.vehicleOwner ?? "N/A",
                        subtitle: 'Vehicle Owner',
                      ),
                      PreviewListTile(
                        title: widget.ticket.vehicleOwnerAddress ?? "N/A",
                        subtitle: 'Vehicle Owner Address',
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: widget.ticket.issuedViolations.length,
                    itemBuilder: (context, index) {
                      final IssuedViolation violation =
                          widget.ticket.issuedViolations[index];

                      final name = violations
                          .where(
                              (element) => element.id == violation.violationID)
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
                  ),
                  FutureBuilder(
                    future: StorageService.instance.fetchEvidences(
                      widget.ticket.ticketNumber!,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error fetching evidences'),
                        );
                      }

                      final List<Evidence> evidences =
                          snapshot.data as List<Evidence>;

                      return ListView.builder(
                        itemCount: evidences.length,
                        itemBuilder: (context, index) {
                          final Evidence evidence = evidences[index];

                          return GestureDetector(
                            onTap: () => _previewImage(evidence),
                            child: EvidenceCard(
                              isNetowrkImage: true,
                              isPreview: true,
                              evidence: evidence,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListView(
                    children: [
                      PreviewListTile(
                        title: widget.ticket.ticketNumber.toString(),
                        subtitle: 'Ticket Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.violationDateTime.toAmericanDate,
                        subtitle: 'Violation Date',
                      ),
                      PreviewListTile(
                        title: widget.ticket.violationDateTime.toTime,
                        subtitle: 'Violation Time',
                      ),
                      PreviewListTile(
                        title: widget.ticket.violationPlace.address,
                        subtitle: 'Place of Violation',
                      ),
                      PreviewListTile(
                        title: _formatStatus(widget.ticket.status),
                        subtitle: 'Ticket Status',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: UColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Fine',
                    style: TextStyle(
                      color: UColors.gray600,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.ticket.totalFine.toString(),
                    style: const TextStyle(
                      color: UColors.red400,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final ticketProvider = ref.watch(ticketChangeNotifierProvider);

                ticketProvider.updateTicket(widget.ticket);
                goPrinter();
              },
              child: const Text('Print Ticket'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(TicketStatus status) {
    return status.toString().split('.').last.split('').first.toUpperCase() +
        status.toString().split('.').last.substring(1);
  }

  void _previewImage(Evidence evidence) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Preview Image'),
          backgroundColor: UColors.white,
          surfaceTintColor: UColors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: USpace.space16,
            vertical: USpace.space0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: evidence.path,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }
}
