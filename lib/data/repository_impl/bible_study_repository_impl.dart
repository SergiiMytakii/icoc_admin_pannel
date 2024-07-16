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
  Future editLesson(BibleStudy bibleStudy) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        FirebaseCollections.BibleStudy.name, bibleStudy.toJson());
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }

  @override
  Future deleteBibleStudy(String bibleStudyId) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        FirebaseCollections.BibleStudy.name, bibleStudyId);
    final List<BibleStudy> bibleStudies = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return BibleStudy.fromJson(data);
    }).toList();
    return bibleStudies;
  }
}
