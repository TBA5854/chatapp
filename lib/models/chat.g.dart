// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

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

String _$chatStateHash() => r'fa8a902d34435af1b9e966c95dbded9cd0e97b8c';

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
