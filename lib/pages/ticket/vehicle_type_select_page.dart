import 'package:u_traffic_enforcer/config/utils/exports.dart';

class VehicleTypeSelectPage extends ConsumerStatefulWidget {
  const VehicleTypeSelectPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VehicleTypeSelectPageState();
}

class _VehicleTypeSelectPageState extends ConsumerState<VehicleTypeSelectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Vehicle Type"),
      ),
      body: ref.watch(vehicleTypeStreamProvider).when(
            data: (data) {
              final private =
                  data.where((element) => !element.isPublic).toList();
              final public = data.where((element) => element.isPublic).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: "Public",
                      ),
                      Tab(
                        text: "Private",
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                          itemCount: public.length,
                          itemBuilder: (context, index) {
                            final vehicle = public[index];
                            return ListTile(
                              visualDensity: VisualDensity.comfortable,
                              onTap: () {
                                Navigator.pop(context, vehicle);
                              },
                              title: Text(vehicle.typeName),
                              subtitle: const Text('Tap to select'),
                              trailing: const Icon(
                                Icons.touch_app_rounded,
                                color: UColors.gray300,
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          itemCount: private.length,
                          itemBuilder: (context, index) {
                            final vehicle = private[index];
                            return ListTile(
                              visualDensity: VisualDensity.comfortable,
                              onTap: () {
                                Navigator.pop(context, vehicle);
                              },
                              title: Text(vehicle.typeName),
                              subtitle: const Text('Tap to select'),
                              trailing: const Icon(
                                Icons.touch_app_rounded,
                                color: UColors.gray300,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              print(error);
              print(stackTrace);
              return const Center(
                child: Text("Error loading vehicle types"),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
