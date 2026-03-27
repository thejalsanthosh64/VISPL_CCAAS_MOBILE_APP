import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';
import 'package:kommuno/features/calls/presenter/widgets/bottom_sheet.dart';
import 'package:kommuno/features/calls/presenter/widgets/crm_form_widget.dart';
import 'package:kommuno/features/calls/presenter/widgets/dispostion_widget.dart';
import 'package:kommuno/features/calls/presenter/widgets/interaction_history_widget.dart';

/// A screen that displays an active call with controls.
/// 
/// This widget provides a user interface for an ongoing call with options to
/// hold, mute, transfer, conference, take notes, or end the call.


class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("🏗️ CallScreen build called");

    return BlocListener<CallStateCubit, CallState>(
      listenWhen: (prev, curr) {
        final shouldListen = curr.showCrmForm == true &&
            curr.crmPopupShown == false &&
            prev.crmPopupShown == false;

        debugPrint("🔍 listenWhen check:");
        debugPrint("  - showCrmForm: ${curr.showCrmForm}");
        debugPrint("  - curr.crmPopupShown: ${curr.crmPopupShown}");
        debugPrint("  - prev.crmPopupShown: ${prev.crmPopupShown}");
        debugPrint("  - RESULT: $shouldListen");

        return shouldListen;
      },
      listener: (context, state) {
        debugPrint("🚨 CRM LISTENER TRIGGERED!");
        context.read<CallStateCubit>().markCrmPopupShown();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openCrmSheet(context);
        });
      },
      child: const _CallScreenBody(),
    );
  }
}

void openCrmSheet(BuildContext context) {
  final cubit = context.read<CallStateCubit>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) =>
        BlocProvider.value(value: cubit, child: const CrmFormSheet()),
  ).whenComplete(() => debugPrint("🔒 CRM sheet closed"));
}

class _CallScreenBody extends StatefulWidget {
  const _CallScreenBody({super.key});

  @override
  State<_CallScreenBody> createState() => _CallScreenBodyState();
}

class _CallScreenBodyState extends State<_CallScreenBody> {
  bool _surveySent = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CallStateCubit>();
    final state = cubit.state;

    // ── Icon disable rules ────────────────────────────────────────────────
    //
    //  state.areIconsDisabled  →  true from cbwt_confirmed until either:
    //    • transfer_clear_confirmed  (other agent didn't answer → back to idle)
    //    • call ends via clear_live_calls  (other agent answered → done)
    //
    //  state.isConferenceButtonDisabled  →  true once conference succeeded.
    //    The Conf button stays disabled for the entire remainder of the call.
    //
    //  Survey button is NEVER disabled by transfer state.

    final iconsDisabled = state.areIconsDisabled;

