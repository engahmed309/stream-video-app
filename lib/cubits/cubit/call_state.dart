import 'package:stream_video_flutter/stream_video_flutter.dart';

abstract class MakeCallState {}

class CallInitial extends MakeCallState {}

class CallLoading extends MakeCallState {}

class CallJoined extends MakeCallState {
  final Call call;
  CallJoined(this.call);
}

class CallError extends MakeCallState {
  final String message;
  CallError(this.message);
}
