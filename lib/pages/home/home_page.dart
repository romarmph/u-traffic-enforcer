import '../../config/utils/exports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget notificationBtn() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.notifications_outlined,
        size: USpace.space28,
      ),
    );
  }

  Widget userNav() {
    final user = Provider.of<AuthService>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Row(
        children: [
          ClipOval(
            child: FutureBuilder(
              future: StorageService.instance.fetchProfileImage(
                user.currentUser.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.data == null) {
                  return Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/User-avatar.svg/2048px-User-avatar.svg.png');
                }

                return Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: 48,
                  height: 48,
                );
              },
            ),
          ),
          const SizedBox(width: USpace.space16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enforcer 1",
                style: const UTextStyle().textlgfontbold.copyWith(
                      color: UColors.gray700,
                    ),
              ),
              Text(
                "enforcer1@gmail.com",
                style: const UTextStyle()
                    .textxsfontsemibold
                    .copyWith(color: UColors.gray500),
              ),
            ],
          ),
          const Spacer(),
          // notificationBtn(),
        ],
      ),
    );
  }

  Widget viewScheduleBtn() {
    return TextButton(
      onPressed: () {
        AuthService().signOut();
      },
      child: const Text("View Schedule"),
    );
  }

  Widget miniDashboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Container(
        padding: const EdgeInsets.all(USpace.space12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(USpace.space12),
          color: UColors.gray100,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Shift",
                  style: const UTextStyle().textxsfontnormal.copyWith(
                        color: UColors.gray600,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      "On Duty",
                      style: const UTextStyle().textxsfontnormal.copyWith(
                            color: UColors.green500,
                          ),
                    ),
                    const SizedBox(width: USpace.space4),
                    const CircleAvatar(
                      radius: 5,
                      backgroundColor: UColors.green500,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: USpace.space8),
            Container(
              decoration: BoxDecoration(
                color: UColors.blue600,
                borderRadius: BorderRadius.circular(USpace.space8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Jul 28",
                          style: const UTextStyle().textxlfontmedium.copyWith(
                                color: UColors.white,
                              ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(USpace.space8),
                              decoration: BoxDecoration(
                                color: UColors.white,
                                borderRadius:
                                    BorderRadius.circular(USpace.space8),
                              ),
                              child: Text(
                                "5:00 AM",
                                style: const UTextStyle()
                                    .textbasefontmedium
                                    .copyWith(
                                      color: UColors.gray600,
                                    ),
                              ),
                            ),
                            const SizedBox(width: USpace.space12),
                            Text(
                              "to",
                              style: const UTextStyle()
                                  .textbasefontmedium
                                  .copyWith(
                                    color: UColors.white,
                                  ),
                            ),
                            const SizedBox(width: USpace.space12),
                            Container(
                              padding: const EdgeInsets.all(USpace.space8),
                              decoration: BoxDecoration(
                                color: UColors.white,
                                borderRadius:
                                    BorderRadius.circular(USpace.space8),
                              ),
                              child: Text(
                                "1:00 PM",
                                style: const UTextStyle()
                                    .textbasefontmedium
                                    .copyWith(
                                      color: UColors.gray600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: USpace.space12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: UColors.white,
                          size: USpace.space28,
                        ),
                        const SizedBox(width: USpace.space8),
                        Text(
                          "Magic Mall",
                          style: const UTextStyle().textbasefontmedium.copyWith(
                                color: UColors.white,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: USpace.space12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Next Shift Rotation",
                      style: const UTextStyle().textxsfontnormal.copyWith(
                            color: UColors.gray600,
                          ),
                    ),
                    const SizedBox(height: USpace.space4),
                    Text(
                      "July 31, 2023",
                      style: const UTextStyle().textlgfontbold.copyWith(
                            color: UColors.blue700,
                          ),
                    ),
                  ],
                ),
                viewScheduleBtn(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget viewAllBtn() {
    return TextButton(
      onPressed: () {},
      child: const Text("View All"),
    );
  }

  Widget recentTicketsList() {
    final enforcer = Provider.of<EnforcerProvider>(context, listen: false);
    final ticketDB = TicketDBHelper.instance;

    return Expanded(
        child: StreamBuilder<List<Map<String, dynamic>>>(
      stream: ticketDB.getTicketsByEnforcerId(
        enforcer.enforcer.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching tickets"));
        }

        final List<Ticket> tickets =
            snapshot.data!.map((ticket) => Ticket.fromJson(ticket)).toList();

        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            Ticket ticket = tickets[index];
            return ListTile(
              title: Text(
                'Ticket # ${ticket.ticketNumber!.toString()}',
                style: const UTextStyle().textbasefontmedium.copyWith(
                      color: UColors.gray700,
                    ),
              ),
              subtitle: Text(ticket.driverName),
              onTap: () {
                viewRecentTicket(ticket, context);
              },
            );
          },
        );
      },
    ));
  }

  Widget recentTicketView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: USpace.space16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Tickets",
                style: const UTextStyle().textbasefontnormal.copyWith(
                      color: UColors.gray500,
                    ),
              ),
              const Spacer(),
              // viewAllBtn(),
            ],
          ),
          recentTicketsList(),
        ],
      ),
    );
  }

  int currentIndex = 0;
  Widget bottomNav() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      selectedItemColor: UColors.blue700,
      unselectedItemColor: UColors.gray600,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: USpace.space16),
            userNav(),
            const SizedBox(height: USpace.space16),
            miniDashboard(),
            const SizedBox(height: USpace.space8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: USpace.space16,
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(USpace.space24),
                ),
                onPressed: () async {
                  String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666',
                    'Cancel',
                    true,
                    ScanMode.QR,
                  );

                  QRDetails qrDetails = QRDetails.fromJson(
                    jsonDecode(barcodeScanRes),
                  );

                  goCreateTicketWithLicense(qrDetails);
                },
                label: const Text("Scan QR"),
                icon: const Icon(Icons.qr_code_scanner_outlined),
              ),
            ),
            Expanded(
              child: recentTicketView(),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton.extended(
        onPressed: goCreateTicket,
        label: Text("New Ticket"),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  void goCreateTicketWithLicense(QRDetails qrDetails) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTicketPage(
          qrDetails: qrDetails,
        ),
      ),
    );
  }
}
