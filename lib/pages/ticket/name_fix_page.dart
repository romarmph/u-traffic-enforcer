import '../../config/utils/exports.dart';

class NameFixPage extends StatefulWidget {
  const NameFixPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<NameFixPage> createState() => _NameFixPageState();
}

class _NameFixPageState extends State<NameFixPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Arrange Name"),
      ),
      body: Center(
        child: Text(
          widget.data.toString(),
        ),
      ),
    );
  }
}
