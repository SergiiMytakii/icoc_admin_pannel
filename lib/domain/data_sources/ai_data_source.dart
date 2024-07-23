import 'package:langchain/langchain.dart';

abstract class AiDataSource {
  Future<Map<String, dynamic>> getAiResponse(
      PromptTemplate question, Map<String, dynamic> query);
}
