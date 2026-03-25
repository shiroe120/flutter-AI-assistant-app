import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

class AIService {

  final String modelId = 'doubao-seed-1-6-flash-250828';
  static const String _apiUrl = 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  // 一次性返回完整 AI 回复
  Future<String> sendMessageOnce(String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // 获取全局提示词
      final globalPrompt = prefs.getString('globalPrompt') ?? '';
      // 获取apikey
      final apiKey = prefs.getString('apiKey') ?? 'default_or_throw';

      if (apiKey == "default_or_throw") {
        return "⚠️ 您的 API Key 有误，请前往设置页面配置后再试。";
      }

      final response = await http.post(
        Uri.parse('https://ark.cn-beijing.volces.com/api/v3/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'doubao-1-5-lite-32k-250115',
          'messages': [
            {'role': 'user', 'content': message}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 假设返回结构为 data['choices'][0]['message']['content']
        final content = data['choices'][0]['message']['content'];
        return content ?? '';
      } else {
        print('AI 返回异常: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('sendMessageOnce 异常: $e');
      return '';
    }
  }

  //带历史对话流式获取流式回复
  Stream<String> sendMessageStreamWithMemory(List<ChatMessage> history, String userMessage, String imagePath) async* {
    final prefs = await SharedPreferences.getInstance();
    // 获取全局提示词
    final globalPrompt = prefs.getString('globalPrompt') ?? '';
    // 获取apikey
    final apiKey = prefs.getString('apiKey') ?? 'default_or_throw';
    if (apiKey == "default_or_throw") {
      yield "⚠️ 您的 API Key 有误，请前往设置页面配置后再试。";
      return;
    }
    // 获取modelId
    final modelId = prefs.getString('modelId') ?? 'doubao-seed-1-6-flash-250828';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };



    final maxLength = prefs.getInt("maxMemory") ?? 5;
    // 限制消息数量,后面设置里可以改
    if (history.length > maxLength) {
      history = history.sublist(history.length - maxLength);
    }
    // 构造用户消息内容，包含图片和文本，role需指定为user
    List<Map<String, dynamic>> userContent = [];
    if (imagePath.isNotEmpty) {
      try {
        final bytes = await File(imagePath).readAsBytes();
        final base64Image = base64Encode(bytes);
        userContent.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$base64Image',
            'detail': "low"
          }
        });
      } catch (e) {
        print('读取图片失败: $e  ');
      }
    }
    userContent.add({
      'type': 'text',
      'text': userMessage,
    });

// 构造消息数组，最后一条用户消息的role必须为user，content为图片和文本数组
    final messages = <Map<String, dynamic>>[
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
        'content': userContent,
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
      // 发送 HTTP 请求
      final response = await request.send();

      if (response.statusCode == 200) {
        // 将响应流转换为 UTF-8 字符串
        final utf8Stream = response.stream.transform(utf8.decoder);
        await for (final chunk in utf8Stream) {
          for (final line in LineSplitter.split(chunk)) {
            if (line.trim().isEmpty) continue;

            // 只处理以 data: 开头的行
            if (line.startsWith('data: ')) {
              final jsonPart = line.substring(6).trim();

              // 流式结束标志
              if (jsonPart == '[DONE]') break;

              try {
                // 解析 JSON 数据，提取内容
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
        // 非 200 状态码时返回错误信息
        yield '【流式请求失败】${response.statusCode}: ${await response.stream.bytesToString()}';
      }
    } catch (e) {
      // 网络或解析异常时返回错误信息
      yield '【连接异常】$e';
    }
  }



}
