// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 0;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      sender: fields[0] as String,
      receiver: fields[1] as String,
      message: fields[2] as String,
      time: fields[3] as DateTime,
      messageId: fields[4] as String,
      repliedMessage: fields[5] as String?,
      isSent: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.receiver)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.messageId)
      ..writeByte(5)
      ..write(obj.repliedMessage)
      ..writeByte(6)
      ..write(obj.isSent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'message': instance.message,
      'time': instance.time.toIso8601String(),
      'messageId': instance.messageId,
      'repliedMessage': instance.repliedMessage,
      'isSent': instance.isSent,
    };

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      message: json['message'] as String,
      time: DateTime.parse(json['time'] as String),
      messageId: json['messageId'] as String,
      repliedMessage: json['repliedMessage'] as String?,
      isSent: json['isSent'] as bool?,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'message': instance.message,
      'time': instance.time.toIso8601String(),
      'messageId': instance.messageId,
      'repliedMessage': instance.repliedMessage,
      'isSent': instance.isSent,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatStateHash() => r'0e8c28c38d5513c66f20d21d47ee9012a2ac501f';

/// See also [ChatState].
@ProviderFor(ChatState)
final chatStateProvider =
    AutoDisposeNotifierProvider<ChatState, List<Chat>>.internal(
  ChatState.new,
  name: r'chatStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatState = AutoDisposeNotifier<List<Chat>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