  final surveyId =  state.surveyFormId ;
      
      
  final bool showSurveyIcon = surveyId != null && surveyId.isNotEmpty;

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                // ── Header ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Active Call",
                        style: AppTextStyle.white18
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),

                      // Call type chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          CallSession.callType ?? "Outgoing",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              IconButton(
                                tooltip: "Disposition",
                                icon: const Icon(
                                    Icons.assignment_turned_in_outlined,
                                    color: Colors.white,
                                    size: 22),
                                onPressed: () =>
                                    openDispositionSheet(context),
                              ),
                              IconButton(
                                tooltip: "History",
                                icon: const Icon(Icons.history,
                                    color: Colors.white, size: 22),
                                onPressed: () async {
                                  ClickGuard.run(() async {
                                    await cubit.loadInteractionHistory(
                                        customerNumber:
                                            cubit.state.phoneNumber);
                                    _openInteractionHistorySheet(context);
                                  });
                                },
                              ),
                              if (state.showCrmForm)
                                IconButton(
                                  tooltip: "CRM",
                                  icon: const Icon(
                                      Icons.assignment_outlined,
                                      color: Colors.white,
                                      size: 22),
                                  onPressed: () => openCrmSheet(context),
                                ),
                              IconButton(
                                tooltip: "SMS",
                                icon: const FaIcon(
                                    FontAwesomeIcons.message,
                                    color: Colors.white,
                                    size: 18),
                                onPressed: () async {
                                  ClickGuard.run(() async {
                                    await cubit.loadSmsTemplates();
                                    _openTemplateSheet(context,
                                        type: "sms");
                                  });
                                },
                              ),
                              IconButton(
                                tooltip: "WhatsApp",
                                icon: const FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.white,
                                    size: 20),
                                onPressed: () async {
                                  ClickGuard.run(() async {
                                    await cubit.loadWhatsappTemplates();
                                    _openTemplateSheet(context,
                                        type: "whatsapp");
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── Avatar + caller info ─────────────────────────────────
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 3),
                      ),
                      child: Center(
                        child: Text(
                          state.callerName.isNotEmpty
                              ? state.callerName[0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(state.callerName,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(state.phoneNumber,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
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
                            letterSpacing: 1.2),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ── Action buttons ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Hold — disabled during transfer ringing / done
                      _disableable(
                        disabled: iconsDisabled,
                        child: _actionBtn(
                          icon:
                              state.isHold ? Icons.play_arrow : Icons.pause,
                          label: state.isHold ? "Resume" : "Hold",
                          color: Colors.orange,
                          onTap: () {
                            // ClickGuard.run(() async {
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
                            // });
                          },
                        ),
                      ),

                      // Mute — disabled during transfer ringing / done
                      _disableable(
                        disabled: iconsDisabled,
                        child: _actionBtn(
                          icon: state.isMuted ? Icons.mic_off : Icons.mic,
                          label: state.isMuted ? "Unmute" : "Mute",
                          color: state.isMuted ? Colors.red : Colors.blue,
                          onTap: () {
                            // ClickGuard.run(() async {
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
                            // });
                          },
                        ),
                      ),

                      // ── Transfer button ───────────────────────────────
                      //
                      //  Normal call / idle          → opens transfer sheet (blind/attended)
                      //  attendedStep1Confirmed      → disabled (agent must Merge or wait)
                      //  conferenceLive / ended      → calls /attended?action=transfer directly,
                      //                                no bottom sheet, then drops agent1
                      //  transferRinging / Done      → disabled (areIconsDisabled)
                      _buildTransferButton(context, cubit, state, iconsDisabled),

                      // ── Conference / Merge button ─────────────────────
                      //
                      //  idle / normal               → "Conf." opens attended transfer sheet
                      //  attendedStep1Confirmed      → shows as "Merge", calls /attended?action=conference
                      //  conferenceLive / ended      → permanently disabled
                      //  transferRinging / Done      → disabled (areIconsDisabled)
                      _buildConferenceButton(context, cubit, state, iconsDisabled),

                      // Survey — NEVER disabled by transfer state
                      // if (CampaignManager.campaign?.isSurveyEnabled == true)
                      if (showSurveyIcon)
                        Opacity(
                          opacity: _surveySent ? 0.4 : 1.0,
                          child: IgnorePointer(
                            ignoring: _surveySent,
                            child: _actionBtn(
                              icon: Icons.poll,
                              label: "Survey",
                              color: Colors.green,
                              onTap: () async {
                                // ClickGuard.run(() async {
                                  final res = await cubit.sendSurveyIVR();
                                  if (res == true) {
                                    setState(() => _surveySent = true);
                                  }
                                // });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── End Call button ──────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    // ClickGuard.run(() async {
                      await cubit.drop(
                        smeId: CallSession.smeId!,
                        sessionId: CallSession.sessionId!,
                        channelId: CallSession.channelId!,
                        agentId: CallSession.agentId!,
                        agentName: CallSession.agentName!,
                      );
                    // });
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
                    child: const Icon(Icons.call_end,
                        color: Colors.white, size: 32),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  /// Wraps a widget with Opacity + IgnorePointer when [disabled] is true.
  Widget _disableable({required bool disabled, required Widget child}) {
    return Opacity(
      opacity: disabled ? 0.35 : 1.0,
      child: IgnorePointer(ignoring: disabled, child: child),
    );
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
                  color: Colors.white.withOpacity(0.2), width: 1),
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
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // ── Transfer button — behaviour changes based on transfer state ───────────
  Widget _buildTransferButton(
    BuildContext context,
    CallStateCubit cubit,
    CallState state,
    bool iconsDisabled,
  ) {
    final status = state.transferStatus;

    // Always disabled while ringing/done
    if (iconsDisabled) {
      return _disableable(
        disabled: true,
        child: _actionBtn(
          icon: Icons.swap_horiz,
          label: "Transfer",
          color: Colors.teal,
          onTap: () {},
        ),
      );
    }

    // During attendedStep1Confirmed: disable Transfer — agent must Merge first
    if (status == TransferStatus.attendedStep1Confirmed) {
      return _disableable(
        disabled: true,
        child: _actionBtn(
          icon: Icons.swap_horiz,
          label: "Transfer",
          color: Colors.teal,
          onTap: () {},
        ),
      );
    }

    // During conferenceLive or conferenceEnded: Transfer hits API directly, no sheet
    // if (status == TransferStatus.conferenceLive ||
    //     status == TransferStatus.conferenceEnded) {
    //   return _actionBtn(
        
    //     icon: Icons.swap_horiz,
    //     label: "Transfer",
    //     color: Colors.teal,
    //     onTap: () async {
    //       print("clicked");
    //       // ClickGuard.run(() async {

    //         await cubit.transferDuringConference(
    //           smeId: CallSession.smeId!,
    //           sessionId: CallSession.sessionId!,
    //           channelId: CallSession.channelId!,
    //           agentId: CallSession.agentId!,
    //           agentName: CallSession.agentName!,
    //         );
    //       // });
    //     },
    //   );
    // }


    // During conferenceLive: agent2 still on call → Transfer hits API directly (drops agent1)
if (status == TransferStatus.conferenceLive) {
  return _actionBtn(
    icon: Icons.swap_horiz,
    label: "Transfer",
    color: Colors.teal,
    onTap: () async {
      
        await cubit.transferDuringConference(
          smeId: CallSession.smeId!,
          sessionId: CallSession.sessionId!,
          channelId: CallSession.channelId!,
          agentId: CallSession.agentId!,
          agentName: CallSession.agentName!,
          
        );
      });
 
}

// conferenceEnded: agent2 disconnected → back to normal blind transfer sheet
// (Conf button stays permanently disabled via conferenceCompleted, but Transfer is free)
if (status == TransferStatus.conferenceEnded) {
  return _actionBtn(
    icon: Icons.swap_horiz,
    label: "Transfer",
    color: Colors.teal,
    onTap: () {
        _openTransferSheet(context, isAttended: false, isConference: false);
      });
 
}

    // Normal idle state — open transfer sheet (blind only; attended handled by Conf button)
    return _actionBtn(
      icon: Icons.swap_horiz,
      label: "Transfer",
      color: Colors.teal,
      onTap: () {
        // ClickGuard.run(() async {
          _openTransferSheet(context, isAttended: false, isConference: false);
        // });
      },
    );
  }

  // ── Conference / Merge button ─────────────────────────────────────────────
  Widget _buildConferenceButton(
    BuildContext context,
    CallStateCubit cubit,
    CallState state,
    bool iconsDisabled,
  ) {
    final status = state.transferStatus;
    final confDisabled = state.isConferenceButtonDisabled;

    // While icons globally disabled (transferRinging / transferDone)
    if (iconsDisabled) {
      return _disableable(
        disabled: true,
        child: _actionBtn(
          icon: Icons.group,
          label: "Conf.",
          color: Colors.purple,
          onTap: () {},
        ),
      );
    }

    // After conference is done — permanently disabled, no interaction
    if (confDisabled && status != TransferStatus.attendedStep1Confirmed) {
      return _disableable(
        disabled: true,
        child: _actionBtn(
          icon: Icons.group,
          label: "Conf.",
          color: Colors.purple,
          onTap: () {},
        ),
      );
    }

    // attendedStep1Confirmed → show "Merge" button
    if (status == TransferStatus.attendedStep1Confirmed) {
      return _actionBtn(
        icon: Icons.merge_type,
        label: "Merge",
        color: Colors.deepOrange,
        onTap: () async {
          // ClickGuard.run(() async {
            await cubit.mergeConference(
              smeId: CallSession.smeId!,
              sessionId: CallSession.sessionId!,
              channelId: CallSession.channelId!,
              agentId: CallSession.agentId!,
              agentName: CallSession.agentName!,
            );
          // });
        },
      );
    }

    // Normal idle — open attended transfer sheet (Conference flow)
    return _actionBtn(
      icon: Icons.group,
      label: "Conf.",
      color: Colors.purple,
       
      onTap: () {
        // ClickGuard.run(() async {
          _openTransferSheet(context, isAttended: true, isConference: true);
        });
      // },
    // );
  }

  void openCrmSheet(BuildContext context) {
    final cubit = context.read<CallStateCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) =>
          BlocProvider.value(value: cubit, child: const CrmFormSheet()),
    );
  }

  void _openInteractionHistorySheet(BuildContext context) {
    final cubit = context.read<CallStateCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
          value: cubit, child: const InteractionHistorySheet()),
    );
  }

  void openDispositionSheet(BuildContext context) {
    final callCubit = context.read<CallStateCubit>();
    final userCubit = UserDetailsCubit.instance!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: callCubit),
          BlocProvider.value(value: userCubit),
        ],
        child: DispositionBottomSheet(cubit: callCubit),
      ),
    );
  }

  void _openTemplateSheet(BuildContext context, {required String type}) {
    final cubit = context.read<CallStateCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: BlocBuilder<CallStateCubit, CallState>(
            builder: (context, state) {
              final templates = type == "sms"
                  ? state.smsTemplates
                  : state.whatsappTemplates;
              if (templates.isEmpty) {
                return const Center(child: Text("No templates found"));
              }
              return Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    type == "sms" ? "SMS Templates" : "WhatsApp Templates",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: templates.length,
                      itemBuilder: (_, index) {
                        final t = templates[index];
                        return ListTile(
                          title: Text(type == "sms"
                              ? t["template_name"]
                              : t["name"]),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                          onTap: () {
                            Navigator.pop(context);
                            if (type == "sms") {
                              _openPreviewSheet(context,
                                  template: t, type: type);
                            } else {
                              cubit.sendWhatsappTemplate(t);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openPreviewSheet(BuildContext context,
      {required Map<String, dynamic> template, required String type}) {
    final cubit = context.read<CallStateCubit>();
    final messageController =
        TextEditingController(text: template["message"] ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              height: MediaQuery.of(sheetContext).size.height * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Preview Message",
                          style:
                              Theme.of(sheetContext).textTheme.titleMedium),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext)),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        hintText: "Edit message here...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                      child: const Text("Send",style: TextStyle(   fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),),
                      onPressed: () {
                        final updated =
                            Map<String, dynamic>.from(template)
                              ..["message"] =
                                  messageController.text.trim();
                        cubit.sendSmsTemplate(updated);
                        Navigator.pop(sheetContext);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openTransferSheet(BuildContext context,
      {required bool isAttended, required bool isConference}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: context.read<CallStateCubit>(),
        child: TransferBottomSheet(
            isAttended: isAttended, isConference: isConference),
      ),
    );
  }
}

class ClickGuard {
  static bool locked = false;

  static Future<void> run(Future<void> Function() action) async {
    if (locked) return;
    locked = true;
    try {
      await action();
    } finally {
      locked = false;
    }
  }
}

// class CallScreen extends StatelessWidget {
//   const CallScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("🏗️ CallScreen build called");

//     return BlocListener<CallStateCubit, CallState>(
//       listenWhen: (prev, curr) {
//         final shouldListen = curr.showCrmForm == true &&
//             curr.crmPopupShown == false &&
//             prev.crmPopupShown == false;

//         debugPrint("🔍 listenWhen check:");
//         debugPrint("  - showCrmForm: ${curr.showCrmForm}");
//         debugPrint("  - curr.crmPopupShown: ${curr.crmPopupShown}");
//         debugPrint("  - prev.crmPopupShown: ${prev.crmPopupShown}");
//         debugPrint("  - RESULT: $shouldListen");

//         return shouldListen;
//       },
//       listener: (context, state) {
//         debugPrint("🚨 CRM LISTENER TRIGGERED!");
//         context.read<CallStateCubit>().markCrmPopupShown();
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           openCrmSheet(context);
//         });
//       },
//       child: const _CallScreenBody(),
//     );
//   }
// }

// void openCrmSheet(BuildContext context) {
//   final cubit = context.read<CallStateCubit>();
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     useSafeArea: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (sheetContext) =>
//         BlocProvider.value(value: cubit, child: const CrmFormSheet()),
//   ).whenComplete(() => debugPrint("🔒 CRM sheet closed"));
// }

// class _CallScreenBody extends StatefulWidget {
//   const _CallScreenBody({super.key});

//   @override
//   State<_CallScreenBody> createState() => _CallScreenBodyState();
// }

// class _CallScreenBodyState extends State<_CallScreenBody> {
//   bool _surveySent = false;

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.watch<CallStateCubit>();
//     final state = cubit.state;

//     // ── Icon disable rules ────────────────────────────────────────────────
//     //
//     //  state.areIconsDisabled  →  true from cbwt_confirmed until either:
//     //    • transfer_clear_confirmed  (other agent didn't answer → back to idle)
//     //    • call ends via clear_live_calls  (other agent answered → done)
//     //
//     //  state.isConferenceButtonDisabled  →  true once conference succeeded.
//     //    The Conf button stays disabled for the entire remainder of the call.
//     //
//     //  Survey button is NEVER disabled by transfer state.

//     final iconsDisabled = state.areIconsDisabled;
//     final confDisabled = state.isConferenceButtonDisabled;

//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: AppColors.appColor,
//         body: SafeArea(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColors.appColor,
//                   AppColors.appColor.withOpacity(0.8),
//                 ],
//               ),
//             ),
//             child: Column(
//               children: [
//                 // ── Header ───────────────────────────────────────────────
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Active Call",
//                         style: AppTextStyle.white18
//                             .copyWith(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(width: 8),

//                       // Call type chip
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           CallSession.callType ?? "Outgoing",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 12),
//                         ),
//                       ),

//                       const SizedBox(width: 8),

//                       // Transfer status badge — shown while icons are disabled
//                       if (iconsDisabled)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.orange.shade700,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Text(
//                             "Transferring...",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),

//                       // Conference live badge
//                       if (state.transferStatus == TransferStatus.conferenceLive)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 5),
//                           decoration: BoxDecoration(
//                             color: Colors.purple.shade600,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Text(
//                             "Conference",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),

//                       // Top-right icon row — also disabled during transfer
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: Opacity(
//                             opacity: iconsDisabled ? 0.3 : 1.0,
//                             child: IgnorePointer(
//                               ignoring: iconsDisabled,
//                               child: Wrap(
//                                 spacing: 4,
//                                 runSpacing: 4,
//                                 children: [
//                                   IconButton(
//                                     tooltip: "Disposition",
//                                     icon: const Icon(
//                                         Icons.assignment_turned_in_outlined,
//                                         color: Colors.white,
//                                         size: 22),
//                                     onPressed: () =>
//                                         openDispositionSheet(context),
//                                   ),
//                                   IconButton(
//                                     tooltip: "History",
//                                     icon: const Icon(Icons.history,
//                                         color: Colors.white, size: 22),
//                                     onPressed: () async {
//                                       ClickGuard.run(() async {
//                                         await cubit.loadInteractionHistory(
//                                             customerNumber:
//                                                 cubit.state.phoneNumber);
//                                         _openInteractionHistorySheet(context);
//                                       });
//                                     },
//                                   ),
//                                   if (state.showCrmForm)
//                                     IconButton(
//                                       tooltip: "CRM",
//                                       icon: const Icon(
//                                           Icons.assignment_outlined,
//                                           color: Colors.white,
//                                           size: 22),
//                                       onPressed: () => openCrmSheet(context),
//                                     ),
//                                   IconButton(
//                                     tooltip: "SMS",
//                                     icon: const FaIcon(
//                                         FontAwesomeIcons.message,
//                                         color: Colors.white,
//                                         size: 18),
//                                     onPressed: () async {
//                                       ClickGuard.run(() async {
//                                         await cubit.loadSmsTemplates();
//                                         _openTemplateSheet(context,
//                                             type: "sms");
//                                       });
//                                     },
//                                   ),
//                                   IconButton(
//                                     tooltip: "WhatsApp",
//                                     icon: const FaIcon(
//                                         FontAwesomeIcons.whatsapp,
//                                         color: Colors.white,
//                                         size: 20),
//                                     onPressed: () async {
//                                       ClickGuard.run(() async {
//                                         await cubit.loadWhatsappTemplates();
//                                         _openTemplateSheet(context,
//                                             type: "whatsapp");
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const Spacer(),

//                 // ── Avatar + caller info ─────────────────────────────────
//                 Column(
//                   children: [
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.2),
//                         border: Border.all(
//                             color: Colors.white.withOpacity(0.3), width: 3),
//                       ),
//                       child: Center(
//                         child: Text(
//                           state.callerName.isNotEmpty
//                               ? state.callerName[0].toUpperCase()
//                               : "U",
//                           style: const TextStyle(
//                               fontSize: 48,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     Text(state.callerName,
//                         style: const TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white)),
//                     const SizedBox(height: 8),
//                     Text(state.phoneNumber,
//                         style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 16)),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Text(
//                         _formatDuration(state.duration),
//                         style: const TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 1.2),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const Spacer(),

//                 // ── Action buttons ───────────────────────────────────────
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Hold — disabled during transfer
//                       _disableable(
//                         disabled: iconsDisabled,
//                         child: _actionBtn(
//                           icon:
//                               state.isHold ? Icons.play_arrow : Icons.pause,
//                           label: state.isHold ? "Resume" : "Hold",
//                           color: Colors.orange,
//                           onTap: () {
//                             ClickGuard.run(() async {
//                               if (state.isHold) {
//                                 cubit.unhold(
//                                   smeId: CallSession.smeId!,
//                                   sessionId: CallSession.sessionId!,
//                                   channelId: CallSession.channelId!,
//                                   agentId: CallSession.agentId!,
//                                   agentName: CallSession.agentName!,
//                                 );
//                               } else {
//                                 cubit.hold(
//                                   smeId: CallSession.smeId!,
//                                   sessionId: CallSession.sessionId!,
//                                   channelId: CallSession.channelId!,
//                                   agentId: CallSession.agentId!,
//                                   agentName: CallSession.agentName!,
//                                 );
//                               }
//                             });
//                           },
//                         ),
//                       ),

//                       // Mute — disabled during transfer
//                       _disableable(
//                         disabled: iconsDisabled,
//                         child: _actionBtn(
//                           icon: state.isMuted ? Icons.mic_off : Icons.mic,
//                           label: state.isMuted ? "Unmute" : "Mute",
//                           color: state.isMuted ? Colors.red : Colors.blue,
//                           onTap: () {
//                             ClickGuard.run(() async {
//                               if (state.isMuted) {
//                                 cubit.unmute(
//                                   smeId: CallSession.smeId!,
//                                   sessionId: CallSession.sessionId!,
//                                   channelId: CallSession.channelId!,
//                                   agentId: CallSession.agentId!,
//                                   agentName: CallSession.agentName!,
//                                 );
//                               } else {
//                                 cubit.mute(
//                                   smeId: CallSession.smeId!,
//                                   sessionId: CallSession.sessionId!,
//                                   channelId: CallSession.channelId!,
//                                   agentId: CallSession.agentId!,
//                                   agentName: CallSession.agentName!,
//                                 );
//                               }
//                             });
//                           },
//                         ),
//                       ),

//                       // Transfer — disabled during transfer
//                       _disableable(
//                         disabled: iconsDisabled,
//                         child: _actionBtn(
//                           icon: Icons.swap_horiz,
//                           label: "Transfer",
//                           color: Colors.teal,
//                           onTap: () {
//                             ClickGuard.run(() async {
//                               _openTransferSheet(context,
//                                   isAttended: false, isConference: false);
//                             });
//                           },
//                         ),
//                       ),

//                       // Conference — disabled during transfer OR permanently after conf
//                       _disableable(
//                         disabled: iconsDisabled || confDisabled,
//                         child: _actionBtn(
//                           icon: Icons.group,
//                           label: "Conf.",
//                           color: Colors.purple,
//                           onTap: () {
//                             ClickGuard.run(() async {
//                               _openTransferSheet(context,
//                                   isAttended: true, isConference: true);
//                             });
//                           },
//                         ),
//                       ),

//                       // Survey — NEVER disabled by transfer state
//                       if (CampaignManager.campaign?.isSurveyEnabled == true)
//                         Opacity(
//                           opacity: _surveySent ? 0.4 : 1.0,
//                           child: IgnorePointer(
//                             ignoring: _surveySent,
//                             child: _actionBtn(
//                               icon: Icons.poll,
//                               label: "Survey",
//                               color: Colors.green,
//                               onTap: () {
//                                 ClickGuard.run(() async {
//                                   final res = await cubit.sendSurveyIVR();
//                                   if (res == true) {
//                                     setState(() => _surveySent = true);
//                                   }
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // ── End Call button ──────────────────────────────────────
//                 GestureDetector(
//                   onTap: () async {
//                     ClickGuard.run(() async {
//                       await cubit.drop(
//                         smeId: CallSession.smeId!,
//                         sessionId: CallSession.sessionId!,
//                         channelId: CallSession.channelId!,
//                         agentId: CallSession.agentId!,
//                         agentName: CallSession.agentName!,
//                       );
//                     });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(22),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.red,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.red.withOpacity(0.4),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(Icons.call_end,
//                         color: Colors.white, size: 32),
//                   ),
//                 ),

//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Helpers ──────────────────────────────────────────────────────────────

//   String _formatDuration(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
//   }

//   /// Wraps a widget with Opacity + IgnorePointer when [disabled] is true.
//   Widget _disableable({required bool disabled, required Widget child}) {
//     return Opacity(
//       opacity: disabled ? 0.35 : 1.0,
//       child: IgnorePointer(ignoring: disabled, child: child),
//     );
//   }

//   Widget _actionBtn({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               shape: BoxShape.circle,
//               border: Border.all(
//                   color: Colors.white.withOpacity(0.2), width: 1),
//             ),
//             child: Icon(icon, color: Colors.white, size: 24),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 12,
//               fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }

//   void openCrmSheet(BuildContext context) {
//     final cubit = context.read<CallStateCubit>();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (sheetContext) =>
//           BlocProvider.value(value: cubit, child: const CrmFormSheet()),
//     );
//   }

//   void _openInteractionHistorySheet(BuildContext context) {
//     final cubit = context.read<CallStateCubit>();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: false,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) => BlocProvider.value(
//           value: cubit, child: const InteractionHistorySheet()),
//     );
//   }

//   void openDispositionSheet(BuildContext context) {
//     final callCubit = context.read<CallStateCubit>();
//     final userCubit = UserDetailsCubit.instance!;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) => MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: callCubit),
//           BlocProvider.value(value: userCubit),
//         ],
//         child: DispositionBottomSheet(cubit: callCubit),
//       ),
//     );
//   }

//   void _openTemplateSheet(BuildContext context, {required String type}) {
//     final cubit = context.read<CallStateCubit>();
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: false,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) => BlocProvider.value(
//         value: cubit,
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.55,
//           child: BlocBuilder<CallStateCubit, CallState>(
//             builder: (context, state) {
//               final templates = type == "sms"
//                   ? state.smsTemplates
//                   : state.whatsappTemplates;
//               if (templates.isEmpty) {
//                 return const Center(child: Text("No templates found"));
//               }
//               return Column(
//                 children: [
//                   const SizedBox(height: 12),
//                   Text(
//                     type == "sms" ? "SMS Templates" : "WhatsApp Templates",
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const Divider(),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: templates.length,
//                       itemBuilder: (_, index) {
//                         final t = templates[index];
//                         return ListTile(
//                           title: Text(type == "sms"
//                               ? t["template_name"]
//                               : t["name"]),
//                           trailing: const Icon(Icons.arrow_forward_ios,
//                               size: 16),
//                           onTap: () {
//                             Navigator.pop(context);
//                             if (type == "sms") {
//                               _openPreviewSheet(context,
//                                   template: t, type: type);
//                             } else {
//                               cubit.sendWhatsappTemplate(t);
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _openPreviewSheet(BuildContext context,
//       {required Map<String, dynamic> template, required String type}) {
//     final cubit = context.read<CallStateCubit>();
//     final messageController =
//         TextEditingController(text: template["message"] ?? "");

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (sheetContext) {
//         return BlocProvider.value(
//           value: cubit,
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: 16,
//               right: 16,
//               top: 16,
//               bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
//             ),
//             child: SizedBox(
//               height: MediaQuery.of(sheetContext).size.height * 0.45,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Preview Message",
//                           style:
//                               Theme.of(sheetContext).textTheme.titleMedium),
//                       IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => Navigator.pop(sheetContext)),
//                     ],
//                   ),
//                   const Divider(),
//                   Expanded(
//                     child: TextField(
//                       controller: messageController,
//                       maxLines: null,
//                       expands: true,
//                       decoration: InputDecoration(
//                         hintText: "Edit message here...",
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none),
//                         contentPadding: const EdgeInsets.all(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: ElevatedButton(
//                       child: const Text("Send"),
//                       onPressed: () {
//                         final updated =
//                             Map<String, dynamic>.from(template)
//                               ..["message"] =
//                                   messageController.text.trim();
//                         cubit.sendSmsTemplate(updated);
//                         Navigator.pop(sheetContext);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _openTransferSheet(BuildContext context,
//       {required bool isAttended, required bool isConference}) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) => BlocProvider.value(
//         value: context.read<CallStateCubit>(),
//         child: TransferBottomSheet(
//             isAttended: isAttended, isConference: isConference),
//       ),
//     );
//   }
// }

// class ClickGuard {
//   static bool locked = false;

//   static Future<void> run(Future<void> Function() action) async {
//     if (locked) return;
//     locked = true;
//     try {
//       await action();
//     } finally {
//       locked = false;
//     }
//   }
// }


// class CallScreen extends StatelessWidget {
//   const CallScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     debugPrint("🏗️ CallScreen build called");
    
//     return BlocListener<CallStateCubit, CallState>(
//       listenWhen: (prev, curr) {
//         final shouldListen = curr.showCrmForm == true &&
//             curr.crmPopupShown == false &&
//             prev.crmPopupShown == false;
        
//         debugPrint("🔍 listenWhen check:");
//         debugPrint("  - showCrmForm: ${curr.showCrmForm}");
//         debugPrint("  - curr.crmPopupShown: ${curr.crmPopupShown}");
//         debugPrint("  - prev.crmPopupShown: ${prev.crmPopupShown}");
//         debugPrint("  - RESULT: $shouldListen");
        
//         return shouldListen;
//       },
//       listener: (context, state) {
//         debugPrint("🚨 CRM LISTENER TRIGGERED!");
//         debugPrint("  - showCrmForm: ${state.showCrmForm}");
//         debugPrint("  - crmPopupShown: ${state.crmPopupShown}");
//         debugPrint("  - crmFormName: ${state.crmFormName}");
        
//         // mark popup shown BEFORE opening
//         context.read<CallStateCubit>().markCrmPopupShown();

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           debugPrint("✅ Opening CRM sheet via postFrameCallback");
//           openCrmSheet(context);
//         });
//       },
//       child: const _CallScreenBody(),
//     );
//   }
// }

// void openCrmSheet(BuildContext context) {
//   debugPrint("📋 openCrmSheet called");
//   final cubit = context.read<CallStateCubit>();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//         useSafeArea: true,         

//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (sheetContext) {
//       debugPrint("🎨 CRM sheet builder called");
//       return BlocProvider.value(
//         value: cubit,
//         // child: SizedBox(
//           // height: MediaQuery.of(sheetContext).size.height * 0.6,
//           child: const CrmFormSheet(),
//         // ),
//       );
//     },
//   ).whenComplete(() {
//     debugPrint("🔒 CRM sheet closed");
//   });
// }


// class _CallScreenBody extends StatefulWidget {
//   const _CallScreenBody({super.key});

//   @override
//   State<_CallScreenBody> createState() => _CallScreenBodyState();
// }

// class _CallScreenBodyState extends State<_CallScreenBody> {
//   bool _surveySent = false;
//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.watch<CallStateCubit>();
//     final state = cubit.state;
//     final isConferenceDone = state.conferenceCompleted;
// final isTransferInProgress = state.attendedTransferInProgress || state.isTransferInProgress;


//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//          resizeToAvoidBottomInset: false,
//         backgroundColor: AppColors.appColor,
//         body: SafeArea(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColors.appColor,
//                   AppColors.appColor.withOpacity(0.8),
//                 ],
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Header
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     // LEFT: Title
//     Text(
//       "Active Call",
//       style: AppTextStyle.white18.copyWith(
//         fontWeight: FontWeight.w600,
//       ),
//     ),

//     const SizedBox(width: 8),

//     // MIDDLE: Call type chip
//     Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         CallSession.callType ?? "Outgoing",
//         style: const TextStyle(color: Colors.white, fontSize: 12),
//         textAlign: TextAlign.center,
//       ),
//     ),

//     const SizedBox(width: 8),

//     // RIGHT: Icons (CONSTRAINED)
//     Expanded(
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: Wrap(
//           spacing: 4,
//           runSpacing: 4,
//           children: [
//             IconButton(
//               tooltip: "Disposition",
//               icon: const Icon(Icons.assignment_turned_in_outlined,
//                   color: Colors.white, size: 22),
//               onPressed: () => openDispositionSheet(context),
//             ),

//             IconButton(
//               tooltip: "History",
//               icon: const Icon(Icons.history,
//                   color: Colors.white, size: 22),
//               onPressed: () async {
//                    ClickGuard.run(() async {
//                 final cubit = context.read<CallStateCubit>();
//                 await cubit.loadInteractionHistory(
//                   customerNumber: cubit.state.phoneNumber,
//                 );
               

//                 _openInteractionHistorySheet(context);
//                   });
//               },
//             ),

//             if (state.showCrmForm)
//               IconButton(
//                 tooltip: "CRM",
//                 icon: const Icon(Icons.assignment_outlined,
//                     color: Colors.white, size: 22),
//                 onPressed: () => openCrmSheet(context),
//               ),

//             IconButton(
//               tooltip: "SMS",
//               icon: const FaIcon(FontAwesomeIcons.message,
//                   color: Colors.white, size: 18),
//               onPressed: () async {
//                   ClickGuard.run(() async {

//                 final cubit = context.read<CallStateCubit>();
//                 await cubit.loadSmsTemplates();
//                 _openTemplateSheet(context, type: "sms");
//                   });
//               },
//             ),

//             IconButton(
//               tooltip: "WhatsApp",
//               icon: const FaIcon(FontAwesomeIcons.whatsapp,
//                   color: Colors.white, size: 20),
//               onPressed: () async {
//                   ClickGuard.run(() async {

//                 final cubit = context.read<CallStateCubit>();
//                 await cubit.loadWhatsappTemplates();
//                 _openTemplateSheet(context, type: "whatsapp");
             
//                }); },
//             ),
//           ],
//         ),
//       ),
//     ),
//   ],
// ),

//                 ),
      
//                 const Spacer(),
      
//                 // Avatar and Info
//                 Column(
//                   children: [
//                     // Avatar
//                     Container(
//                       width: 120,
//                       height: 120,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.2),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                           width: 3,
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           state.callerName.isNotEmpty
//                               ? state.callerName[0].toUpperCase()
//                               : "U",
//                           style: const TextStyle(
//                             fontSize: 48,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
      
//                     const SizedBox(height: 24),
      
//                     // Name
//                     Text(
//                       state.callerName,
//                       style: const TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
      
//                     const SizedBox(height: 8),
      
//                     // Phone Number
//                     Text(
//                       state.phoneNumber,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 16,
//                       ),
//                     ),
      
//                     const SizedBox(height: 16),
      
//                     // Duration
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Text(
//                         _formatDuration(state.duration),
//                         style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           letterSpacing: 1.2,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
      
//                 const Spacer(),
      
//                 // Action Buttons
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _actionBtn(
//                         icon: state.isHold ? Icons.play_arrow : Icons.pause,
//                         label: state.isHold ? "Resume" : "Hold",
//                         color: Colors.orange,
//                         onTap: () {
//                                                         ClickGuard.run(() async {

//                           if (state.isHold) {

//                             cubit.unhold(
//                               smeId: CallSession.smeId!,
//                               sessionId: CallSession.sessionId!,
//                               channelId: CallSession.channelId!,
//                               agentId: CallSession.agentId!,
//                               agentName: CallSession.agentName!,
//                             );
//                           } else {
//                             cubit.hold(
//                               smeId: CallSession.smeId!,
//                               sessionId: CallSession.sessionId!,
//                               channelId: CallSession.channelId!,
//                               agentId: CallSession.agentId!,
//                               agentName: CallSession.agentName!,
//                             );
//                             }
//                          }); },
//                       ),
//                       _actionBtn(
//                         icon: state.isMuted ? Icons.mic_off : Icons.mic,
//                         label: state.isMuted ? "Unmute" : "Mute",
//                         color: state.isMuted ? Colors.red : Colors.blue,
//                         onTap: () {
//                             ClickGuard.run(() async {

//                           if (state.isMuted) {
                            
//                             cubit.unmute(
//                               smeId: CallSession.smeId!,
//                               sessionId: CallSession.sessionId!,
//                               channelId: CallSession.channelId!,
//                               agentId: CallSession.agentId!,
//                               agentName: CallSession.agentName!,
//                             );
//                           } else {
//                             cubit.mute(
//                               smeId: CallSession.smeId!,
//                               sessionId: CallSession.sessionId!,
//                               channelId: CallSession.channelId!,
//                               agentId: CallSession.agentId!,
//                               agentName: CallSession.agentName!,
//                             );
//                           }
                        
//                         });},
//                       ),
//                       // _actionBtn(
//                       //   icon: Icons.swap_horiz,
//                       //   label: "Transfer",
//                       //   color: Colors.teal,
//                       //   onTap: () {
//                       //       ClickGuard.run(() async {
//                       //     _openTransferSheet(context,
//                       //         isAttended: false, isConference: false);
//                       //       });
//                       //   },
//                       // ),

//                       _actionBtn(
//   icon: Icons.swap_horiz,
//   label: "Transfer",
//   color: isTransferInProgress ? Colors.grey : Colors.teal,
//   onTap: isTransferInProgress ? () {} : () {
//     ClickGuard.run(() async {
//       _openTransferSheet(context, isAttended: false, isConference: false);
//     });
//   },
// ),
//                       // _actionBtn(
//                       //   icon: Icons.group,
//                       //   label: "Conf.",
//                       //   color: Colors.purple,
//                       //   onTap: () {
//                       //       ClickGuard.run(() async {

//                       //     _openTransferSheet(context,
//                       //         isAttended: true, isConference: true);
//                       //       });
//                       //   },

                        
//                       // ),
//                       Opacity(
//   opacity: isConferenceDone ? 0.4 : 1.0,
//   child: IgnorePointer(
//     ignoring: isConferenceDone,
//     child: _actionBtn(
//       icon: Icons.group,
//       label: "Conf.",
//       color: Colors.purple,
//       onTap: () {
//         ClickGuard.run(() async {
//           _openTransferSheet(context, isAttended: true, isConference: true);
//         });
//       },
//     ),
//   ),
// ),

//                       if (CampaignManager.campaign?.isSurveyEnabled == true)
//   // _actionBtn(
//   //   icon: Icons.poll,
//   //   label: "Survey",
//   //   color: Colors.green,
//   //   onTap: () {
//   //       ClickGuard.run(() async {

//   //     cubit.sendSurveyIVR();
//   //       });
//   //   },
//   // ),

//   Opacity(
//   opacity: _surveySent ? 0.4 : 1,
//   child: IgnorePointer(
//     ignoring: _surveySent,
//     child: _actionBtn(
//       icon: Icons.poll,
//       label:  "Survey",
//       color: Colors.green,
//       onTap: () {
//         ClickGuard.run(() async {
//           final res = await cubit.sendSurveyIVR();

//           if (res == true) {   // adjust if your method returns success
//             setState(() => _surveySent = true); 
//           }
//         });
//       },
//     ),
//   ),
// ),

//                     ],
//                   ),
//                 ),
      
//                 const SizedBox(height: 40),
      
//                 // End Call Button
//                 GestureDetector(
//                   onTap: () async {
//                       ClickGuard.run(() async {
//                     await cubit.drop(
//                       smeId: CallSession.smeId!,
//                       sessionId: CallSession.sessionId!,
//                       channelId: CallSession.channelId!,
//                       agentId: CallSession.agentId!,
//                       agentName: CallSession.agentName!,
//                     );
//                     // if (context.mounted) {
//                     //   Navigator.pop(context);
//                     // }
//                       });
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(22),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.red,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.red.withOpacity(0.4),
//                           blurRadius: 20,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: const Icon(
//                       Icons.call_end,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                 ),
      
//                 const SizedBox(height: 50),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration d) {
//     String two(int n) => n.toString().padLeft(2, '0');
//     final minutes = d.inMinutes;
//     final seconds = d.inSeconds % 60;
//     return "${two(minutes)}:${two(seconds)}";
//   }

// void openCrmSheet(BuildContext context) {
//   final cubit = context.read<CallStateCubit>();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//       backgroundColor: Colors.white,

//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (sheetContext) {
//       return BlocProvider.value(
//         value: cubit,
//         child: const CrmFormSheet(),
//       );
//     },
//   );
// }

// void _openInteractionHistorySheet(BuildContext context) {
//   final cubit = context.read<CallStateCubit>();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: false,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) {
//       return BlocProvider.value(
//         value: cubit,
//         child: const InteractionHistorySheet(),
//       );
//     },
//   );
// }

// void openDispositionSheet(BuildContext context) {
//   final callCubit = context.read<CallStateCubit>();
//   final userCubit = UserDetailsCubit.instance!;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) {
//       return MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: callCubit),
//           BlocProvider.value(value: userCubit),
//         ],
//         child: DispositionBottomSheet(cubit: callCubit),
//       );
//     },
//   );
// }

// void _openTemplateSheet(
//   BuildContext context, {
//   required String type,   // "sms" | "whatsapp"
// }) {
//   final cubit = context.read<CallStateCubit>();

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: false,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) {
//       return BlocProvider.value(
//         value: cubit,
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.55,
//           child: BlocBuilder<CallStateCubit, CallState>(
//             builder: (context, state) {
//               final templates =
//                   type == "sms" ? state.smsTemplates : state.whatsappTemplates;

//               if (templates.isEmpty) {
//                 return const Center(child: Text("No templates found"));
//               }

//               return Column(
//                 children: [
//                   const SizedBox(height: 12),
//                   Text(
//                     type == "sms" ? "SMS Templates" : "WhatsApp Templates",
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const Divider(),

//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: templates.length,
//                       itemBuilder: (_, index) {
//                         final t = templates[index];

//                         return ListTile(
//                           title: Text(
//                             type == "sms"
//                                 ? t["template_name"]
//                                 : t["name"],
//                           ),
//                           trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                           onTap: () {
//                             Navigator.pop(context);

//                             if (type == "sms") {
//                               //  SMS → Open editable preview
//                               _openPreviewSheet(
//                                 context,
//                                 template: t,
//                                 type: type,
//                               );
//                             } else {
//                               // ✅ WhatsApp → Direct send (NO preview)
//                               cubit.sendWhatsappTemplate(t);
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       );
//     },
//   );
// }

// void _openPreviewSheet(
//   BuildContext context, {
//   required Map<String, dynamic> template,
//   required String type,
// }) {
//   final cubit = context.read<CallStateCubit>();

//   final TextEditingController messageController =
//       TextEditingController(text: template["message"] ?? "");

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (sheetContext) {  // ✅ Give it a proper name
//       return BlocProvider.value(
//         value: cubit,
//         child: Padding(
//           padding: EdgeInsets.only(
//             left: 16,
//             right: 16,
//             top: 16,
//             bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,  
//           ),
//           child: SizedBox(
//             height: MediaQuery.of(sheetContext).size.height * 0.45,  
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Preview Message",
//                       style: Theme.of(sheetContext).textTheme.titleMedium,  
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(sheetContext), 
//                     ),
//                   ],
//                 ),
//                 const Divider(),

//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     maxLines: null,
//                     expands: true,
//                     decoration: InputDecoration(
//                       hintText: "Edit message here...",
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.all(12),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 16),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     child: const Text("Send"),
//                     onPressed: () {
//                       final updatedTemplate = Map<String, dynamic>.from(template)
//                         ..["message"] = messageController.text.trim();

//                       cubit.sendSmsTemplate(updatedTemplate);

//                       Navigator.pop(sheetContext);  
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

//   Widget _actionBtn({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//     required Color color,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.15),
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: Icon(icon, color: Colors.white, size: 24),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   void _openTransferSheet(BuildContext context,
//       {required bool isAttended, required bool isConference}) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => BlocProvider.value(
//         value: context.read<CallStateCubit>(),
//         child: TransferBottomSheet(
//           isAttended: isAttended,
//           isConference: isConference,
//         ),
//       ),
//     );
//   }
// }

// class ClickGuard {
//   static bool locked = false;

//   static Future<void> run(Future<void> Function() action) async {
//     if (locked) return;
//     locked = true;
//     try {
//       await action();
//     } finally {
//       locked = false;
//     }
//   }
// }