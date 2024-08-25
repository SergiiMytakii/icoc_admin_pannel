import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/data_sources/ai_data_source.dart';
import 'package:icoc_admin_pannel/domain/data_sources/firebase_data_source.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/domain/model/user.dart';
import 'package:icoc_admin_pannel/domain/repository/q&a_repository.dart';

import 'package:injectable/injectable.dart';

import 'package:langchain/langchain.dart';
import 'package:intl/intl.dart';

@dev
@prod
@Injectable(as: QandARepository)
class QandARepositoryImpl extends QandARepository {
  final FirebaseDataSource firebaseDataSource;
  final AiDataSource aiDataSource;
  QandARepositoryImpl(
    this.firebaseDataSource,
    this.aiDataSource,
  ) {
    print('QandARepositoryImpl constructor called, updating languages');
    firebaseDataSource.updateQandALangsFirebase();
  }

  @override
  Future<List<QandAModel>> getArticles({
    required Languages lang,
  }) async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
        // 'QandAEng',
        FirebaseCollections.QandA.name,
        filters: {'lang': lang.name},
        orderBy: {'id': true});
    final List<QandAModel> articles = snapshot.docs.map(
      (doc) {
        final article =
            QandAModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);

        return article;
      },
    ).toList();
    // await _insertToRus(articles);

    return articles;
  }

  @override
  Future<List<Languages>> getAllLangs() async {
    final QuerySnapshot snapshot = await firebaseDataSource.getFromFirebase(
      FirebaseCollections.QandALangs.name,
    );
    final List<Languages> langs = [];

    snapshot.docs.forEach((doc) {
      final langsMap = doc.data() as Map<String, dynamic>;
      for (final lang in langsMap['QandAlangs']) {
        langs.add(convertLanguagesEnum(lang));
      }
    });
    return langs;
  }

//used for translating articles to russian and inserting into firestore collection
  Future<void> _insertToRus(List<QandAModel> articles) async {
    for (var article in articles) {
      if (article.id < 1662 && article.id > 1660) {
        print('insert article: ${article.title}');
        firebaseDataSource.postToFirebase(IcocUser.defaultUser(),
            FirebaseCollections.QandA.name, article.toJson());
      }
    }
  }

  Future _translateArticleToRus(QandAModel article) async {
    final outputTemplate = {
      'translatedTitle': 'place here translatedTitle',
      'tags': ['translated tags']
    };
    final query = {
      'title': article.title,
      'tags': article.tags ?? [],
      'outputTemplate': outputTemplate
    };

    final promptTemplate = PromptTemplate.fromTemplate(r'''
          Translate the following title and tags to the russian language:
         title:  {title}. \n
         tags: [{tags}]. \n
         Your responce shoud contain only translaed text without any additional words.
         Keep in mind that context of the title is a Biblical quote and should be translated accordingly.
         return result as valid JSON using the following structure:
            {outputTemplate}
          ''');
    print(article.id);
    final res = await aiDataSource.getAiResponse(promptTemplate, query);
    print(res.toString());
    final date = article.date;
    if (date != null && date.isNotEmpty) {
      final parsedDate = DateFormat('MMMM d, yyyy').parse(date);
      final formattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

      article = article.copyWith(date: formattedDate);
    }
    List<String>? tags;
    if (res['tags'] is! List<List>) {
      try {
        tags = res['tags'] != null ? List<String>.from(res['tags']) : null;
      } catch (e) {
        print('Error processing tags: $e');
        tags = null;
      }
    }
    article = article.copyWith(
        id: article.id + 884,
        title: res['translatedTitle'],
        tags: tags,
        lang: Languages.ru,
        translatedBy: 'ChatGPT',
        author: 'Даглас Джакоби');
    firebaseDataSource.postToFirebase(IcocUser.defaultUser(),
        FirebaseCollections.QandA.name, article.toJson());
  }

  @override
  Future<List<QandAModel>> deleteQandA(
      IcocUser? user, String documentRef) async {
    final QuerySnapshot snapshot = await firebaseDataSource.deleteToFirebase(
        user, FirebaseCollections.QandA.name, documentRef);
    final List<QandAModel> articles = snapshot.docs.map(
      (doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return QandAModel.fromJson(data, doc.id);
      },
    ).toList();
    return articles;
  }

  @override
  Future<List<QandAModel>> edit(IcocUser? user, QandAModel article) async {
    final QuerySnapshot snapshot = await firebaseDataSource.postToFirebase(
        user, FirebaseCollections.QandA.name, article.toJson(),
        docReference: article.documentRef);
    final List<QandAModel> bibleStudies = snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return QandAModel.fromJson(data, doc.id);
    }).toList();
    return bibleStudies;
  }
}
