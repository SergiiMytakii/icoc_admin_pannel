import 'package:icoc_admin_pannel/domain/model/bible_study.dart';

abstract class BibleStudyRepository {
  Future getBibleStudyList();
  Future editLesson(BibleStudy bibleStudy);
  Future addBibleStudy(BibleStudy bibleStudy);
  Future deleteBibleStudy(String bibleStudyId);
}
