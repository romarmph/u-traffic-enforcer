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

  Stream<List<Ticket>> getRelatedTicketsStream(Ticket ticket) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection('tickets');

    List<Ticket> allTickets = [];

    if (ticket.licenseNumber!.isNotEmpty) {
      final result = await collection
          .where(
            'licenseNumber',
            isEqualTo: ticket.licenseNumber,
          )
          .get();
      var tickets = result.docs.map((e) {
        return Ticket.fromJson(
          e.data() as Map<String, dynamic>,
          e.id,
        );
      }).toList();
      allTickets.addAll(tickets);
    } else {
      if (ticket.plateNumber!.isNotEmpty) {
        final result = await collection
            .where(
              'plateNumber',
              isEqualTo: ticket.plateNumber,
            )
            .get();
        var tickets = result.docs.map((e) {
          return Ticket.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          );
        }).toList();
        allTickets.addAll(tickets);
      }

      if (ticket.engineNumber!.isNotEmpty) {
        final result = await collection
            .where(
              'engineNumber',
              isEqualTo: ticket.engineNumber,
            )
            .get();
        var tickets = result.docs.map((e) {
          return Ticket.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          );
        }).toList();
        allTickets.addAll(tickets);
      }

      if (ticket.chassisNumber!.isNotEmpty) {
        final result = await collection
            .where(
              'chassisNumber',
              isEqualTo: ticket.chassisNumber,
            )
            .get();
        var tickets = result.docs.map((e) {
          return Ticket.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          );
        }).toList();
        allTickets.addAll(tickets);
      }

      if (ticket.conductionOrFileNumber!.isNotEmpty) {
        final result = await collection
            .where(
              'conductionOrFileNumber',
              isEqualTo: ticket.conductionOrFileNumber,
            )
            .get();
        var tickets = result.docs.map((e) {
          return Ticket.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          );
        }).toList();
        allTickets.addAll(tickets);
      }

      if (ticket.driverName!.isNotEmpty) {
        final result = await collection
            .where(
              'driverName',
              isEqualTo: ticket.driverName,
            )
            .get();
        var tickets = result.docs.map((e) {
          return Ticket.fromJson(
            e.data() as Map<String, dynamic>,
            e.id,
          );
        }).toList();
        allTickets.addAll(tickets);
      }
    }

    yield allTickets;
  }
}
