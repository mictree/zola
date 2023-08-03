import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zola/controller/auth_controller.dart';
import 'package:zola/models/chat_user_model.dart';
import 'package:zola/models/message_model.dart';
import 'package:zola/screens/chat_detail/components/chat_detail_app_bar.dart';
import 'package:zola/services/message.dart' as message_service;
import 'package:zola/services/room.dart' as room_service;
import 'package:zola/services/socket_service.dart';
import 'package:zola/utils/image_picker_helper.dart';
import 'package:zola/widgets/message_item.dart';
import 'package:zola/widgets/typing_indicator.dart';
import 'package:zola/widgets/video_player_detail.dart';

class ChatDetailScreen extends StatefulWidget {
  final String id;
  const ChatDetailScreen({super.key, required this.id});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<MessageModel> messages = [];
  List<String> typingUsers = [];
  ChatUserModel? roomInfo;
  bool _loading = true;
  File? image;
  File? video;
  bool emojiShowing = false;

  AudioPlayer audioPlayer = AudioPlayer();

  final SocketService socketService = Get.find<SocketService>();
  final userInfo = Get.find<AuthController>().getUserInfo();

  final FocusNode _focus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendFileMessage({required String type, required String roomId}) async {
    print("send file message: $type $roomId");
    if (image != null && video == null) {
      File imageFile = image!;

      setState(() {
        image = null;
      });

      MessageModel currentMessage = MessageModel(
          messageContent: imageFile.path,
          messageType: "sender",
          messageTime: DateTime.now().toString(),
          contentType: "image",
          state: MessageState.sending,
          isFromFile: true);

      setState(() {
        messages.insert(0, currentMessage);
      });

      MessageModel res = await message_service.sendFileMessage(
        roomId: roomId,
        type: 'image',
        image: imageFile.path,
      );

      //set change current state of message
      setState(() {
        messages[0].state = MessageState.sent;
      });

      //send socket message
      socketService.sendMessage({
        'message': res.messageContent,
        'roomId': roomId,
        'name': userInfo?.fullname,
        'type': "image",
        'userId': userInfo?.id,
        'avatarUrl': userInfo?.avatarUrl,
      });
    } else if (video != null) {
      MessageModel currentMessageVideo = MessageModel(
          messageContent: video!.path,
          messageType: "sender",
          messageTime: DateTime.now().toString(),
          contentType: "video",
          state: MessageState.sending,
          isFromFile: true);

      setState(() {
        messages.insert(0, currentMessageVideo);
      });

      MessageModel videoMess = await message_service.sendFileMessage(
        roomId: roomId,
        type: 'video',
        video: video!.path,
      );
      setState(() {
        messages[0].state = MessageState.sent;
      });
      socketService.sendMessage({
        'message': videoMess.messageContent,
        'roomId': roomId,
        'name': userInfo?.fullname,
        'type': "video",
        'userId': userInfo?.id,
        'avatarUrl': userInfo?.avatarUrl,
      });
    }
  }

