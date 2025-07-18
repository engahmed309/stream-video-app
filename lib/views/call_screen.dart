import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide CallState;

import '../cubits/cubit/call_cubit.dart';
import '../cubits/cubit/call_state.dart';
import 'end_call_screen.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  Offset _pipOffset = const Offset(10, 400);

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

                return StreamCallContainer(
                  call: call,
                  callContentBuilder: (context, call, callState) {
                    final local = callState.localParticipant;
                    final remotes = callState.callParticipants
                        .where((p) => !p.isLocal)
                        .toList();

                    final remote = remotes.isNotEmpty ? remotes.first : null;

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: remote != null
                              ? StreamVideoRenderer(
                                  call: call,
                                  participant: remote,
                                  videoTrackType: SfuTrackType.video,
                                )
                              : Container(
                                  color: Colors.black,
                                  child: const Center(
                                    child: Text(
                                      "Waiting for remote participant...",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                        ),

                        if (local != null)
                          Positioned(
                            left: _pipOffset.dx,
                            top: _pipOffset.dy,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                setState(() {
                                  _pipOffset += details.delta;
                                });
                              },
                              child: Container(
                                width: 120,
                                height: 180,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: StreamVideoRenderer(
                                    call: call,
                                    participant: local,
                                    videoTrackType: SfuTrackType.video,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildControlButton(
                                icon: local?.isVideoEnabled == true
                                    ? Icons.videocam
                                    : Icons.videocam_off,
                                color: Colors.white,
                                iconColor: local?.isVideoEnabled == true
                                    ? Colors.black
                                    : Colors.red,
                                onPressed: () async {
                                  final isEnabled =
                                      local?.isVideoEnabled ?? false;
                                  await call.setCameraEnabled(
                                    enabled: !isEnabled,
                                  );
                                  setState(() {});
                                },
                              ),

                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.withOpacity(0.2),
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.call_end_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      context.read<MakeCallCubit>().leaveCall(
                                        call,
                                      );
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const EndCallPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              _buildControlButton(
                                icon: local?.isAudioEnabled == true
                                    ? Icons.mic
                                    : Icons.mic_off,
                                color: Colors.white,
                                iconColor: local?.isAudioEnabled == true
                                    ? Colors.black
                                    : Colors.red,
                                onPressed: () async {
                                  final isEnabled =
                                      local?.isAudioEnabled ?? false;
                                  await call.setMicrophoneEnabled(
                                    enabled: !isEnabled,
                                  );
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    context.read<MakeCallCubit>().leaveCall(
                                      call,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.flip_camera_ios_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => call.flipCamera(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
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

Widget _buildControlButton({
  required IconData icon,
  required Color color,
  required Color iconColor,
  required VoidCallback onPressed,
}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: iconColor),
      onPressed: onPressed,
    ),
  );
}
