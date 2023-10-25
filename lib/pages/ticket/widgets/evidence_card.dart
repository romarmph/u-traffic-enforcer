import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EvidenceCard extends StatelessWidget {
  const EvidenceCard({
    super.key,
    required this.evidence,
  });

  final Evidence evidence;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        USpace.space12,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: UColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: UColors.gray100,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Image.file(
            height: 200,
            File(evidence.path),
            fit: BoxFit.fill,
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(evidence.name),
            subtitle: evidence.description != null
                ? Text(evidence.description!)
                : null,
            trailing: IconButton(
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: "Delete Evidence",
      text: "Are you sure you want to delete this evidence?",
      type: QuickAlertType.warning,
      showCancelBtn: true,
      confirmBtnText: "Delete",
      onConfirmBtnTap: () {
        final provider = Provider.of<EvidenceProvider>(context, listen: false);
        provider.removeEvidence(evidence);
        Navigator.of(context).pop();
      },
    );
  }
}
