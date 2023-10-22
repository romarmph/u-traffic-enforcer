import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';
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

  Widget getProfileImage() {
    final enforcer = Provider.of<EnforcerProvider>(context);

    List<String> fileExtensions = ['jpg', 'jpeg', 'png'];

    String baseurl = "gs://u-traffic.appspot.com/profileImage";
    FirebaseUrl url = FirebaseUrl('');
    for (var item in fileExtensions) {
      try {
        url = FirebaseUrl('$baseurl/${enforcer.enforcer.id}.$item');
      } on Exception catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }

    return Image(
      image: FirebaseImageProvider(
        url,
      ),
      fit: BoxFit.cover,
      width: 48,
      height: 48,
    );
  }

  Widget userNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Row(
        children: [
          ClipOval(
            child: getProfileImage(),
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
        child: StreamBuilder<List<Ticket>>(
      stream: ticketDB.getTicketsByEnforcerId(
        enforcer.enforcer.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot);
          debugPrint(snapshot.error.toString());
          return const Center(child: Text("Error fetching tickets"));
        }

        final List<Ticket> tickets = snapshot.data!;

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
            ],
          ),
          recentTicketsList(),
        ],
      ),
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
            Expanded(
              child: recentTicketView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showMenu,
        label: const Text("Create Ticket"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  void showMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(USpace.space16),
            decoration: BoxDecoration(
              color: UColors.white,
              borderRadius: BorderRadius.circular(USpace.space12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(USpace.space24),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
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
                const SizedBox(height: USpace.space12),
                ElevatedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(USpace.space24),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    goCreateTicket();
                  },
                  label: const Text("Fill Form"),
                  icon: const Icon(Icons.create_rounded),
                ),
                const SizedBox(height: USpace.space12),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        );
      },
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
