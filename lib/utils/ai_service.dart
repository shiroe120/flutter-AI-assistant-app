import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'default_or_throw';
  final String modelId;

  static const String _apiUrl = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  AIService({
    this.modelId = 'doubao-1-5-lite-32k-250115', // 默认模型
  });

  /// 发送消息，获取模型回复
  Future<String> sendMessage(String userMessage) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'model': modelId,
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user',
          'content': userMessage
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['choices'][0]['message']['content'];
        return message;
      } else {
        print('请求失败，状态码: ${response.statusCode}');
        print('响应内容: ${response.body}');
        return '请求失败: ${response.statusCode}';
      }
    } catch (e) {
      print('请求异常: $e');
      return '请求异常: $e';
    }
  }
}
