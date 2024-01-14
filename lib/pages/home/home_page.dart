import 'dart:math';

import 'package:u_traffic_enforcer/config/enums/shift_period.dart';
import 'package:u_traffic_enforcer/database/attendance_db.dart';
import 'package:u_traffic_enforcer/model/attendance.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';
import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';
import 'package:u_traffic_enforcer/riverpod/attendance.riverpod.dart';
import 'package:u_traffic_enforcer/riverpod/sched.riverpod.dart';
import 'package:u_traffic_enforcer/riverpod/trafficpost.riverpod.dart';
import '../../config/utils/exports.dart';
import 'package:geolocator/geolocator.dart' as geo;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late EnforcerSchedule? schedule;

  void _timeIn(Attendance attendance) async {
    final result = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Time In',
      text: 'Are you sure you want to time in?',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
    );

    if (result != true) return;

    await AttendanceDBHelper.instance.timeIn(attendance);

    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.success,
      title: 'Time Int',
      text: 'You have successfully timed in',
    );
  }

  void _timeOut(Attendance attendance) async {
    final result = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Time Out',
      text: 'Are you sure you want to time out?',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(true);
      },
    );

    if (result != true) return;

    await AttendanceDBHelper.instance.timeOut(attendance);

    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.success,
      title: 'Time Out',
      text: 'You have successfully timed out',
    );
  }

  void showLocationError() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Location Error',
      text: 'You are not within 100 meters of the post',
    );
  }

  bool isWithin100Meters(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295;
    const c = cos;
    double a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

    double distance = 12742 * asin(sqrt(a));

    return distance <= 0.1;
  }

  @override
  void initState() {
    super.initState();
    schedule = ref.read(schedProvider);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget userNav() {
    final enforcer = ref.watch(enforcerProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: USpace.space16,
      ),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              height: 48,
              width: 48,
              imageUrl: enforcer.photoUrl,
            ),
          ),
          const SizedBox(width: USpace.space16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${enforcer.firstName} ${enforcer.lastName}",
                style: const UTextStyle().textxlfontbold.copyWith(
                      color: UColors.gray700,
                    ),
              ),
              Text(
                enforcer.email,
                style: const UTextStyle()
                    .textbasefontmedium
                    .copyWith(color: UColors.gray500),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
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
        child: ref.watch(schedProviderStream).when(
          data: (sched) {
            if (sched == null) {
              return Center(
                child: Text(
                  'You have no schedule set yet',
                  style: const UTextStyle().textbasefontmedium.copyWith(
                        color: UColors.gray700,
                      ),
                ),
              );
            }

            return Column(
              children: [
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
                              sched.postName,
                              style:
                                  const UTextStyle().textxlfontmedium.copyWith(
                                        color: UColors.white,
                                      ),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(
                                sched.shift.name.capitalize,
                                style: const UTextStyle()
                                    .textxsfontnormal
                                    .copyWith(
                                      color: UColors.white,
                                    ),
                              ),
                              side: const BorderSide(
                                color: UColors.white,
                                width: 2,
                              ),
                              backgroundColor:
                                  sched.shift == ShiftPeriod.morning
                                      ? UColors.green400
                                      : sched.shift == ShiftPeriod.afternoon
                                          ? UColors.orange400
                                          : UColors.indigo400,
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
                            Expanded(
                              child:
                                  ref.watch(getTrafficpost(sched.postId)).when(
                                data: (post) {
                                  return Text(
                                    post.location.address,
                                    style: const UTextStyle()
                                        .textlgfontbold
                                        .copyWith(
                                          color: UColors.white,
                                        ),
                                  );
                                },
                                error: (error, stackTrace) {
                                  return Text(
                                    'Error fetching post',
                                    style: const UTextStyle()
                                        .textlgfontbold
                                        .copyWith(
                                          color: UColors.white,
                                        ),
                                  );
                                },
                                loading: () {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: USpace.space12),
                        StreamBuilder<geo.Position>(
                          stream: geo.Geolocator.getPositionStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasError) {
                              return const Text('Error fetching location');
                            }

                            final position = snapshot.data;

                            final allPost = ref.watch(allPostProvider);

                            final post = allPost.firstWhere(
                              (post) => post.id == sched.postId,
                            );

                            bool canTimeInTimeOut = isWithin100Meters(
                              position!.latitude,
                              position.longitude,
                              post.location.lat,
                              post.location.long,
                            );

                            return ref
                                .watch(attendanceProvider(sched.shift))
                                .when(
                              data: (attendance) {
                                if (attendance == null) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UColors.white,
                                      foregroundColor: UColors.blue600,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: USpace.space12,
                                      ),
                                    ),
                                    onPressed: canTimeInTimeOut
                                        ? () {
                                            if (!sched.shift.isOnDuty) {
                                              showNotOnScheduleError();
                                              return;
                                            }

                                            Attendance attendance = Attendance(
                                              enforcerId: AuthService()
                                                  .currentUser!
                                                  .uid,
                                              timeIn: Timestamp.now(),
                                              schedule: sched,
                                            );

                                            _timeIn(attendance);
                                          }
                                        : showLocationError,
                                    child: const Text("Time In"),
                                  );
                                }

                                if (attendance.schedule.shift.isOnDuty &&
                                    attendance.timeOut == null) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: UColors.white,
                                      foregroundColor: UColors.blue600,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: USpace.space12,
                                      ),
                                    ),
                                    onPressed: canTimeInTimeOut
                                        ? () {
                                            final timeOut = attendance.copyWith(
                                              timeOut: Timestamp.now(),
                                            );

                                            _timeOut(timeOut);
                                          }
                                        : showLocationError,
                                    child: const Text("Time Out"),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                              error: (error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                              loading: () {
                                return const CircularProgressIndicator();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: USpace.space12),
              ],
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                'Error fetching schedule',
                style: const UTextStyle().textbasefontmedium.copyWith(
                      color: UColors.gray700,
                    ),
              ),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
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
    final enforcer = ref.watch(enforcerProvider);

    return Expanded(
      child: ref.watch(getTicketsByEnforcerIdStream(enforcer.id)).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              Ticket ticket = data[index];
              return ListTile(
                title: Text(
                  'Ticket # ${ticket.ticketNumber!.toString()}',
                  style: const UTextStyle().textbasefontmedium.copyWith(
                        color: UColors.gray700,
                      ),
                ),
                subtitle: Text(ticket.driverName!),
                onTap: () {
                  viewRecentTicket(ticket, context);
                },
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Error fetching tickets',
              style: const UTextStyle().textbasefontmedium.copyWith(
                    color: UColors.gray700,
                  ),
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
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
          const SizedBox(height: USpace.space16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Issued Tickets",
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
    ref.watch(violationsListProvider);
    ref.watch(vehicleTypeProvider);

    return Scaffold(
      key: _scaffoldKey,
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
      floatingActionButton: ref.watch(schedProviderStream).when(
        data: (attendance) {
          if (attendance == null) {
            return const SizedBox.shrink();
          }

          return ref.watch(attendanceProvider(attendance.shift)).when(
            data: (data) {
              if (data == null ||
                  !data.schedule.shift.isOnDuty ||
                  data.timeOut != null) {
                return const SizedBox.shrink();
              }

              return FloatingActionButton(
                onPressed: () {
                  showMenu();
                },
                child: const Icon(Icons.add),
              );
            },
            error: (error, stackTrace) {
              return const SizedBox.shrink();
            },
            loading: () {
              return const FloatingActionButton(
                onPressed: null,
                child: CircularProgressIndicator(),
              );
            },
          );
        },
        error: (error, stackTrace) {
          return const SizedBox.shrink();
        },
        loading: () {
          return const FloatingActionButton(
            onPressed: null,
            child: CircularProgressIndicator(),
          );
        },
      ),
      endDrawer: const NotificationDrawer(),
      bottomNavigationBar: const BottomNav(),
    );
  }

  void showNotOnScheduleError() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Not on schedule',
      text: 'You are not on schedule',
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    ref.read(licenseImageProvider).resetLicense();
                    ref.read(createTicketFormProvider).reset();
                    ref.read(ticketChangeNotifierProvider).resetTicket();
                    ref.invalidate(selectedViolationsProvider);
                    ref.invalidate(evidenceListProvider);
                    ref.invalidate(licenseImageProvider);
                    ref.invalidate(isSameWithDriver);
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
