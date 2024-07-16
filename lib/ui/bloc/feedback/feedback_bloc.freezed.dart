// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedbackEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(String feedbackId) edit,
    required TResult Function(String feedbackId) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(String feedbackId)? edit,
    TResult? Function(String feedbackId)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(String feedbackId)? edit,
    TResult Function(String feedbackId)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackGet value) get,
    required TResult Function(FeedbackEdit value) edit,
    required TResult Function(FeedbackDelete value) delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackGet value)? get,
    TResult? Function(FeedbackEdit value)? edit,
    TResult? Function(FeedbackDelete value)? delete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackGet value)? get,
    TResult Function(FeedbackEdit value)? edit,
    TResult Function(FeedbackDelete value)? delete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackEventCopyWith<$Res> {
  factory $FeedbackEventCopyWith(
          FeedbackEvent value, $Res Function(FeedbackEvent) then) =
      _$FeedbackEventCopyWithImpl<$Res, FeedbackEvent>;
}

/// @nodoc
class _$FeedbackEventCopyWithImpl<$Res, $Val extends FeedbackEvent>
    implements $FeedbackEventCopyWith<$Res> {
  _$FeedbackEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FeedbackGetImplCopyWith<$Res> {
  factory _$$FeedbackGetImplCopyWith(
          _$FeedbackGetImpl value, $Res Function(_$FeedbackGetImpl) then) =
      __$$FeedbackGetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FeedbackGetImplCopyWithImpl<$Res>
    extends _$FeedbackEventCopyWithImpl<$Res, _$FeedbackGetImpl>
    implements _$$FeedbackGetImplCopyWith<$Res> {
  __$$FeedbackGetImplCopyWithImpl(
      _$FeedbackGetImpl _value, $Res Function(_$FeedbackGetImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FeedbackGetImpl implements FeedbackGet {
  const _$FeedbackGetImpl();

  @override
  String toString() {
    return 'FeedbackEvent.get()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FeedbackGetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(String feedbackId) edit,
    required TResult Function(String feedbackId) delete,
  }) {
    return get();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(String feedbackId)? edit,
    TResult? Function(String feedbackId)? delete,
  }) {
    return get?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(String feedbackId)? edit,
    TResult Function(String feedbackId)? delete,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackGet value) get,
    required TResult Function(FeedbackEdit value) edit,
    required TResult Function(FeedbackDelete value) delete,
  }) {
    return get(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackGet value)? get,
    TResult? Function(FeedbackEdit value)? edit,
    TResult? Function(FeedbackDelete value)? delete,
  }) {
    return get?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackGet value)? get,
    TResult Function(FeedbackEdit value)? edit,
    TResult Function(FeedbackDelete value)? delete,
    required TResult orElse(),
  }) {
    if (get != null) {
      return get(this);
    }
    return orElse();
  }
}

abstract class FeedbackGet implements FeedbackEvent {
  const factory FeedbackGet() = _$FeedbackGetImpl;
}

/// @nodoc
abstract class _$$FeedbackEditImplCopyWith<$Res> {
  factory _$$FeedbackEditImplCopyWith(
          _$FeedbackEditImpl value, $Res Function(_$FeedbackEditImpl) then) =
      __$$FeedbackEditImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String feedbackId});
}

/// @nodoc
class __$$FeedbackEditImplCopyWithImpl<$Res>
    extends _$FeedbackEventCopyWithImpl<$Res, _$FeedbackEditImpl>
    implements _$$FeedbackEditImplCopyWith<$Res> {
  __$$FeedbackEditImplCopyWithImpl(
      _$FeedbackEditImpl _value, $Res Function(_$FeedbackEditImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackId = null,
  }) {
    return _then(_$FeedbackEditImpl(
      null == feedbackId
          ? _value.feedbackId
          : feedbackId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FeedbackEditImpl implements FeedbackEdit {
  const _$FeedbackEditImpl(this.feedbackId);

  @override
  final String feedbackId;

  @override
  String toString() {
    return 'FeedbackEvent.edit(feedbackId: $feedbackId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackEditImpl &&
            (identical(other.feedbackId, feedbackId) ||
                other.feedbackId == feedbackId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, feedbackId);

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackEditImplCopyWith<_$FeedbackEditImpl> get copyWith =>
      __$$FeedbackEditImplCopyWithImpl<_$FeedbackEditImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(String feedbackId) edit,
    required TResult Function(String feedbackId) delete,
  }) {
    return edit(feedbackId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(String feedbackId)? edit,
    TResult? Function(String feedbackId)? delete,
  }) {
    return edit?.call(feedbackId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(String feedbackId)? edit,
    TResult Function(String feedbackId)? delete,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(feedbackId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackGet value) get,
    required TResult Function(FeedbackEdit value) edit,
    required TResult Function(FeedbackDelete value) delete,
  }) {
    return edit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackGet value)? get,
    TResult? Function(FeedbackEdit value)? edit,
    TResult? Function(FeedbackDelete value)? delete,
  }) {
    return edit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackGet value)? get,
    TResult Function(FeedbackEdit value)? edit,
    TResult Function(FeedbackDelete value)? delete,
    required TResult orElse(),
  }) {
    if (edit != null) {
      return edit(this);
    }
    return orElse();
  }
}

