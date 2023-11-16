import 'package:u_traffic_enforcer/config/utils/exports.dart';

class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _scaffoldKey.currentState!.openEndDrawer();
      },
      icon: const Badge(
        isLabelVisible: false,
        child: Icon(
          Icons.notifications_outlined,
          size: USpace.space28,
        ),
      ),
    );
  }
}
