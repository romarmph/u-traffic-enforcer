import '../../../config/utils/exports.dart';

class EvidenceForm extends ConsumerStatefulWidget {
  const EvidenceForm({super.key});

  @override
  ConsumerState<EvidenceForm> createState() => _EvidenceFormState();
}

class _EvidenceFormState extends ConsumerState<EvidenceForm> {
  @override
  Widget build(BuildContext context) {
    final evidenceProvider = ref.watch(evidenceListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _buildEvidences(
            evidenceProvider,
          ),
        ),
        const SizedBox(
          height: USpace.space16,
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const EvidenceAddPage();
                },
              ),
            );
          },
          label: const Text("Add Evidence"),
          icon: const Icon(Icons.add_a_photo_rounded),
        )
      ],
    );
  }

  Widget _buildEvidences(List<Evidence> provider) {
    if (provider.isEmpty) {
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
      itemCount: provider.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: USpace.space20,
      ),
      itemBuilder: (context, index) {
        final evidence = provider[index];
        return EvidenceCard(evidence: evidence);
      },
    );
  }
}
