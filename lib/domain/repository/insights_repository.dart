import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class InsightsRepository {
  Future<List<Post>> getPosts({String? query, String? language});
  Future<List<Post>> addPost(IcocUser? user, Post post);
  Future<List<Post>> editPost(IcocUser? user, Post post);
  Future<List<Post>> deletePost(IcocUser? user, String id);
}

