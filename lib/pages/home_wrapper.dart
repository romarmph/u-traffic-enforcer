import '../config/utils/exports.dart';

class ViewWrapper extends StatefulWidget {
  const ViewWrapper({Key? key}) : super(key: key);

  @override
  State<ViewWrapper> createState() => ViewWrapperState();
}

class ViewWrapperState extends State<ViewWrapper> {
  final List<Widget> pages = [
    const HomePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavIndexProvider>(
      builder: (context, navigator, child) {
        return IndexedStack(
          index: navigator.currentIndex,
          children: pages,
        );
      },
    );
  }
}
