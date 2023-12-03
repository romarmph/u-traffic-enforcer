import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/model/traffic_post.dart';

class TrafficPostDB {
  const TrafficPostDB._();

  static const TrafficPostDB _instance = TrafficPostDB._();
  static TrafficPostDB get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _collection = _firestore.collection('trafficPosts');

  Stream<TrafficPost> getTrafficPost(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      return TrafficPost.fromJson(snapshot.data()!, snapshot.id);
    });
  }
}
