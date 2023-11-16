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
    final selectedViolations = ref.watch(selectedViolationsProvider);
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
                        subtitle: Text(
                          "Fine: ${issuedViolation.fine}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: UColors.red500,
                          ),
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
    return ref.watch(violationsStreamProvider).when(
      data: (violations) {
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
                  color: isSelected ? UColors.blue700 : Colors.transparent,
                ),
              ),
              child: ListTile(
                onTap: () {
                  if (selectedViolations
                      .any((element) => element.violationID == violation.id)) {
                    final List<IssuedViolation> updatedSelectedViolations = [
                      ...selectedViolations
                    ];

                    updatedSelectedViolations.removeWhere(
                        (element) => element.violationID == violation.id);

                    ref.read(selectedViolationsProvider.notifier).update(
                          (state) => updatedSelectedViolations,
                        );
                    return;
                  }

                  final List<IssuedViolation> updatedSelectedViolations = [
                    ...selectedViolations
                  ];

                  updatedSelectedViolations.add(
                    IssuedViolation(
                      fine: violation.offense.first.fine,
                      violation: violation.name,
                      violationID: violation.id!,
                      isBigVehicle: true,
                      offense: violation.offense.first.level,
                    ),
                  );

                  ref.read(selectedViolationsProvider.notifier).update((state) {
                    return updatedSelectedViolations;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(USpace.space8),
                ),
                selected: isSelected,
                selectedTileColor: UColors.blue100,
                title: Text(
                  violation.name,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? UColors.gray700 : UColors.gray600,
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
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
}
