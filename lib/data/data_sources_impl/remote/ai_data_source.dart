import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:icoc_admin_pannel/domain/data_sources/ai_data_source.dart';
import 'package:icoc_admin_pannel/env.dart';
import 'package:injectable/injectable.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_openai/langchain_openai.dart';

@dev
@prod
@Injectable(as: AiDataSource)
class AiDataSourceImpl implements AiDataSource {
  final llm = ChatOpenAI(
    apiKey: openAIKey,
    defaultOptions: const ChatOpenAIOptions(
      responseFormat: ChatOpenAIResponseFormat(
        type: ChatOpenAIResponseFormatType.jsonObject,
      ),
    ),
  );
  @override
  Future<Map<String, dynamic>> getAiResponse(
      PromptTemplate promptTemplate, Map<String, dynamic> query) async {
    final chain = promptTemplate.pipe(llm).pipe(JsonOutputParser());
    final result = await chain.invoke(query);
    return result;
  }
}
