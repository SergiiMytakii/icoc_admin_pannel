import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@prod
@Injectable(as: BibleStudyRepository)
class BibleStudyRepositoryImpl extends BibleStudyRepository {
  final FirebaseDataSource firebaseDataSource;

  BibleStudyRepositoryImpl({required this.firebaseDataSource});
  @override
  Future getBibleStudyList() async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
      FirebaseCollections.BibleStudy.name,
    );
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    //migration to v2.  Remove later
    // final user = getIt<AuthBloc>().icocUser;
    // for (final bibleStudy in bibleStudies) {
    //   final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
    //       user,
    //       'BibleStudyV2',
    //       bs.BibleStudyV2(
    //         id: bibleStudy.id,
    //         lang: languagesToEnumMap[bibleStudy.lang]!,
    //         topic: bibleStudy.topic,
    //         subtopic: bibleStudy.subtopic,
    //         lessons: bibleStudy.lessons
    //             .map((lesson) => bs.Lesson(
    //                 id: lesson.id, title: lesson.title, text: lesson.text))
    //             .toList(),
    //       ).toJson());
    // }
    return bibleStudies;
  }

  @override
  Future addBibleStudy(IcocUser? user, BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.BibleStudy.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future editLesson(IcocUser? user, BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.BibleStudy.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future deleteBibleStudy(IcocUser? user, String bibleStudyId) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.BibleStudy.name, bibleStudyId);
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }
}
