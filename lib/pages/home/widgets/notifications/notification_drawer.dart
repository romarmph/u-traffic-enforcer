import 'package:u_traffic_enforcer/config/utils/exports.dart';

class NotificationDrawer extends StatelessWidget {
  const NotificationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: UColors.white,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: USpace.space8,
            horizontal: USpace.space12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NotificationDrawerHeader(),
              const Divider(
                height: 1,
                color: UColors.gray300,
              ),
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const NotificationTile();
                  },
                ),
              ),
              // const Expanded(
              //   child: NotificationsEmptyState(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationDrawerHeader extends StatelessWidget {
  const NotificationDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Notifications',
            style: const UTextStyle().textxlfontsemibold,
          ),
        ),
        TextButton(
          onPressed: () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              onConfirmBtnTap: () {
                debugPrint('cleared');
                popCurrent();
              },
            );
          },
          style: Theme.of(context).textButtonTheme.style!.copyWith(
                padding: MaterialStateProperty.all(
                  EdgeInsets.zero,
                ),
              ),
          child: const Text(
            'Clear All',
          ),
        ),
      ],
    );
  }
}
