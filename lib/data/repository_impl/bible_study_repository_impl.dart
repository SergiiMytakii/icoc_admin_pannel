import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
// import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
// import 'package:icoc_admin_pannel/domain/model/bible_study.dart' as bsOld;
// import 'package:icoc_admin_pannel/injection.dart';
// import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
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
      FirebaseCollections.BibleStudyV2.name,
    );
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    //migration to v2.  Remove later
    // final user = getIt<AuthBloc>().icocUser;
    // for (final bibleStudy in bibleStudies) {
    //   if (bibleStudy.id == 12)
    //     await firebaseDataSource.postToFirebase(
    //         user,
    //         'BibleStudyV2',
    //         BibleStudy(
    //           id: bibleStudy.id,
    //           lang: languagesToEnumMap[bibleStudy.lang]!,
    //           topic: bibleStudy.topic,
    //           subtopic: bibleStudy.subtopic,
    //           lessons: bibleStudy.lessons
    //               .map((lesson) => Lesson(
    //                   id: lesson.id, title: lesson.title, text: lesson.text))
    //               .toList(),
    //         ).toJson());
    // }
    return bibleStudies;
  }

  @override
  Future addBibleStudy(IcocUser? user, BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.BibleStudyV2.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future editLesson(IcocUser? user, BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.BibleStudyV2.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future deleteBibleStudy(IcocUser? user, String bibleStudyId) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.BibleStudyV2.name, bibleStudyId);
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }
}
