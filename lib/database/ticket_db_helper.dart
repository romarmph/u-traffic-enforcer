import '../../../config/utils/exports.dart';

class TicketDBHelper {
  final _firestore = FirebaseFirestore.instance;

  Future<dynamic> saveTicket(Map<String, dynamic> ticketData) async {
    final counterCollection = _firestore.collection('counters');
    final ticketCountDocument = counterCollection.doc('ticketCounter');
    final ticketCollection = _firestore.collection('tickets');

    return await _firestore.runTransaction((transaction) async {
      final ticketDocSnapshot = await transaction.get(ticketCountDocument);

      if (!ticketDocSnapshot.exists) {
        throw Exception('ticketCount-doc-does-not-exist');
      }

      int newCount = ticketDocSnapshot.data()!['count'] + 1;
      transaction.update(ticketCountDocument, {'count': newCount});

      ticketData['ticketNumber'] = newCount;

      final Ticket ticket = Ticket.fromJson(ticketData);

      final QuerySnapshot snapshot = await ticketCollection
          .where('ticketNumber', isEqualTo: ticket.ticketNumber)
          .get();

      final List<DocumentSnapshot> ticketList = snapshot.docs;

      if (ticketList.isEmpty) {
        transaction.set(
          ticketCollection.doc(),
          ticket.toJson(),
        );
      } else {
        throw Exception('ticket-already-exists');
      }

      return ticket;
    });
  }
}
