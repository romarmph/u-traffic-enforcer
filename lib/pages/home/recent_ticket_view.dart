import 'package:intl/intl.dart';
import 'package:u_traffic_enforcer/config/extensions/string_date_formatter.dart';

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
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        title: widget.ticket.licenseNumber,
                        subtitle: 'License Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.driverName,
                        subtitle: 'Driver Name',
                      ),
                      PreviewListTile(
                        title: widget.ticket.birthDate.toString().formtDate,
                        subtitle: 'Last Name',
                      ),
                      PreviewListTile(
                        title: widget.ticket.address,
                        subtitle: 'Address',
                      ),
                      PreviewListTile(
                        title: widget.ticket.phone,
                        subtitle: 'Contact Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.email,
                        subtitle: 'Email Address',
                      ),
                    ],
                  ),
                  ListView(
                    children: [
                      PreviewListTile(
                        title: widget.ticket.vehicleType,
                        subtitle: 'Vehicle Type',
                      ),
                      PreviewListTile(
                        title: widget.ticket.plateNumber,
                        subtitle: 'Plate Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.engineNumber,
                        subtitle: 'Engine Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.chassisNumber,
                        subtitle: 'Chassis Number',
                      ),
                      PreviewListTile(
                        title: widget.ticket.vehicleOwner,
                        subtitle: 'Vehicle Owner',
                      ),
                      PreviewListTile(
                        title: widget.ticket.vehicleOwnerAddress,
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
                  ListView(
                    children: [
                      PreviewListTile(
                        title: widget.ticket.violationDateTime
                            .toString()
                            .formtDate,
                        subtitle: 'Violation Date',
                      ),
                      PreviewListTile(
                        title: timeFormat.format(
                          widget.ticket.violationDateTime.toDate(),
                        ),
                        subtitle: 'Violation Date',
                      ),
                      PreviewListTile(
                        title: widget.ticket.violationPlace.address,
                        subtitle: 'Place of Violation',
                      ),
                      PreviewListTile(
                        title: formatStatus(widget.ticket.status),
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

  String formatStatus(TicketStatus status) {
    return status.toString().split('.').last.split('').first.toUpperCase() +
        status.toString().split('.').last.substring(1);
  }
}
