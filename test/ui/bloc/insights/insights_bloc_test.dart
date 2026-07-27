import 'package:flutter_test/flutter_test.dart';
import 'package:icoc_admin_pannel/domain/model/insights/post.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/insights_repository.dart';
import 'package:icoc_admin_pannel/ui/bloc/insights/insights_bloc.dart';

void main() {
  test('shows newest insights first regardless of repository order', () async {
    final InsightsBloc bloc = InsightsBloc(
      repository: _FakeInsightsRepository(<Post>[
        _post('oldest', DateTime.utc(2026)),
        _post('newest', DateTime.utc(2026, 3)),
        _post('middle', DateTime.utc(2026, 2)),
      ]),
    );
    addTearDown(bloc.close);

    final Future<InsightsSuccess> success = bloc.stream
        .firstWhere((InsightsState state) => state is InsightsSuccess)
        .then((InsightsState state) => state as InsightsSuccess);

    bloc.add(const InsightsEvent.get());

    expect(
      (await success).posts.map((Post post) => post.id),
      <String>['newest', 'middle', 'oldest'],
    );
  });
}

Post _post(String id, DateTime createdAt) {
  return Post(
    id: id,
    type: PostType.image,
    language: 'en',
    title: id,
    author: const PostAuthor(name: 'Author', avatarUrl: ''),
    createdAt: createdAt,
  );
}

class _FakeInsightsRepository implements InsightsRepository {
  _FakeInsightsRepository(this.posts);

  final List<Post> posts;

  @override
  Future<List<Post>> getPosts({String? query, String? language}) async => posts;

  @override
  Future<List<Post>> addPost(IcocUser? user, Post post) async => posts;

  @override
  Future<List<Post>> editPost(IcocUser? user, Post post) async => posts;

  @override
  Future<List<Post>> deletePost(IcocUser? user, String id) async => posts;
}
