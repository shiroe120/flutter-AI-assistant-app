import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import '../utils/speech_to_text_helper.dart';


class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function() send;
  final Function(String imagePath)? onPicked;


  const ChatInputBar({
    super.key,
    required this.controller,
    required this.send,
    this.onPicked,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool hasText = false;
  bool isVoiceMode = false;
  bool isRecording = false;
  bool _showAddCards = false; // 控制加号卡片显示
  DateTime? startTime;
  //图片路径
  String _imagePath = '';

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
    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter, // 从上往下展开/收起
      child:Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        margin: const EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 8),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            //如果图片路径不为空，显示图片预览
            _imagePath.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_imagePath),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imagePath = '';
                              });
                              if (widget.onPicked != null) {
                                widget.onPicked!('');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Row(
              children: [
                // 加号的图标按钮
                IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      _showAddCards ? Icons.expand_circle_down_rounded : Icons.add_circle_outline_rounded,
                      key: ValueKey(_showAddCards),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      // 控制卡片显示的状态
                      _showAddCards = !_showAddCards;
                    });
                  },
                ),

                // 输入框
                Expanded(
                  child: isVoiceMode
                      ? GestureDetector(
                          onTapDown: (_) async {
                            startTime = DateTime.now();
                            setState(() {
                              isRecording = true; // 开始录音动画
                            });
                            await speechHelper.startListening();
                          },
                          onTapUp: (_) async {
                            setState(() {
                              isRecording = false; // 停止录音动画
                            });
                            final duration = DateTime.now().difference(startTime!);
                            final result = await speechHelper.stopListeningAndTranscribe();
                            widget.controller.text += result;
                            setState(() {
                              hasText = widget.controller.text.trim().isNotEmpty;
                              isVoiceMode = false; // 录完回到键盘模式
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 48,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isRecording
                                  ? Theme.of(context).colorScheme.primary.withOpacity(0.7) // 动画变色
                                  : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: isRecording
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary,
                                        blurRadius: 2,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              isRecording ? "正在录音..." : "按住说话",
                              style: TextStyle(color: isRecording ? Colors.white : Colors.black45, fontSize: 16),
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

                //发送按钮
                IconButton(
                  icon: const Icon(Icons.send),
                  //没有文字时变成灰色
                  color: hasText
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey, // 根据输入内容变色
                  onPressed: hasText
                      ? () async {
                    setState(() {
                      _showAddCards = false; // 发送后隐藏加号卡片
                      _imagePath = ''; // 发送后清空图片路径
                    });
                    await widget.send();

                        }
                      : null, // 可选禁用点击
                ),
              ],
            ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 80),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
            );
          },
          child: _showAddCards
        ? Padding(
            key: const ValueKey('addCards'),
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 32,
                ),
                //拍照按钮
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _imagePath = pickedFile.path;
                      });
                      if (widget.onPicked != null) {
                        widget.onPicked!(pickedFile.path);
                      }
                    }
                  },
                  child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 0,
                            color:  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                width: 0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_enhance_rounded, size: 32, color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                          const Text('拍照', style: TextStyle(fontSize: 14)),
                        ],
                      )
                  ),
                ),
                //图库按钮
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _imagePath = pickedFile.path;
                      });
                      if (widget.onPicked != null) {
                        widget.onPicked!(pickedFile.path);
                      }
                    }
                  },
                  child: SizedBox(
                      width: 80,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                width: 0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Icon(Icons.photo_rounded, size: 32, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          const Text('图库', style: TextStyle(fontSize: 14)),
                        ],
                      )
                  ),
                ),

              ],
            ),
          )
        : const SizedBox.shrink(),
        )
          ],
        ),
      ),
    );
  }
}

