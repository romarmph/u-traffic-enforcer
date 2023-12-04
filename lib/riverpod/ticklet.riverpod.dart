import 'package:u_traffic_enforcer/config/utils/exports.dart';

final getTicketsByEnforcerIdStream =
    StreamProvider.family<List<Ticket>, String>((ref, enforcerId) {
  return TicketDBHelper.instance.getTicketsByEnforcerId(enforcerId);
});

final relatedTicketsStream =
    StreamProvider.family<List<Ticket>, Ticket>((ref, ticket) {
  return TicketDBHelper.instance.getRelatedTicketsStream(ticket);
});