abstract class FeedbackEdit implements FeedbackEvent {
  const factory FeedbackEdit(final String feedbackId) = _$FeedbackEditImpl;

  String get feedbackId;

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackEditImplCopyWith<_$FeedbackEditImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FeedbackDeleteImplCopyWith<$Res> {
  factory _$$FeedbackDeleteImplCopyWith(_$FeedbackDeleteImpl value,
          $Res Function(_$FeedbackDeleteImpl) then) =
      __$$FeedbackDeleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String feedbackId});
}

/// @nodoc
class __$$FeedbackDeleteImplCopyWithImpl<$Res>
    extends _$FeedbackEventCopyWithImpl<$Res, _$FeedbackDeleteImpl>
    implements _$$FeedbackDeleteImplCopyWith<$Res> {
  __$$FeedbackDeleteImplCopyWithImpl(
      _$FeedbackDeleteImpl _value, $Res Function(_$FeedbackDeleteImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackId = null,
  }) {
    return _then(_$FeedbackDeleteImpl(
      null == feedbackId
          ? _value.feedbackId
          : feedbackId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FeedbackDeleteImpl implements FeedbackDelete {
  const _$FeedbackDeleteImpl(this.feedbackId);

  @override
  final String feedbackId;

  @override
  String toString() {
    return 'FeedbackEvent.delete(feedbackId: $feedbackId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackDeleteImpl &&
            (identical(other.feedbackId, feedbackId) ||
                other.feedbackId == feedbackId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, feedbackId);

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackDeleteImplCopyWith<_$FeedbackDeleteImpl> get copyWith =>
      __$$FeedbackDeleteImplCopyWithImpl<_$FeedbackDeleteImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() get,
    required TResult Function(String feedbackId) edit,
    required TResult Function(String feedbackId) delete,
  }) {
    return delete(feedbackId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? get,
    TResult? Function(String feedbackId)? edit,
    TResult? Function(String feedbackId)? delete,
  }) {
    return delete?.call(feedbackId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? get,
    TResult Function(String feedbackId)? edit,
    TResult Function(String feedbackId)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(feedbackId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FeedbackGet value) get,
    required TResult Function(FeedbackEdit value) edit,
    required TResult Function(FeedbackDelete value) delete,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FeedbackGet value)? get,
    TResult? Function(FeedbackEdit value)? edit,
    TResult? Function(FeedbackDelete value)? delete,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FeedbackGet value)? get,
    TResult Function(FeedbackEdit value)? edit,
    TResult Function(FeedbackDelete value)? delete,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class FeedbackDelete implements FeedbackEvent {
  const factory FeedbackDelete(final String feedbackId) = _$FeedbackDeleteImpl;

  String get feedbackId;

  /// Create a copy of FeedbackEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackDeleteImplCopyWith<_$FeedbackDeleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FeedbackState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Feedback> feedbacks) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Feedback> feedbacks)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Feedback> feedbacks)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FeedbackInitialState value) initial,
    required TResult Function(_FeedbackLoadingState value) loading,
    required TResult Function(_FeedbackErrorState value) error,
    required TResult Function(_FeedbackSuccessState value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FeedbackInitialState value)? initial,
    TResult? Function(_FeedbackLoadingState value)? loading,
    TResult? Function(_FeedbackErrorState value)? error,
    TResult? Function(_FeedbackSuccessState value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FeedbackInitialState value)? initial,
    TResult Function(_FeedbackLoadingState value)? loading,
    TResult Function(_FeedbackErrorState value)? error,
    TResult Function(_FeedbackSuccessState value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackStateCopyWith<$Res> {
  factory $FeedbackStateCopyWith(
          FeedbackState value, $Res Function(FeedbackState) then) =
      _$FeedbackStateCopyWithImpl<$Res, FeedbackState>;
}

/// @nodoc
class _$FeedbackStateCopyWithImpl<$Res, $Val extends FeedbackState>
    implements $FeedbackStateCopyWith<$Res> {
  _$FeedbackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FeedbackInitialStateImplCopyWith<$Res> {
  factory _$$FeedbackInitialStateImplCopyWith(_$FeedbackInitialStateImpl value,
          $Res Function(_$FeedbackInitialStateImpl) then) =
      __$$FeedbackInitialStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FeedbackInitialStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackInitialStateImpl>
    implements _$$FeedbackInitialStateImplCopyWith<$Res> {
  __$$FeedbackInitialStateImplCopyWithImpl(_$FeedbackInitialStateImpl _value,
      $Res Function(_$FeedbackInitialStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FeedbackInitialStateImpl implements _FeedbackInitialState {
  const _$FeedbackInitialStateImpl();

  @override
  String toString() {
    return 'FeedbackState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackInitialStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Feedback> feedbacks) success,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Feedback> feedbacks)? success,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Feedback> feedbacks)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FeedbackInitialState value) initial,
    required TResult Function(_FeedbackLoadingState value) loading,
    required TResult Function(_FeedbackErrorState value) error,
    required TResult Function(_FeedbackSuccessState value) success,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FeedbackInitialState value)? initial,
    TResult? Function(_FeedbackLoadingState value)? loading,
    TResult? Function(_FeedbackErrorState value)? error,
    TResult? Function(_FeedbackSuccessState value)? success,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FeedbackInitialState value)? initial,
    TResult Function(_FeedbackLoadingState value)? loading,
    TResult Function(_FeedbackErrorState value)? error,
    TResult Function(_FeedbackSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _FeedbackInitialState implements FeedbackState {
  const factory _FeedbackInitialState() = _$FeedbackInitialStateImpl;
}

/// @nodoc
abstract class _$$FeedbackLoadingStateImplCopyWith<$Res> {
  factory _$$FeedbackLoadingStateImplCopyWith(_$FeedbackLoadingStateImpl value,
          $Res Function(_$FeedbackLoadingStateImpl) then) =
      __$$FeedbackLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FeedbackLoadingStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackLoadingStateImpl>
    implements _$$FeedbackLoadingStateImplCopyWith<$Res> {
  __$$FeedbackLoadingStateImplCopyWithImpl(_$FeedbackLoadingStateImpl _value,
      $Res Function(_$FeedbackLoadingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FeedbackLoadingStateImpl implements _FeedbackLoadingState {
  const _$FeedbackLoadingStateImpl();

  @override
  String toString() {
    return 'FeedbackState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackLoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Feedback> feedbacks) success,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Feedback> feedbacks)? success,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Feedback> feedbacks)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FeedbackInitialState value) initial,
    required TResult Function(_FeedbackLoadingState value) loading,
    required TResult Function(_FeedbackErrorState value) error,
    required TResult Function(_FeedbackSuccessState value) success,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FeedbackInitialState value)? initial,
    TResult? Function(_FeedbackLoadingState value)? loading,
    TResult? Function(_FeedbackErrorState value)? error,
    TResult? Function(_FeedbackSuccessState value)? success,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FeedbackInitialState value)? initial,
    TResult Function(_FeedbackLoadingState value)? loading,
    TResult Function(_FeedbackErrorState value)? error,
    TResult Function(_FeedbackSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _FeedbackLoadingState implements FeedbackState {
  const factory _FeedbackLoadingState() = _$FeedbackLoadingStateImpl;
}

/// @nodoc
abstract class _$$FeedbackErrorStateImplCopyWith<$Res> {
  factory _$$FeedbackErrorStateImplCopyWith(_$FeedbackErrorStateImpl value,
          $Res Function(_$FeedbackErrorStateImpl) then) =
      __$$FeedbackErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String errorMessage});
}

/// @nodoc
class __$$FeedbackErrorStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackErrorStateImpl>
    implements _$$FeedbackErrorStateImplCopyWith<$Res> {
  __$$FeedbackErrorStateImplCopyWithImpl(_$FeedbackErrorStateImpl _value,
      $Res Function(_$FeedbackErrorStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorMessage = null,
  }) {
    return _then(_$FeedbackErrorStateImpl(
      null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FeedbackErrorStateImpl implements _FeedbackErrorState {
  const _$FeedbackErrorStateImpl(this.errorMessage);

  @override
  final String errorMessage;

  @override
  String toString() {
    return 'FeedbackState.error(errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackErrorStateImpl &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, errorMessage);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackErrorStateImplCopyWith<_$FeedbackErrorStateImpl> get copyWith =>
      __$$FeedbackErrorStateImplCopyWithImpl<_$FeedbackErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Feedback> feedbacks) success,
  }) {
    return error(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Feedback> feedbacks)? success,
  }) {
    return error?.call(errorMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Feedback> feedbacks)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FeedbackInitialState value) initial,
    required TResult Function(_FeedbackLoadingState value) loading,
    required TResult Function(_FeedbackErrorState value) error,
    required TResult Function(_FeedbackSuccessState value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FeedbackInitialState value)? initial,
    TResult? Function(_FeedbackLoadingState value)? loading,
    TResult? Function(_FeedbackErrorState value)? error,
    TResult? Function(_FeedbackSuccessState value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FeedbackInitialState value)? initial,
    TResult Function(_FeedbackLoadingState value)? loading,
    TResult Function(_FeedbackErrorState value)? error,
    TResult Function(_FeedbackSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _FeedbackErrorState implements FeedbackState {
  const factory _FeedbackErrorState(final String errorMessage) =
      _$FeedbackErrorStateImpl;

  String get errorMessage;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackErrorStateImplCopyWith<_$FeedbackErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FeedbackSuccessStateImplCopyWith<$Res> {
  factory _$$FeedbackSuccessStateImplCopyWith(_$FeedbackSuccessStateImpl value,
          $Res Function(_$FeedbackSuccessStateImpl) then) =
      __$$FeedbackSuccessStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Feedback> feedbacks});
}

/// @nodoc
class __$$FeedbackSuccessStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackSuccessStateImpl>
    implements _$$FeedbackSuccessStateImplCopyWith<$Res> {
  __$$FeedbackSuccessStateImplCopyWithImpl(_$FeedbackSuccessStateImpl _value,
      $Res Function(_$FeedbackSuccessStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbacks = null,
  }) {
    return _then(_$FeedbackSuccessStateImpl(
      null == feedbacks
          ? _value._feedbacks
          : feedbacks // ignore: cast_nullable_to_non_nullable
              as List<Feedback>,
    ));
  }
}

/// @nodoc

class _$FeedbackSuccessStateImpl implements _FeedbackSuccessState {
  const _$FeedbackSuccessStateImpl(final List<Feedback> feedbacks)
      : _feedbacks = feedbacks;

  final List<Feedback> _feedbacks;
  @override
  List<Feedback> get feedbacks {
    if (_feedbacks is EqualUnmodifiableListView) return _feedbacks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_feedbacks);
  }

  @override
  String toString() {
    return 'FeedbackState.success(feedbacks: $feedbacks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackSuccessStateImpl &&
            const DeepCollectionEquality()
                .equals(other._feedbacks, _feedbacks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_feedbacks));

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackSuccessStateImplCopyWith<_$FeedbackSuccessStateImpl>
      get copyWith =>
          __$$FeedbackSuccessStateImplCopyWithImpl<_$FeedbackSuccessStateImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String errorMessage) error,
    required TResult Function(List<Feedback> feedbacks) success,
  }) {
    return success(feedbacks);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String errorMessage)? error,
    TResult? Function(List<Feedback> feedbacks)? success,
  }) {
    return success?.call(feedbacks);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String errorMessage)? error,
    TResult Function(List<Feedback> feedbacks)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(feedbacks);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FeedbackInitialState value) initial,
    required TResult Function(_FeedbackLoadingState value) loading,
    required TResult Function(_FeedbackErrorState value) error,
    required TResult Function(_FeedbackSuccessState value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FeedbackInitialState value)? initial,
    TResult? Function(_FeedbackLoadingState value)? loading,
    TResult? Function(_FeedbackErrorState value)? error,
    TResult? Function(_FeedbackSuccessState value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FeedbackInitialState value)? initial,
    TResult Function(_FeedbackLoadingState value)? loading,
    TResult Function(_FeedbackErrorState value)? error,
    TResult Function(_FeedbackSuccessState value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _FeedbackSuccessState implements FeedbackState {
  const factory _FeedbackSuccessState(final List<Feedback> feedbacks) =
      _$FeedbackSuccessStateImpl;

  List<Feedback> get feedbacks;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackSuccessStateImplCopyWith<_$FeedbackSuccessStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
