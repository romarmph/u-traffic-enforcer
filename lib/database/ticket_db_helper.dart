import '../../../config/utils/exports.dart';

class TicketDBHelper {
  TicketDBHelper._();

  static final TicketDBHelper _instance = TicketDBHelper._();

  static TicketDBHelper get instance => _instance;

  final _firestore = FirebaseFirestore.instance;

  static const String _ticketCollection = 'tickets';
  static const String _enforcerIDField = 'enforcerID';
  static const String _dateCreatedField = 'dateCreated';
  static const String _countersCollection = 'counters';
  static const String _ticketCounterDocument = 'ticketCounter';
  static const String _countField = 'count';

  Stream<List<Ticket>> getTicketsByEnforcerId(String enforcerID) {
    return FirebaseFirestore.instance
        .collection(_ticketCollection)
        .where(_enforcerIDField, isEqualTo: enforcerID)
        .orderBy(_dateCreatedField, descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      if (snapshot.docs.isEmpty) return List.empty();

      return snapshot.docs.map((DocumentSnapshot document) {
        print(document.data());
        return Ticket.fromJson(document.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<Ticket> createTicket(Ticket ticket) async {
    final ticketCountDocument =
        _firestore.doc('$_countersCollection/$_ticketCounterDocument');
    final ticketCollection = _firestore.collection(_ticketCollection);

    return await _firestore.runTransaction((transaction) async {
      final ticketDocSnapshot = await transaction.get(ticketCountDocument);

      if (!ticketDocSnapshot.exists) {
        throw Exception('ticketCount-doc-does-not-exist');
      }

      int newCount = ticketDocSnapshot.data()![_countField] + 1;
      transaction.update(ticketCountDocument, {_countField: newCount});

      final snapshot = await ticketCollection
          .where('ticketNumber', isEqualTo: newCount)
          .get();

      if (snapshot.docs.isNotEmpty) {
        throw Exception('ticket-already-exists');
      }

      var newDocRef = ticketCollection.doc();
      String newDocId = newDocRef.id;

      Ticket updatedTicket = ticket.copyWith(
        ticketNumber: newCount,
        dateCreated: Timestamp.now(),
      );

      transaction.set(
        newDocRef,
        updatedTicket.toJson(),
      );

      return updatedTicket.copyWith(
        id: newDocId,
      );
    });
  }
}
