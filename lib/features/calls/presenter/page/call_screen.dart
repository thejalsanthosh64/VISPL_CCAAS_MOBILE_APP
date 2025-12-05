import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/presenter/widgets/bottom_sheet.dart';

/// A screen that displays an active call with controls.
/// 
/// This widget provides a user interface for an ongoing call with options to
/// hold, mute, transfer, conference, take notes, or end the call.




class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CallStateCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.appColor,
                AppColors.appColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Call",
                      style: AppTextStyle.white18.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        CallSession.callType ?? "Outgoing",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Avatar and Info
              Column(
                children: [
                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        state.callerName.isNotEmpty
                            ? state.callerName[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Name
                  Text(
                    state.callerName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Phone Number
                  Text(
                    state.phoneNumber,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Duration
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      _formatDuration(state.duration),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionBtn(
                      icon: state.isHold ? Icons.play_arrow : Icons.pause,
                      label: state.isHold ? "Resume" : "Hold",
                      color: Colors.orange,
                      onTap: () {
                        if (state.isHold) {
                          cubit.unhold(
                            smeId: CallSession.smeId!,
                            sessionId: CallSession.sessionId!,
                            channelId: CallSession.channelId!,
                            agentId: CallSession.agentId!,
                            agentName: CallSession.agentName!,
                          );
                        } else {
                          cubit.hold(
                            smeId: CallSession.smeId!,
                            sessionId: CallSession.sessionId!,
                            channelId: CallSession.channelId!,
                            agentId: CallSession.agentId!,
                            agentName: CallSession.agentName!,
                          );
                        }
                      },
                    ),
                    _actionBtn(
                      icon: state.isMuted ? Icons.mic_off : Icons.mic,
                      label: state.isMuted ? "Unmute" : "Mute",
                      color: state.isMuted ? Colors.red : Colors.blue,
                      onTap: () {
                        if (state.isMuted) {
                          cubit.unmute(
                            smeId: CallSession.smeId!,
                            sessionId: CallSession.sessionId!,
                            channelId: CallSession.channelId!,
                            agentId: CallSession.agentId!,
                            agentName: CallSession.agentName!,
                          );
                        } else {
                          cubit.mute(
                            smeId: CallSession.smeId!,
                            sessionId: CallSession.sessionId!,
                            channelId: CallSession.channelId!,
                            agentId: CallSession.agentId!,
                            agentName: CallSession.agentName!,
                          );
                        }
                      },
                    ),
                    _actionBtn(
                      icon: Icons.swap_horiz,
                      label: "Transfer",
                      color: Colors.teal,
                      onTap: () {
                        _openTransferSheet(context,
                            isAttended: false, isConference: false);
                      },
                    ),
                    _actionBtn(
                      icon: Icons.group,
                      label: "Conf.",
                      color: Colors.purple,
                      onTap: () {
                        _openTransferSheet(context,
                            isAttended: true, isConference: true);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // End Call Button
              GestureDetector(
                onTap: () async {
                  await cubit.drop(
                    smeId: CallSession.smeId!,
                    sessionId: CallSession.sessionId!,
                    channelId: CallSession.channelId!,
                    agentId: CallSession.agentId!,
                    agentName: CallSession.agentName!,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "${two(minutes)}:${two(seconds)}";
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _openTransferSheet(BuildContext context,
      {required bool isAttended, required bool isConference}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CallStateCubit>(),
        child: TransferBottomSheet(
          isAttended: isAttended,
          isConference: isConference,
        ),
      ),
    );
  }
}