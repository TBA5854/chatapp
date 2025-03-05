import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
@JsonSerializable()
class Chat with _$Chat {
  const factory Chat({
    required String sender,
    required String receiver,
    required String message,
    required DateTime time,
    required String messageId,
    required String? repliedMessage,
    bool? isSent,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}

@riverpod
class ChatState extends _$ChatState {
  @override
  List<Chat> build() {
    return [];
  }
}
