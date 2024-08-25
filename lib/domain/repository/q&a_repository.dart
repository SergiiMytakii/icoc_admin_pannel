import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';

abstract class QandARepository {
  Future<List<QandAModel>> getArticles({required Languages lang});
  Future<List<QandAModel>> deleteQandA(IcocUser? user, String documentRef);
  Future<List<Languages>> getAllLangs();

  Future<List<QandAModel>> edit(IcocUser? user, QandAModel article);
}
