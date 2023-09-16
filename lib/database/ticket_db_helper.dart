import '../../../config/utils/exports.dart';

class TicketDBHelper {
  TicketDBHelper._();

  static final TicketDBHelper _instance = TicketDBHelper._();

  static TicketDBHelper get instance => _instance;

  final _firestore = FirebaseFirestore.instance;

  final String _ticketCollection = 'tickets';
  final String _enforcerIDField = 'enforcerId';
  final String _dateCreatedField = 'dateCreated';

  final String _countersCollection = 'counters';
  final String _ticketCounterDocument = 'ticketCounter';
  final String _countField = 'count';

  Stream<List<Map<String, dynamic>>> getTicketsByEnforcerId(String enforcerID) {
    return FirebaseFirestore.instance
        .collection(_ticketCollection)
        .where(_enforcerIDField, isEqualTo: enforcerID)
        .orderBy(_dateCreatedField, descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((DocumentSnapshot document) {
        return document.data() as Map<String, dynamic>;
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

      Ticket updatedTicket = ticket.copyWith(
        ticketNumber: newCount,
        dateCreated: Timestamp.now(),
      );

      transaction.set(
        ticketCollection.doc(),
        updatedTicket.toJson(),
      );

      return updatedTicket;
    });
  }
}
