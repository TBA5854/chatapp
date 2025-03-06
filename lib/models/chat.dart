import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
@JsonSerializable()
@HiveType(typeId: 0)
class Chat with _$Chat {
  const factory Chat({
    @HiveField(0) required String sender,
    @HiveField(1) required String receiver,
    @HiveField(2) required String message,
    @HiveField(3) required DateTime time,
    @HiveField(4) required String messageId,
    @HiveField(5) required String? repliedMessage,
    @HiveField(6) bool? isSent,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@riverpod
class ChatState extends _$ChatState {
  late Box<Chat> _chatBox;

  @override
  List<Chat> build() {
    _chatBox = Hive.box<Chat>('chatBox');
    return _chatBox.values.toList();
  }

  void addMessage(Chat chat) {
    _chatBox.put(chat.messageId, chat);
    print("chat: $_chatBox.values");
    state = [chat, ...state]; 
  }

  void updateMessageId({required String newId, required String oldId}) {
    state = state.map((chat) {
      if (chat.messageId == oldId) {
        final updatedChat = chat.copyWith(messageId: newId);
        _chatBox.put(newId, updatedChat); 
        _chatBox.delete(oldId);
        return updatedChat;
      }
      return chat;
    }).toList();
  }

  void loadMessages() {
    state = _chatBox.values.toList(); // Ensure state updates when loading
  }
}
