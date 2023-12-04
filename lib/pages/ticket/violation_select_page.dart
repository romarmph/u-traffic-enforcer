import '../../config/utils/exports.dart';

final searchQueryProvider = StateProvider<String>((ref) {
  return "";
});

class ViolationList extends ConsumerStatefulWidget {
  const ViolationList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViolationListState();
}

class _ViolationListState extends ConsumerState<ViolationList> {
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<IssuedViolation> selectedViolations =
        ref.watch(selectedViolationsProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Select Violations"),
        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
            icon: Badge(
              label: Text(
                selectedViolations.length.toString(),
                style: const TextStyle(
                  color: UColors.white,
                ),
              ),
              child: const Icon(Icons.library_books),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: UColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(USpace.space8),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: USpace.space8,
              vertical: USpace.space16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Selected Violations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        final remove = await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: "Remove all Violation",
                          text:
                              "Are you sure you want to remove all violations?",
                          onConfirmBtnTap: () {
                            Navigator.of(context).pop(true);
                          },
                        );

                        if (remove == null) {
                          return;
                        }
                        ref.read(selectedViolationsProvider.notifier).update(
                              (state) => [],
                            );
                      },
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedViolations.length,
                    itemBuilder: (context, index) {
                      final IssuedViolation issuedViolation =
                          selectedViolations[index];
                      return ListTile(
                        visualDensity: VisualDensity.comfortable,
                        title: Text(
                          issuedViolation.violation,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "Fine: ${issuedViolation.fine}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: UColors.red500,
                              ),
                            ),
                            const SizedBox(
                              width: USpace.space8,
                            ),
                            Text(
                              "Offense: ${issuedViolation.offense}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: UColors.red500,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final remove = await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title: "Remove Violation",
                              text:
                                  "Are you sure you want to remove this violation?",
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop(true);
                              },
                            );

                            if (remove == null) {
                              return;
                            }

                            final List<IssuedViolation>
                                updatedSelectedViolations = [
                              ...selectedViolations
                            ];

                            updatedSelectedViolations.removeWhere((element) =>
                                element.violationID ==
                                issuedViolation.violationID);

