import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide CallState;

import '../../constants.dart';
import 'call_state.dart';

class MakeCallCubit extends Cubit<MakeCallState> {
  MakeCallCubit() : super(CallInitial());

  Future<void> joinCall() async {
    emit(CallLoading());
    try {
      final call = StreamVideo.instance.makeCall(
        callType: StreamCallType.defaultType(),
        id: callId,
      );

      await call.getOrCreate();

      emit(CallJoined(call));
    } catch (e) {
      emit(CallError('Failed to join call: $e'));
    }
  }

  void leaveCall(Call call) {
    call.leave();
    emit(CallInitial());
  }
}
