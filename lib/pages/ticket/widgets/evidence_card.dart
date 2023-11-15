import 'package:cached_network_image/cached_network_image.dart';
import 'package:u_traffic_enforcer/config/utils/exports.dart';

class EvidenceCard extends ConsumerStatefulWidget {
  const EvidenceCard({
    super.key,
    required this.evidence,
    this.isPreview = false,
    this.isNetowrkImage = false,
  });

  final bool isPreview;
  final Evidence evidence;
  final bool isNetowrkImage;

  @override
  ConsumerState<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends ConsumerState<EvidenceCard> {
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
          widget.isNetowrkImage
              ? CachedNetworkImage(
                  imageUrl: widget.evidence.path,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  height: 200,
                )
              : Image.file(
                  height: 200,
                  File(widget.evidence.path),
                  fit: BoxFit.fill,
                ),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(widget.evidence.name),
            subtitle: widget.evidence.description != null
                ? Text(widget.evidence.description!)
                : null,
            trailing: widget.isPreview
                ? null
                : IconButton(
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
        final provider = ref.watch(evidenceChangeNotifierProvider);
        final licenseImage = ref.watch(licenseImageProvider);

        if (widget.evidence.id == "default") {
          licenseImage.resetLicense();
          provider.removeEvidence(widget.evidence);
        } else {
          provider.removeEvidence(widget.evidence);
        }

        Navigator.of(context).pop();
      },
    );
  }
}