  void sendMessage(
      String message, String roomId, String name, String imageUrl) {
    socketService.sendMessage({
      'message': message,
      'roomId': roomId,
      'name': name,
      'type': "text",
      'userId': userInfo?.id,
      'avatarUrl': imageUrl,
    });
    setState(() {
      messages.insert(
          0,
          MessageModel(
              messageContent: message,
              messageTime: DateTime.now().toString(),
              messageType: "sender",
              contentType: "text"));
    });

    socketService.onStopTyping({
      'roomId': widget.id,
      'userId': userInfo?.id,
    });
    // scroll bottom if send a messagoe
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 50),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  void _onFucusTextField() {
    if (_focus.hasFocus) {
      print('on Focus');
	  setState(() {
		emojiShowing = false;
	  });
      socketService.onTyping({
        'roomId': widget.id,
        'userId': userInfo?.id,
        'name': userInfo?.fullname,
      });
    }

    if (!_focus.hasFocus) {
      print('on stop Focus');
      socketService.onStopTyping({
        'roomId': widget.id,
        'userId': userInfo?.id,
        'name': userInfo?.fullname,
      });
    }
  }

  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
    setState(() {
      emojiShowing = false;
    });
  }

  @override
  initState() {
    _focus.addListener(_onFucusTextField);

    message_service
        .getMessageFromRoom(widget.id, refetch: true)
        .then((value) => setState(
              () {
                messages = value;
                _loading = false;
              },
            ));

    room_service
        .getRoomInfoById(widget.id, refetch: true)
        .then((value) => setState(() {
              roomInfo = value;
            }));

    socketService.onReceiveMessage((data) {
      try {
        if (data['userId'] != userInfo?.id && data['roomId'] == widget.id) {
          // play sound
          audioPlayer.play(AssetSource('audios/livechat.mp3'));
          setState(() {
            messages.insert(
                0,
                MessageModel(
                    messageContent: data['message'],
                    messageTime: DateTime.now().toString(),
                    messageType: "receiver",
                    contentType: data['type'],
                    senderName: data['name'],
                    senderImage: data['avatarUrl']));
          });
        }
        message_service
            .getMessageFromRoom(widget.id, refetch: true)
            .then((value) => setState(
                  () {
                    messages = value;
                  },
                ));
      } catch (e) {
        print("receive error");
      }
    });

    socketService.onReceiveTyping((data) {
      print('receive typing');
      if (data['roomId'] == widget.id && data['userId'] != userInfo?.id) {
        setState(() {
          // check if userId is already in typingUsers
          if (!typingUsers.contains(data['name'])) {
            typingUsers.add(data['name']);
          }
        });

        // _scrollController.animateTo(
        //   _scrollController.position.maxScrollExtent,
        //   duration: const Duration(milliseconds: 100),
        //   curve: Curves.fastOutSlowIn,
        // );
      }
    });

    socketService.onReceiveStopTyping((data) {
      try {
        print('receive stop typing');
        if (data['roomId'] == widget.id && data['userId'] != userInfo?.id) {
          setState(() {
            typingUsers.remove(data['name']);
          });
        }
      } catch (e) {
        print("error");
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _focus.removeListener(_onFucusTextField);
    _focus.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: roomInfo != null
          ? ChatDetailAppBar(
              id: roomInfo!.id,
              name: roomInfo!.name,
              imageUrl: roomInfo!.imageURL,
              isGroup: roomInfo!.isGroup,
            )
          : null,
      body: Stack(
        children: <Widget>[
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading && messages.isEmpty)
            const Center(child: Text("Không có tin nhắn nào")),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 50.0),
            child: CustomScrollView(
              reverse: true,
              slivers: [
                // user typing list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "${typingUsers[index]} đang nhập...",
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                              child: AnimatedTypingIndicator(),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: typingUsers.length,
                  ),
                ),
                // message list
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return MessageItem(message: messages[index]);
                    },
                    childCount: messages.length,
                  ),
                ),
              ],
            ),
          ),

          // input message
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                image != null || video != null
                    ? Container(
                        color: Colors.grey[200],
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            image != null
                                ? Image.file(File(image!.path))
                                : video != null
                                    ? SizedBox(
                                        height: 100,
                                        child: VideoPlayerDetail(
                                          videoUrl: video!.path,
                                          //   playFromUrl: false,
                                          isShowController: false,
                                        ),
                                      )
                                    : const SizedBox(),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                    video = null;
                                  });
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () {
                          //   if (_textController.text.isNotEmpty) {
                          //     sendMessage(_textController.text, widget.id,
                          //         userInfo!.fullname, userInfo!.avatarUrl);
                          //     _textController.clear();
                          //   }
                        },
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        backgroundColor: Colors.transparent,
                        child: const Icon(
                          Iconsax.image,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          // focus on textfield
                          _focus.requestFocus();
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });
                          if (emojiShowing) {
                            _focus.unfocus();
                          }
                        },
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        backgroundColor: Colors.transparent,
                        child: const Icon(
                          Iconsax.emoji_happy,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Chọn ảnh từ thư viện'),
                                      onTap: () {
                                        ImagePickerHelper.pickImageFromGallery()
                                            .then((value) {
                                          setState(() {
                                            image = value as File?;
                                          });
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_camera),
                                      title: const Text('Chụp ảnh'),
                                      onTap: () {
                                        ImagePickerHelper.pickImageFromCamera()
                                            .then((value) {
                                          setState(() {
                                            image = value as File?;
                                          });
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                          Icons.video_camera_back_sharp),
                                      title:
                                          const Text('Chọn video từ thư viện'),
                                      onTap: () {
                                        ImagePickerHelper.pickVideoFromGallery()
                                            .then((value) {
                                          setState(() {
                                            video = value as File?;
                                          });
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.attach_file),
                                      title: const Text('Chọn file'),
                                      onTap: () {
                                        // Xử lý chụp ảnh ở đây
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Iconsax.more,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: _focus,
                          controller: _textController,
                          //   onChanged: (value) {
                          //     socketService.onTyping({
                          //       'roomId': widget.id,
                          //       'userId': userInfo?.id,
                          //       'name': userInfo?.fullname,
                          //     });
                          //   },
                          decoration: InputDecoration(
                              hintText: "Nhập tin nhắn...",
                              hintStyle:
                                  GoogleFonts.notoSans(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                        //   FocusScope.of(context).unfocus();
                          if (_textController.text.isNotEmpty) {
                            sendMessage(_textController.text, widget.id,
                                userInfo!.fullname, userInfo!.avatarUrl);
                            _textController.clear();
                          }
                          if (_textController.text.isEmpty && image != null) {
                            sendFileMessage(roomId: widget.id, type: "image");
                          } else if (_textController.text.isEmpty &&
                              video != null) {
                            sendFileMessage(roomId: widget.id, type: "video");
                          }
                        },
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        child: const Icon(
                          Iconsax.send1,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                      height: 250,
                      child: EmojiPicker(
                        textEditingController: _textController,
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                          columns: 7,
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          //   initCategory: Category.RECENT,
                          bgColor: const Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          skinToneDialogBgColor: Colors.white,
                          skinToneIndicatorColor: Colors.grey,
                          enableSkinTones: true,
                          recentTabBehavior: RecentTabBehavior.RECENT,
                          recentsLimit: 28,
                          replaceEmojiOnLimitExceed: false,
                          noRecents: const Text(
                            'No Recents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          loadingIndicator: const SizedBox.shrink(),
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                          checkPlatformCompatibility: true,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
