import 'package:icoc_admin_pannel/constants.dart';

abstract class QandARepository {
  Future getArticles();
  Future<List<Languages>> getAllLangs();
}
