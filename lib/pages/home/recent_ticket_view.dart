import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../config/utils/exports.dart';

class RecentTicketView extends StatefulWidget {
  const RecentTicketView({super.key, required this.ticket});

  final Ticket ticket;

  @override
  State<RecentTicketView> createState() => _RecentTicketViewState();
}

class _RecentTicketViewState extends State<RecentTicketView>
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
    final vehicleTypes = Provider.of<VehicleTypeProvider>(context);

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
                        title: vehicleTypes.getVehicleTypeName(
                          widget.ticket.vehicleTypeID,
                        ),
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
                  Consumer<ViolationProvider>(
                    builder: (context, value, child) {
                      final List<Violation> selected = [];

                      for (final violation in value.getViolations) {
                        if (widget.ticket.violationsID.contains(violation.id)) {
                          selected.add(violation);
                        }
                      }

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            final ticketProvider =
                Provider.of<TicketProvider>(context, listen: false);

            ticketProvider.updateTicket(widget.ticket);
            goPrinter();
          },
          child: const Text('Print Ticket'),
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
