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
  @override
  Future<void> insertArticlesInNewLangs(
      IcocUser? user, Languages langToTranslate) async {
    final articles = await getArticles(lang: Languages.en);
    for (var article in articles) {
      if (article.id < 1662 && article.id > 0 && article.lang == Languages.en) {
        await _translateArticleToNewLang(user, article, langToTranslate);
      }
    }
  }

// translate articles from eng to the new languages
  Future _translateArticleToNewLang(
      IcocUser? user, QandAModel article, Languages langToTranslate) async {
    final outputTemplate = {
      'translatedTitle': 'place here translatedTitle',
      'tags': ['translated tags']
    };
    final query = {
      'lang': langToTranslate.name,
      'title': article.title,
      'tags': article.tags ?? [],
      'outputTemplate': outputTemplate
    };

    final promptTemplate = PromptTemplate.fromTemplate(r'''
        You are an expert Biblical translator with deep knowledge of theological concepts.
        Follow these steps:
        1. Identify the target language from the provided language code: {lang}.
        2. Translate the following title and tags to the target language
         title:  {title}. \n
         tags: [{tags}]. \n
        3. Ensure the translation maintains the original Biblical and theological context.
        4. Your responce shoud contain only translaed text without any additional words.
        5. return result as valid JSON using the following structure:
            {outputTemplate}
          ''');
    print('Processing Q&A ${article.id}');
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
        title: res['translatedTitle'],
        tags: tags,
        lang: langToTranslate,
        translatedBy: 'ChatGPT',
        author: 'Douglas Jacoby');
    firebaseDataSource.addToFirebase(
        user,
        // 'testQandA',
        FirebaseCollections.QandA.name,
        article.toJson());
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
