import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/traffic_post_db_helper.dart';
import 'package:u_traffic_enforcer/model/traffic_post.dart';

final getTrafficpost = StreamProvider.family<TrafficPost, String>((ref, id) {
  return TrafficPostDB.instance.getTrafficPost(id);
});
