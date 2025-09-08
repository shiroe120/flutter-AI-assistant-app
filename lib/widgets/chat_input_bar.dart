import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/speech_to_text_helper.dart';
import '../viewModel/msg_manager.dart';
import '../themes/light_theme.dart';
import '../utils/ai_service.dart';
import '../utils/msg_sender.dart';


class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function() send;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.send,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool hasText = false;
  bool isVoiceMode = false;
  bool isRecording = false;
  DateTime? startTime;

  final speechHelper = SpeechToTextHelper(); // 工具类实例

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final isNotEmpty = widget.controller.text.trim().isNotEmpty;
    if (hasText != isNotEmpty) {
      setState(() {
        hasText = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: isVoiceMode
                ? GestureDetector(
              onLongPressStart: (_) async {
                startTime = DateTime.now();
                print("长按成功");
                setState(() {
                  isRecording = true; // 开始录音动画
                });
                await speechHelper.startListening();
              },
              onLongPressEnd: (_) async {
                setState(() {
                  isRecording = false; // 停止录音动画
                });
                final duration = DateTime.now().difference(startTime!);
                print("录音时长: ${duration.inMilliseconds} ms");
                final result = await speechHelper.stopListeningAndTranscribe();
                widget.controller.text += result;
                setState(() {
                  hasText = widget.controller.text.trim().isNotEmpty;
                  isVoiceMode = false; // 录完回到键盘模式
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 48,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isRecording
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.3) // 动画变色
                      : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isRecording
                      ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    )
                  ]
                      : [],
                ),
                child: Text(
                  isRecording ? "正在录音..." : "按住说话",
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            )
                : TextField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: '请输入消息...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),



          // voice button
          IconButton(
            onPressed: () {
              setState(() {
                isVoiceMode = !isVoiceMode;
              });
            },
            icon: Icon(
              isVoiceMode ? Icons.keyboard : Icons.keyboard_voice,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),


          IconButton(
            icon: const Icon(Icons.send),
            color: hasText
                ? Theme.of(context).colorScheme.primary
                : Colors.grey, // 根据输入内容变色
            onPressed: hasText
                ? () async {
              await widget.send();
            }
                : null, // 可选禁用点击
          ),
        ],
      ),
    );
  }
}

