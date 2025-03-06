// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return _Chat.fromJson(json);
}

/// @nodoc
mixin _$Chat {
  @HiveField(0)
  String get sender => throw _privateConstructorUsedError;
  @HiveField(1)
  String get receiver => throw _privateConstructorUsedError;
  @HiveField(2)
  String get message => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get time => throw _privateConstructorUsedError;
  @HiveField(4)
  String get messageId => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get repliedMessage => throw _privateConstructorUsedError;
  @HiveField(6)
  bool? get isSent => throw _privateConstructorUsedError;

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatCopyWith<Chat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCopyWith<$Res> {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) then) =
      _$ChatCopyWithImpl<$Res, Chat>;
  @useResult
  $Res call(
      {@HiveField(0) String sender,
      @HiveField(1) String receiver,
      @HiveField(2) String message,
      @HiveField(3) DateTime time,
      @HiveField(4) String messageId,
      @HiveField(5) String? repliedMessage,
      @HiveField(6) bool? isSent});
}

/// @nodoc
class _$ChatCopyWithImpl<$Res, $Val extends Chat>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? receiver = null,
    Object? message = null,
    Object? time = null,
    Object? messageId = null,
    Object? repliedMessage = freezed,
    Object? isSent = freezed,
  }) {
    return _then(_value.copyWith(
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      repliedMessage: freezed == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isSent: freezed == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatImplCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$$ChatImplCopyWith(
          _$ChatImpl value, $Res Function(_$ChatImpl) then) =
      __$$ChatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String sender,
      @HiveField(1) String receiver,
      @HiveField(2) String message,
      @HiveField(3) DateTime time,
      @HiveField(4) String messageId,
      @HiveField(5) String? repliedMessage,
      @HiveField(6) bool? isSent});
}

/// @nodoc
class __$$ChatImplCopyWithImpl<$Res>
    extends _$ChatCopyWithImpl<$Res, _$ChatImpl>
    implements _$$ChatImplCopyWith<$Res> {
  __$$ChatImplCopyWithImpl(_$ChatImpl _value, $Res Function(_$ChatImpl) _then)
      : super(_value, _then);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? receiver = null,
    Object? message = null,
    Object? time = null,
    Object? messageId = null,
    Object? repliedMessage = freezed,
    Object? isSent = freezed,
  }) {
    return _then(_$ChatImpl(
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      repliedMessage: freezed == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isSent: freezed == isSent
          ? _value.isSent
          : isSent // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatImpl implements _Chat {
  const _$ChatImpl(
      {@HiveField(0) required this.sender,
      @HiveField(1) required this.receiver,
      @HiveField(2) required this.message,
      @HiveField(3) required this.time,
      @HiveField(4) required this.messageId,
      @HiveField(5) required this.repliedMessage,
      @HiveField(6) this.isSent});

  factory _$ChatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatImplFromJson(json);

  @override
  @HiveField(0)
  final String sender;
  @override
  @HiveField(1)
  final String receiver;
  @override
  @HiveField(2)
  final String message;
  @override
  @HiveField(3)
  final DateTime time;
  @override
  @HiveField(4)
  final String messageId;
  @override
  @HiveField(5)
  final String? repliedMessage;
  @override
  @HiveField(6)
  final bool? isSent;

  @override
  String toString() {
    return 'Chat(sender: $sender, receiver: $receiver, message: $message, time: $time, messageId: $messageId, repliedMessage: $repliedMessage, isSent: $isSent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImpl &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.repliedMessage, repliedMessage) ||
                other.repliedMessage == repliedMessage) &&
            (identical(other.isSent, isSent) || other.isSent == isSent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sender, receiver, message, time,
      messageId, repliedMessage, isSent);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      __$$ChatImplCopyWithImpl<_$ChatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatImplToJson(
      this,
    );
  }
}

abstract class _Chat implements Chat {
  const factory _Chat(
      {@HiveField(0) required final String sender,
      @HiveField(1) required final String receiver,
      @HiveField(2) required final String message,
      @HiveField(3) required final DateTime time,
      @HiveField(4) required final String messageId,
      @HiveField(5) required final String? repliedMessage,
      @HiveField(6) final bool? isSent}) = _$ChatImpl;

  factory _Chat.fromJson(Map<String, dynamic> json) = _$ChatImpl.fromJson;

  @override
  @HiveField(0)
  String get sender;
  @override
  @HiveField(1)
  String get receiver;
  @override
  @HiveField(2)
  String get message;
  @override
  @HiveField(3)
  DateTime get time;
  @override
  @HiveField(4)
  String get messageId;
  @override
  @HiveField(5)
  String? get repliedMessage;
  @override
  @HiveField(6)
  bool? get isSent;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
