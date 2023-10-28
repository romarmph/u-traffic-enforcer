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
          child: Consumer<EvidenceProvider>(
            builder: (context, provider, child) {
              if (provider.evidences.isEmpty) {
                return const Center(
                  child: Text(
                    "No evidence added yet",
                    style: TextStyle(
                      color: UColors.gray400,
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.separated(
                itemCount: provider.evidences.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: USpace.space20,
                ),
                itemBuilder: (context, index) {
                  final evidence = provider.evidences[index];
                  return EvidenceCard(evidence: evidence);
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: USpace.space16,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const EvidenceAddPage();
              },
            ));
          },
          label: const Text("Add Evidence"),
          icon: const Icon(Icons.add_a_photo_rounded),
        )
      ],
    );
  }
}
