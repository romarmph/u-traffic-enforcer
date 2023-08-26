import '../../../config/utils/exports.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: USpace.space24,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
