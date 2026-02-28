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
      orderBy: {'createdAt': true},
    );
    final String normalizedQuery = (query ?? '').trim().toLowerCase();
    final String normalizedLanguage = (language ?? '').trim().toLowerCase();

    return snapshot.docs.map(_postFromDoc).where((Post post) {
      final bool matchesLanguage = normalizedLanguage.isEmpty ||
          post.language.toLowerCase() == normalizedLanguage;
      final bool matchesQuery = normalizedQuery.isEmpty ||
          (post.title ?? '').toLowerCase().contains(normalizedQuery) ||
          (post.content ?? '').toLowerCase().contains(normalizedQuery) ||
          post.author.name.toLowerCase().contains(normalizedQuery);
      return matchesLanguage && matchesQuery;
    }).toList(growable: false);
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
    return snapshot.docs.map(_postFromDoc).toList(growable: false);
  }

  Post _postFromDoc(QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(doc.data() as Map<String, dynamic>);
    data['id'] = (data['id'] ?? doc.id).toString();
    return Post.fromJson(data);
  }
}
