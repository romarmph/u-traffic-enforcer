import '../../../config/utils/exports.dart';

class EvidenceForm extends StatefulWidget {
  const EvidenceForm({super.key});

  @override
  State<EvidenceForm> createState() => _EvidenceFormState();
}

class _EvidenceFormState extends State<EvidenceForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(
              height: USpace.space20,
            ),
            itemBuilder: (context, index) {
              return Container(
                height: 400,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: UColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    const Placeholder(),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: USpace.space16,
        ),
        ElevatedButton.icon(
          onPressed: () {},
          label: const Text("Add Evidence"),
          icon: const Icon(Icons.add_a_photo_rounded),
        )
      ],
    );
  }
}
