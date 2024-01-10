import 'package:u_traffic_enforcer/pages/attendance/attendance.dart';

import '../../config/utils/exports.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: UColors.gray200)),
      ),
      child: BottomNavigationBar(
        currentIndex: ref.watch(navIndexProvider),
        onTap: (index) {
          if (index == 0) {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
              ),
            );
          } else if (index == 1) {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const AttendancePage(),
              ),
            );
          } else {
            Navigator.of(navigatorKey.currentContext!).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SettingsPage(),
              ),
            );
          }
          ref.watch(navIndexProvider.notifier).state = index;
        },
        backgroundColor: UColors.white,
        selectedItemColor: UColors.blue700,
        unselectedItemColor: UColors.gray600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Attendance",
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
            activeIcon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