                            ref
                                .read(selectedViolationsProvider.notifier)
                                .update(
                                  (state) => updatedSelectedViolations,
                                );
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: USpace.space16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: USpace.space16,
              ),
              color: UColors.white,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  hintText: "Search Violation",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(USpace.space8),
                  ),
                  suffixIcon: Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = "";
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: USpace.space16,
            ),
            Expanded(
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                child: _buildViolationsList(),
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
    final selectedViolations = ref.watch(selectedViolationsProvider);
    final currentTicket = ref.watch(ticketChangeNotifierProvider).ticket;
    return ref.watch(violationsStreamProvider).when(
          data: (violations) {
            return ref.watch(relatedTicketsStream(currentTicket)).when(
              data: (tickets) {
                List<IssuedViolation> relatedViolations = [];
                for (var ticket in tickets) {
                  relatedViolations.addAll(ticket.issuedViolations);
                }

                Map<String, int> violationCounts = {};

                for (var violation in relatedViolations) {
                  if (violations.any((v) => v.id == violation.violationID)) {
                    if (violationCounts.containsKey(violation.violationID)) {
                      violationCounts[violation.violationID] =
                          violationCounts[violation.violationID]! + 1;
                    } else {
                      violationCounts[violation.violationID] = 1;
                    }
                  }
                }

                violationCounts.updateAll(
                  (key, value) => value > 3 ? 3 : value,
                );

                final query = ref.watch(searchQueryProvider);
                violations = _searchViolation(violations, query);
                return ListView.separated(
                  itemCount: violations.length,
                  itemBuilder: (context, index) {
                    final Violation violation = violations[index];
                    final isSelected = selectedViolations
                        .any((element) => element.violationID == violation.id);
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected ? UColors.blue100 : UColors.white,
                        borderRadius: BorderRadius.circular(USpace.space8),
                        border: Border.all(
                          color:
                              isSelected ? UColors.blue700 : Colors.transparent,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (selectedViolations.any((element) =>
                              element.violationID == violation.id)) {
                            final List<IssuedViolation>
                                updatedSelectedViolations = [
                              ...selectedViolations
                            ];

                            updatedSelectedViolations.removeWhere((element) =>
                                element.violationID == violation.id);

                            ref
                                .read(selectedViolationsProvider.notifier)
                                .state = updatedSelectedViolations;

                            return;
                          }

                          final List<IssuedViolation>
                              updatedSelectedViolations = [
                            ...selectedViolations
                          ];

                          final count = violationCounts[violation.id] ?? 0;
                          print(count);
                          if (violation.offense.length == 3) {
                            if (count < 3) {
                              updatedSelectedViolations.add(
                                IssuedViolation(
                                  violationID: violation.id!,
                                  violation: violation.name,
                                  fine: violation.offense[count].fine,
                                  offense: violation.offense[count].level,
                                ),
                              );
                            } else {
                              updatedSelectedViolations.add(
                                IssuedViolation(
                                  violationID: violation.id!,
                                  violation: violation.name,
                                  fine: violation.offense[2].fine,
                                  offense: violation.offense[2].level,
                                ),
                              );
                            }
                          } else if (violation.offense.length == 2) {
                            if (count >= 1) {
                              updatedSelectedViolations.add(
                                IssuedViolation(
                                  violationID: violation.id!,
                                  violation: violation.name,
                                  fine: violation.offense[1].fine,
                                  offense: violation.offense[1].level,
                                ),
                              );
                            } else {
                              updatedSelectedViolations.add(
                                IssuedViolation(
                                  violationID: violation.id!,
                                  violation: violation.name,
                                  fine: violation.offense[0].fine,
                                  offense: violation.offense[0].level,
                                ),
                              );
                            }
                          } else {
                            updatedSelectedViolations.add(
                              IssuedViolation(
                                violationID: violation.id!,
                                violation: violation.name,
                                fine: violation.offense[0].fine,
                                offense: violation.offense[0].level,
                              ),
                            );
                          }

                          ref.read(selectedViolationsProvider.notifier).state =
                              updatedSelectedViolations;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(USpace.space8),
                        ),
                        selected: isSelected,
                        selectedTileColor: UColors.blue100,
                        title: Text(
                          violation.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color:
                                isSelected ? UColors.gray700 : UColors.gray600,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: USpace.space12,
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return const Center(
                  child: Text('Error fetching violatios'),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
          error: (error, stackTrace) {
            return const Center(
              child: Text('Error fetching related tickets'),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }

  void _previewTicket() {
    final ticketProvier = ref.watch(ticketChangeNotifierProvider);
    final List<IssuedViolation> selectedViolations =
        ref.watch(selectedViolationsProvider);

    if (selectedViolations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one violation"),
        ),
      );
      return;
    }

    Ticket updatedTicket = ticketProvier.ticket.copyWith(
      issuedViolations: selectedViolations,
    );

    ticketProvier.updateTicket(updatedTicket);

    goPreviewTicket();
  }

  List<Violation> _searchViolation(List<Violation> violations, String query) {
    return violations.where((violation) {
      return violation.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  bool isRelated(Ticket ticket, Ticket relatedTicket) {
    if (ticket.licenseNumber!.isNotEmpty &&
        ticket.licenseNumber == relatedTicket.licenseNumber) {
      return true;
    }

    if (ticket.plateNumber!.isNotEmpty &&
        ticket.plateNumber == relatedTicket.plateNumber) {
      return true;
    }

    if (ticket.engineNumber!.isNotEmpty &&
        ticket.engineNumber == relatedTicket.engineNumber) {
      return true;
    }

    if (ticket.chassisNumber!.isNotEmpty &&
        ticket.chassisNumber == relatedTicket.chassisNumber) {
      return true;
    }

    if (ticket.conductionOrFileNumber!.isNotEmpty &&
        ticket.conductionOrFileNumber == relatedTicket.conductionOrFileNumber) {
      return true;
    }

    return false;
  }
}
