import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class BibleStudyRepository {
  Future getBibleStudyList();
  Future editLesson(IcocUser? user, BibleStudy bibleStudy);
  Future addBibleStudy(IcocUser? user, BibleStudy bibleStudy);
  Future deleteBibleStudy(IcocUser? user, String bibleStudyId);
}
