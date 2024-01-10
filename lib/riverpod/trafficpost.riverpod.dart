import 'package:u_traffic_enforcer/config/utils/exports.dart';
import 'package:u_traffic_enforcer/database/traffic_post_db_helper.dart';
import 'package:u_traffic_enforcer/model/traffic_post.dart';

final getTrafficpost = StreamProvider.family<TrafficPost, String>((ref, id) {
  return TrafficPostDB.instance.getTrafficPost(id);
});

final getAllPost = StreamProvider<List<TrafficPost>>((ref) {
  return TrafficPostDB.instance.getAllPost();
});

final allPostProvider = Provider<List<TrafficPost>>((ref) {
  final posts = ref.watch(getAllPost);
  return posts.when(
    data: (data) => data,
    loading: () => [],
    error: (_, __) => [],
  );
});
