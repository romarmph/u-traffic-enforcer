import 'package:u_traffic_enforcer/config/utils/exports.dart';

class NavIndexProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

final navIndexProvider = ChangeNotifierProvider<NavIndexProvider>((ref) {
  return NavIndexProvider();
});
