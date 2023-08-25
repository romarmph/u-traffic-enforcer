import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_traffic_enforcer/model/ticket_model.dart';

class TicketDBHelper {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveTicket(Map<String, dynamic> ticketData) async {
    final counterCollection = _firestore.collection('counters');
    final ticketCountDocument = counterCollection.doc('ticketCounter');

    return _firestore.runTransaction((transaction) async {
      final ticketDocSnapshot = await transaction.get(ticketCountDocument);

      if (!ticketDocSnapshot.exists) {
        throw Exception('ticketCount document does not exist!');
      }

      int newCount = ticketDocSnapshot.data()!['count'] + 1;
      transaction.update(ticketCountDocument, {'count': newCount});

      ticketData['ticketNumber'] = newCount;

      final Ticket ticket = Ticket.fromJson(ticketData);

      final ticketCollection = _firestore.collection('tickets');
      transaction.set(
        ticketCollection.doc(),
        ticket.toJson(),
      );
    });
  }
}
