import 'package:u_traffic_enforcer/config/utils/exports.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      minVerticalPadding: 0,
      leading: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: UColors.red400,
        ),
      ),
      minLeadingWidth: 8,
      visualDensity: VisualDensity.compact,
      title: const Text("Notification Title"),
      subtitle: const Text("Subtitle of the notification"),
      onTap: () => _showNotification(context),
    );
  }

  void _showNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: UColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              USpace.space12,
            ),
          ),
          contentPadding: const EdgeInsets.all(
            USpace.space12,
          ),
          actionsPadding: const EdgeInsets.all(
            USpace.space12,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notification Title",
                style: const UTextStyle().textxlfontsemibold,
              ),
              const Divider(),
              const Text('Notifica tion content'),
            ],
          ),
          actions: const [
            TextButton(
              onPressed: popCurrent,
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
