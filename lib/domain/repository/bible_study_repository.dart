import 'package:icoc_admin_pannel/domain/model/bible_study.dart';

abstract class BibleStudyRepository {
  Future getBibleStudyList();
  Future addLesson(String bibleStudyId, Lesson lesson);
  Future editLesson(String bibleStudyId, Lesson lesson);
  Future addBibleStudy(BibleStudy bibleStudy);
}
