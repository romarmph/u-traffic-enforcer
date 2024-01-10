import 'package:intl/intl.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/attendance_db.dart';
import 'package:u_traffic_enforcer/database/enforcer_sched_db_helper.dart';
import 'package:u_traffic_enforcer/model/attendance.dart';
import 'package:u_traffic_enforcer/model/schedule.dart';
import 'package:u_traffic_enforcer/pages/common/bottom_nav.dart';
import 'package:calendar_view/calendar_view.dart';

class AttendancePage extends ConsumerWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Attendance"),
      ),
      body: ref.watch(mySchedulesProvider).when(
        data: (schedules) {
          return ref.watch(myAttendanceProvider).when(
            data: (data) {
              return MonthView(
                onCellTap: (events, date) {
                  if (didAttend(data, date)) {
                    final attend = data.firstWhere((element) {
                      final temp = element.schedule.scheduleDay!.toDate();
                      final day = DateTime(temp.year, temp.month, temp.day);
                      return day == date;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Attendance Details"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("Post"),
                                subtitle: Text(
                                  attend.schedule.postName,
                                ),
                              ),
                              ListTile(
                                title: const Text("Time In"),
                                subtitle: Text(
                                  DateFormat.jm()
                                      .format(attend.timeIn.toDate()),
                                ),
                              ),
                              ListTile(
                                title: const Text("Time Out"),
                                subtitle: Text(
                                  DateFormat.jm()
                                      .format(attend.timeOut!.toDate()),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                cellBuilder: (date, event, isToday, isInMonth) {
                  Color borderColor;
                  Color textColor;
                  IconData? iconData;

                  if (!isInMonth) {
                    borderColor = UColors.gray50;
                    textColor = UColors.gray400;
                  } else if (hasAttendance(schedules, date)) {
                    if (date.isBefore(DateTime.now())) {
                      if (didAttend(data, date)) {
                        borderColor = UColors.green500;
                        textColor = UColors.green500;
                        iconData = Icons.check_circle;
                      } else {
                        borderColor = UColors.red500;
                        textColor = UColors.red500;
                        iconData = Icons.close;
                      }
                    } else {
                      borderColor = UColors.gray500;
                      textColor = UColors.gray500;
                      iconData = Icons.circle_outlined;
                    }
                  } else {
                    borderColor = UColors.gray200;
                    textColor = UColors.black;
                  }

                  if (isToday) {
                    borderColor = UColors.blue500;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: isInMonth ? UColors.white : UColors.gray100,
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            date.day.toString(),
                            style:
                                const UTextStyle().textbasefontmedium.copyWith(
                                      color: textColor,
                                    ),
                          ),
                          if (iconData != null) ...[
                            const SizedBox(height: 4),
                            Icon(
                              iconData,
                              color: textColor,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text(
                  'Error fetching attendance data',
                  style: const UTextStyle().textbasefontmedium,
                ),
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
          return Center(
            child: Text(
              'Error fetching schedule data',
              style: const UTextStyle().textbasefontmedium,
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  bool hasAttendance(List<EnforcerSchedule> schedule, DateTime date) {
    for (var sched in schedule) {
      final day = DateTime(sched.scheduleDay!.toDate().year,
          sched.scheduleDay!.toDate().month, sched.scheduleDay!.toDate().day);
      if (day == date) {
        return true;
      }
    }

    return false;
  }

  bool didAttend(List<Attendance> attendance, DateTime date) {
    for (var attend in attendance) {
      final schedDate = attend.schedule.scheduleDay!.toDate();
      final day = DateTime(schedDate.year, schedDate.month, schedDate.day);
      if (day == date && attend.timeOut != null) {
        return true;
      }
    }

    return false;
  }
}

final myAttendanceProvider = StreamProvider<List<Attendance>>((ref) {
  final enforcerId = AuthService().currentUser!.uid;
  return AttendanceDBHelper.instance.getAttendanceList(enforcerId);
});

final mySchedulesProvider = StreamProvider<List<EnforcerSchedule>>((ref) {
  return ScheduleDBHelper.instance.getAllSchedules(
    AuthService().currentUser!.uid,
  );
});
