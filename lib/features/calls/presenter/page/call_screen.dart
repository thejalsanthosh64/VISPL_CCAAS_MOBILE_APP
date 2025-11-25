import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';

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
      appBar: AppBar(
        title: const Text("Active Call"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// CALLER DETAILS
          Text(
            state.callerName,
            style: AppTextStyle.black25,
          ),
          Text(
            state.phoneNumber,
            style: AppTextStyle.greyNormal,
          ),
          Text(
            _format(state.duration),
            style: AppTextStyle.black18,
          ),

          const Spacer(),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// HOLD / UNHOLD
              ActionButton(
                icon: Icons.pause,
                label: state.isHold ? "Unhold" : "Hold",
                onTap: () {
                  if (state.isHold) {
                    cubit.unhold(
                      smeId: CallSession.smeId,
                      sessionId: CallSession.sessionId,
                      channelId: CallSession.channelId,
                      agentId: CallSession.agentId,
                      agentName: CallSession.agentName
                    );
                  } else {
                    cubit.hold(
                      smeId: CallSession.smeId,
                      sessionId: CallSession.sessionId,
                      channelId: CallSession.channelId,
                      agentId: CallSession.agentId,
                                            agentName: CallSession.agentName

                    );
                  }
                },
              ),

              /// MUTE / UNMUTE
              ActionButton(
                icon: Icons.mic_off,
                label: state.isMuted ? "Unmute" : "Mute",
                onTap: () {
                  if (state.isMuted) {
                    cubit.unmute(
                      smeId: CallSession.smeId,
                      sessionId: CallSession.sessionId,
                      channelId: CallSession.channelId,
                      agentId: CallSession.agentId,
                                            agentName: CallSession.agentName

                    );
                  } else {
                    cubit.mute(
                      smeId: CallSession.smeId,
                      sessionId: CallSession.sessionId,
                      channelId: CallSession.channelId,
                      agentId: CallSession.agentId,
                                            agentName: CallSession.agentName

                    );
                  }
                },
              ),

              ActionButton(
  icon: Icons.swap_horiz,
  label: "Transfer",
  onTap: () {
    _showTransferOptions(context);
  },
),

ActionButton(
  icon: Icons.group,
  label: "Conference",
  onTap: () {
    _showConference(context);
  },
),


              /// END CALL
              ActionButton(
                icon: Icons.call_end,
                label: "End",
                onTap: () async {
                  await cubit.drop(
                    smeId: CallSession.smeId,
                    sessionId: CallSession.sessionId,
                    channelId: CallSession.channelId,
                                          agentId: CallSession.agentId,

                                          agentName: CallSession.agentName

                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _format(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}";
  }
}

void _showTransferOptions(BuildContext context) async {
  final cubit = context.read<CallStateCubit>();

  // Load queue agents (hardcode queueId if needed)
  final agents = await cubit.loadQueueAgents(
    CallSession.smeId,
    "303",     // or dynamic queueId
  );

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SizedBox(
        height: 350,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text("Transfer Call", style: AppTextStyle.black18),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: agents.length,
                itemBuilder: (_, i) {
                  final ag = agents[i];

                  return ListTile(
                    title: Text(ag.agentName ?? "Unknown"),
                    subtitle: Text("Mobile: ${ag.agentMobile ?? '-'}"),
                    trailing: Text(
                      ag.status == "1" ? "Free" : "Busy",
                      style: TextStyle(
                        color: ag.status == "1" ? Colors.green : Colors.red,
                      ),
                    ),
                    onTap: () async {
                      final available = await cubit.isAgentAvailable(
                        CallSession.smeId,
                        ag.agentId!,
                      );

                      if (!available) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Agent is busy")),
                        );
                        return;
                      }

                      cubit.unattendedTransfer(
                        smeId: CallSession.smeId,
                        sessionId: CallSession.sessionId,
                        channelId: CallSession.channelId,
                        agentId: CallSession.agentId,
                        agentName: CallSession.agentName,
                        transferToAgentId: ag.agentId,
                        agentMobile: ag.agentMobile,
                      );

                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _showConference(BuildContext context) async {
  final cubit = context.read<CallStateCubit>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      int? agentId;
      String? agentMobile;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Conference Call", style: AppTextStyle.black18),
            const Divider(),
            TextField(
              decoration: const InputDecoration(labelText: "Agent ID"),
              onChanged: (v) => agentId = int.tryParse(v),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Agent Mobile"),
              onChanged: (v) => agentMobile = v,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Start Conference"),
              onPressed: () async {
                // STEP 1: Connect to second agent
                await cubit.attendedTransfer(
                  smeId: CallSession.smeId,
                  sessionId: CallSession.sessionId,
                  channelId: CallSession.channelId,
                  agentId: CallSession.agentId,
                  agentName: CallSession.agentName,
                  transferToAgentId: agentId,
                  agentMobile: agentMobile,
                  action: null,  // step 1
                );

                await Future.delayed(const Duration(seconds: 2));

                // STEP 2: Convert to conference
                await cubit.attendedTransfer(
                  smeId: CallSession.smeId,
                  sessionId: CallSession.sessionId,
                  channelId: CallSession.channelId,
                  agentId: CallSession.agentId,
                  agentName: CallSession.agentName,
                  action: "conference",
                );

                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    },
  );
}



/// REUSABLE BUTTON
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Icon(icon, size: 32, color: Colors.blue),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyle.greyNormal),
        ],
      ),
    );
  }
}
