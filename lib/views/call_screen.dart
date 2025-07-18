import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide CallState;

import '../cubits/cubit/call_cubit.dart';
import '../cubits/cubit/call_state.dart';
import 'end_call_screen.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MakeCallCubit()..joinCall(),
      child: Scaffold(
        body: BlocBuilder<MakeCallCubit, MakeCallState>(
          builder: (context, state) {
            if (state is CallLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CallError) {
              return Center(child: Text(state.message));
            }

            if (state is CallJoined) {
              final call = state.call;
              final localParticipant = call.state.value.localParticipant;

              return StreamCallContainer(
                call: call,
                callContentBuilder: (context, call, callState) {
                  return StreamCallContent(
                    call: call,
                    callAppBarBuilder: (_, __, state) => AppBar(
                      title: Text(
                        'Welcome ${state.localParticipant?.name ?? "Guest"}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    callControlsBuilder: (context, call, _) {
                      return StreamCallControls(
                        options: [
                          FlipCameraOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          AddReactionOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          ToggleMicrophoneOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          ToggleCameraOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                          LeaveCallOption(
                            call: call,
                            onLeaveCallTap: () {
                              context.read<MakeCallCubit>().leaveCall(call);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EndCallPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            }

            return const Center(child: Text('No active call'));
          },
        ),
      ),
    );
  }
}
