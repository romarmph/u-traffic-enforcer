import 'package:u_traffic_enforcer/services/license_scan_services.dart';

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
                user.currentUser.id,
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
          notificationBtn(),
        ],
      ),
    );
  }

  Widget viewScheduleBtn() {
    return TextButton(
      onPressed: () {},
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
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "Ticket #123456",
              style: const UTextStyle().textbasefontmedium.copyWith(
                    color: UColors.gray600,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget recentTicketView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
              viewAllBtn(),
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
            Expanded(child: recentTicketView()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fabPressed,
        label: const Text("New Ticket"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  void fabPressed() {
    test();
    // final imageProvider = Provider.of<TicketProvider>(context, listen: false);
    // final imagePicker = ImagePickerService.instance;
    // final image = await imagePicker.pickImage();

    // goCreateTicket();
  }

  void test() async {
    final test = ScanApiServices.instance;
    final data = await test.sendRequest(
        'https://media.discordapp.net/attachments/1138674544530440226/1138674683261231164/license.jpeg?width=942&height=588');

    // print(data.toString());
  }
}
