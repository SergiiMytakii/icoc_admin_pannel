import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/insights_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@prod
@Injectable(as: InsightsRepository)
class InsightsRepositoryImpl implements InsightsRepository {
  final FirebaseDataSource firebaseDataSource;

  InsightsRepositoryImpl({required this.firebaseDataSource});

  @override
  Future<List<Post>> getPosts({String? query, String? language}) async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
      FirebaseCollections.Insights.name,
      search: query != null && query.isNotEmpty ? {'title': query} : null,
      filters: language != null && language.isNotEmpty
          ? {'language': language}
          : null,
      orderBy: {'createdAt': true},
    );
    final List<Post> posts = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Post.fromJson(data);
    }).toList();
    return posts;
  }

  @override
  Future<List<Post>> addPost(IcocUser? user, Post post) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.Insights.name, post.toJson());
    return _listFromSnapshot(snapshot);
  }

  @override
  Future<List<Post>> editPost(IcocUser? user, Post post) async {
    final QuerySnapshot snapshot = await firebaseDataSource.updateToFirebase(
        user, FirebaseCollections.Insights.name, post.id, post.toJson());
    return _listFromSnapshot(snapshot);
  }

  @override
  Future<List<Post>> deletePost(IcocUser? user, String id) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.Insights.name, id);
    return _listFromSnapshot(snapshot);
  }

  List<Post> _listFromSnapshot(QuerySnapshot snapshot) {
    final List<Post> posts = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Post.fromJson(data);
    }).toList();
    return posts;
  }
}

