import '../config/utils/exports.dart';

class ViewWrapper extends ConsumerStatefulWidget {
  const ViewWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<ViewWrapper> createState() => ViewWrapperState();
}

class ViewWrapperState extends ConsumerState<ViewWrapper> {
  final List<Widget> pages = [
    const HomePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigator = ref.watch(navIndexProvider);
    return IndexedStack(
      index: navigator.currentIndex,
      children: pages,
    );
  }
}
