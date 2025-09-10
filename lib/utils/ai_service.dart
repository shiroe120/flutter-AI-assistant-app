import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

class AIService {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'default_or_throw';
  final String modelId;

  static const String _apiUrl = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  AIService({
    this.modelId = 'doubao-1-5-lite-32k-250115',
  });


  // 完整获取回复
  Future<String> sendMessage(String userMessage) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
    final prefs = await SharedPreferences.getInstance();
    //获取提示词
    final globalPrompt = prefs.getString('globalPrompt') ?? '';
    

    final body = jsonEncode({
      'model': modelId,
      'messages': [
        {
          'role': 'system',
          'content': globalPrompt,
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

  // 流式获取回复
  Stream<String> sendMessageStream(String userMessage) async* {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final prefs = await SharedPreferences.getInstance();
    //获取提示词
    final globalPrompt = prefs.getString('globalPrompt') ?? '';

    final body = jsonEncode({
      'model': modelId,
      'stream': true,
      'messages': [
        {
          'role': 'system',
          'content': globalPrompt,
        },
        {'role': 'user', 'content': userMessage}
      ],
    });

    final request = http.Request('POST', Uri.parse(_apiUrl))
      ..headers.addAll(headers)
      ..body = body;

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final utf8Stream = response.stream.transform(utf8.decoder);
        await for (final chunk in utf8Stream) {
          for (final line in LineSplitter.split(chunk)) {
            if (line.trim().isEmpty) continue;

            if (line.startsWith('data: ')) {
              final jsonPart = line.substring(6).trim();

              if (jsonPart == '[DONE]') break;

              try {
                final decoded = jsonDecode(jsonPart);
                final delta = decoded['choices'][0]['delta'];
                if (delta != null && delta['content'] != null) {
                  yield delta['content'];
                }
              } catch (e) {
                print('解析失败: $e');
              }
            }
          }
        }
      } else {
        yield '【流式请求失败】${response.statusCode}: ${await response.stream.bytesToString()}';
      }
    } catch (e) {
      yield '【连接异常】$e';
    }
  }

  //带历史对话流式获取流式回复
  Stream<String> sendMessageStreamWithMemory(List<ChatMessage> history, String userMessage) async* {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final prefs = await SharedPreferences.getInstance();
    // 获取全局提示词
    final globalPrompt = prefs.getString('globalPrompt') ?? '';

    final maxLength = prefs.getInt("LongestLengthOfMemory") ?? 1;
    // 限制消息数量（只保留最近 20 条）,后面设置里可以改

    // 构造消息数组
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content': globalPrompt,
      },
      ...history.map((msg) => {
        'role': msg.role == 'user' ? 'user' : 'assistant',
        'content': msg.message,
      }),
      {
        'role': 'user',
        'content': userMessage,
      }
    ];

    final body = jsonEncode({
      'model': modelId,
      'stream': true,
      'messages': messages,
    });

    final request = http.Request('POST', Uri.parse(_apiUrl))
      ..headers.addAll(headers)
      ..body = body;

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final utf8Stream = response.stream.transform(utf8.decoder);
        await for (final chunk in utf8Stream) {
          for (final line in LineSplitter.split(chunk)) {
            if (line.trim().isEmpty) continue;

            if (line.startsWith('data: ')) {
              final jsonPart = line.substring(6).trim();

              if (jsonPart == '[DONE]') break;

              try {
                final decoded = jsonDecode(jsonPart);
                final delta = decoded['choices'][0]['delta'];
                if (delta != null && delta['content'] != null) {
                  yield delta['content'];
                }
              } catch (e) {
                print('解析失败: $e');
              }
            }
          }
        }
      } else {
        yield '【流式请求失败】${response.statusCode}: ${await response.stream.bytesToString()}';
      }
    } catch (e) {
      yield '【连接异常】$e';
    }
  }


}
