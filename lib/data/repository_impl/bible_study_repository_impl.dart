import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study.dart';
import 'package:icoc_admin_pannel/domain/repository/bible_study_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

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
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future addBibleStudy(BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        FirebaseCollections.BibleStudy.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future addLesson(String bibleStudyId, Lesson lesson) {
    // TODO: implement addLesson
    throw UnimplementedError();
  }

  @override
  Future editLesson(String bibleStudyId, Lesson lesson) {
    // TODO: implement editLesson
    throw UnimplementedError();
  }
}

List<BibleStudy> _listFromSnapshot(QuerySnapshot snapshot) {
  final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
    //получаем все уроки как Map
    final Map lessons = doc.get('lessons') as Map;
    final List<Lesson> less = [];

    lessons.forEach((key, lesson) {
      less.add(Lesson(
          id: int.parse(key),
          title: lessons[key]['title'] ?? lessons[key]['titile'],
          text: lessons[key]['text']));
    });
    less.sort(
      (a, b) => a.id.compareTo(b.id),
    );
    return BibleStudy(
        topic: doc.id,
        id: doc.get('id'),
        subtopic: doc.get('subtopic'),
        lessons: less,
        lang: doc.get('lang'));
  }).toList();
  return bibleStudies;
}
