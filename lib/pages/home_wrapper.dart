import '../config/utils/exports.dart';

const List<Widget> pages = [
  HomePage(),
  SettingsPage(),
];

class ViewWrapper extends ConsumerWidget {
  const ViewWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IndexedStack(
      index: ref.watch(navIndexProvider),
      children: pages,
    );
  }
}
