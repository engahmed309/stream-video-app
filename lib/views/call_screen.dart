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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocBuilder<MakeCallCubit, MakeCallState>(
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

                return Stack(
                  children: [
                    // Full screen video content
                    Positioned.fill(
                      child: StreamCallContainer(
                        call: call,
                        callContentBuilder: (context, call, callState) {
                          return StreamVideoRenderer(
                            videoTrackType: SfuTrackType
                                .video, // Add this required parameter

                            call: call,
                            participant: callState.localParticipant!,
                          );
                        },
                      ),
                    ),

                    // Overlay controls
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: StreamCallControls(
                        options: [
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
                          CallControlOption(
                            icon: const Icon(Icons.people_alt_rounded),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(20),
                                    title: const Text('Participants'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: call
                                            .state
                                            .value
                                            .callParticipants
                                            .map(
                                              (p) => Row(
                                                children: [
                                                  Icon(
                                                    p.isLocal
                                                        ? Icons.person
                                                        : Icons.person_outline,
                                                    color: p.isLocal
                                                        ? Colors.purple
                                                        : Colors.grey,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(child: Text(p.name)),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          FlipCameraOption(
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
                          AddReactionOption(
                            call: call,
                            localParticipant: localParticipant,
                          ),
                        ],
                      ),
                    ),

                    // Top app bar (optional)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Text(
                          'Welcome ${localParticipant?.name ?? "Guest"}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text('No active call'));
            },
          ),
        ),
      ),
    );
  }
}
