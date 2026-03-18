import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';
import 'package:kommuno/features/calls/presenter/widgets/interaction_history_widget.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';


class AfterCallWrapUpScreen extends StatefulWidget {
  final String callerName;
  final String phoneNumber;
  final Duration duration;
  final bool waitingForConnection;

  const AfterCallWrapUpScreen({
    super.key,
    required this.callerName,
    required this.phoneNumber,
    required this.duration,
    this.waitingForConnection = false,
  });

  @override
  State<AfterCallWrapUpScreen> createState() => _AfterCallWrapUpScreenState();
}

class _AfterCallWrapUpScreenState extends State<AfterCallWrapUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _remarkController = TextEditingController();

  // String? _selectedDisposition;
  // String? _selectedDispositionId;

  final List<String> _selectedLevels = [];
final List<String> _selectedLevelIds = [];
  int _rating = 0;
  late Map<int, List<DispositionItem>> _groupedDispositions;

final Map<int, String?> _selectedDispositionNames = {};
final Map<int, String?> _selectedDispositionIds = {};

int _maxVisibleLevel = 1;

  bool _wrapupEnabled = false;
int _wrapupLimitSeconds = 0;
bool _autoClosed = false;


  late Timer _timer;
  Duration displayTimer = Duration.zero;
String selectedType = "sms"; 
bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    displayTimer = widget.duration;

//  final campaign = CampaignManager.campaign;
//  _wrapupEnabled = campaign?.wrapupEnabled == true;
//   _wrapupLimitSeconds = campaign?.wrapupTimeInSeconds ?? 0;


final state = context.read<CallStateCubit>().state;
    final isIncoming = CallSession.callType?.toLowerCase() == "incoming";

    if (isIncoming) {
      _wrapupLimitSeconds = state.incomingWrapUpTime;
      _wrapupEnabled = _wrapupLimitSeconds > 0;
    } else {
      final campaign = CampaignManager.campaign;
      _wrapupEnabled = campaign?.wrapupEnabled == true;
      _wrapupLimitSeconds = campaign?.wrapupTimeInSeconds ?? 0;
    }


    debugPrint("WrapUp Enabled: $_wrapupEnabled");
    debugPrint("WrapUp Limit: $_wrapupLimitSeconds seconds");

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        displayTimer += const Duration(seconds: 1);
      });

    _checkAutoClose();

    });

  }

  @override
  void dispose() {
    _timer.cancel();
    _remarkController.dispose();
    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

void _openInteractionHistorySheet(BuildContext context) {
  final cubit = context.read<CallStateCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: const InteractionHistorySheet(),
      );
    },
  );
}


void _openTemplateSheet(
  BuildContext context, {
  required String type,   // "sms" | "whatsapp"
}) {
  final cubit = context.read<CallStateCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: BlocBuilder<CallStateCubit, CallState>(
            builder: (context, state) {
              final templates =
                  type == "sms" ? state.smsTemplates : state.whatsappTemplates;

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
                          title: Text(
                            type == "sms"
                                ? t["template_name"]
                                : t["name"],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.pop(context);

                            if (type == "sms") {
                              //  SMS → Open editable preview
                              _openPreviewSheet(
                                context,
                                template: t,
                                type: type,
                              );
                            } else {
                              //  WhatsApp → Direct send (NO preview)
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
      );
    },
  );
}
void _openPreviewSheet(
  BuildContext context, {
  required Map<String, dynamic> template,
  required String type,
}) {
  final cubit = context.read<CallStateCubit>();

  final TextEditingController messageController =
      TextEditingController(text: template["message"] ?? "");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {  // ✅ Give it a proper name
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
                    Text(
                      "Preview Message",
                      style: Theme.of(sheetContext).textTheme.titleMedium,  
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext), 
                    ),
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
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    child: const Text("Send"),
                    onPressed: () {
                      final updatedTemplate = Map<String, dynamic>.from(template)
                        ..["message"] = messageController.text.trim();

                      cubit.sendSmsTemplate(updatedTemplate);

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


  @override
  Widget build(BuildContext context) {
    final timeText = _format(displayTimer);
    // final campaign = CampaignManager.campaign;
    // final dispositions = campaign?.dispositions ?? [];


// final state = context.read<CallStateCubit>().state;
//     final isIncoming = CallSession.callType?.toLowerCase() == "incoming";

//     final dispositions = (isIncoming && state.incomingDispositions.isNotEmpty)
//         ? state.incomingDispositions
//         : (CampaignManager.campaign?.dispositions ?? []);


// _groupedDispositions =
//     CampaignManager.groupDispositionsByLevel(dispositions);

// final levels = _groupedDispositions.keys.toList()..sort();

// final bool hasDispositions = dispositions.isNotEmpty;


final state = context.read<CallStateCubit>().state;
    final isIncoming = CallSession.callType?.toLowerCase() == "incoming";

    final dispositions = isIncoming 
        ? state.incomingDispositions 
        : (CampaignManager.campaign?.dispositions ?? []);

    _groupedDispositions = CampaignManager.groupDispositionsByLevel(dispositions);
    final levels = _groupedDispositions.keys.toList()..sort();
    final bool hasDispositions = dispositions.isNotEmpty;
    return PopScope(
      canPop: false, 
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: AppColors.appColor,
          elevation: 0,
          title: Text(
           widget.waitingForConnection? "Ringing Call ": "Wrap-up Call",
            style: AppTextStyle.whiteNormal.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: const SizedBox(),
          
actions: [

IconButton(
  tooltip: "Interaction History",
  icon: const Icon(
    Icons.history,
    color: Colors.white,
    size: 24,
  ),
  onPressed: () async {
    final cubit = context.read<CallStateCubit>();

    await cubit.loadInteractionHistory(
      customerNumber: cubit.state.phoneNumber,
    );

    _openInteractionHistorySheet(context);
  },
),

  IconButton(
    tooltip: "Send SMS",
    icon: const FaIcon(
  FontAwesomeIcons.message,
  color: Colors.white, // Customize the color
  size: 20,         // Customize the size
)
,
    onPressed: () async {
      final cubit = context.read<CallStateCubit>();
      selectedType = "sms";
      await cubit.loadSmsTemplates();
      _openTemplateSheet(context, type: "sms");
    },
  ),

  IconButton(
    tooltip: "Send WhatsApp",
    icon: const FaIcon(
  FontAwesomeIcons.whatsapp,
  color: Colors.white, // Customize the color
  size: 21,         // Customize the size
)
,
    onPressed: () async {
      final cubit = context.read<CallStateCubit>();
      selectedType = "whatsapp";
      await cubit.loadWhatsappTemplates();
      _openTemplateSheet(context, type: "whatsapp");
    },
  ),
],
        ),
        body: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              decoration:  const BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.callerName.isNotEmpty
                            ? widget.callerName[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
      
                  // Name
                  Text(
                    widget.callerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
      
                  // Phone
                  Text(
                    widget.phoneNumber,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
      
                  // Call Type
                  Text(
                    CallSession.callType ?? "Outgoing",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
      
                  // Timer Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white.withOpacity(0.9),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  // Waiting Indicator
                  if (widget.waitingForConnection) ...[
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Waiting for customer to answer...",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
      
            // Form Content
            Expanded(
              child: SingleChildScrollView(
   padding: EdgeInsets.fromLTRB(
      20,
      20,
      20,
      MediaQuery.of(context).viewInsets.bottom + 20,
    ),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      // Disposition
                      _sectionLabel("Disposition *"),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: 
            
                       hasDispositions
      ?  

  Column(
    children: levels.map((level) {
      final shouldShow = level <= _maxVisibleLevel;
      if (!shouldShow) return const SizedBox();

      final items = _groupedDispositions[level]!;

      return Padding(
        padding: const EdgeInsets.all(5),
        child: DropdownButtonFormField2<String>(
          isExpanded: true,

          decoration: _outlinedDecoration(
            hint: "Select Level $level Disposition",
          ).copyWith(
            suffixIcon: _selectedDispositionIds[level] != null
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedDispositionIds.remove(level);
                        _selectedDispositionNames.remove(level);
                      });
                    },
                  )
                : null,
          ),

          value: _selectedDispositionIds[level],

          items: items.map((d) {
            return DropdownMenuItem<String>(
              value: d.id,
              child: Text(
                d.combinedField!
                    .replaceAll(RegExp(r'\s*-?\s*L\d$'), ''),
              ),
            );
          }).toList(),

          onChanged: (val) {
            setState(() {
              if (val == null) {
                _selectedDispositionIds.remove(level);
                _selectedDispositionNames.remove(level);
              } else {
                _selectedDispositionIds[level] = val;
                _selectedDispositionNames[level] =
                    items.firstWhere((e) => e.id == val).combinedField;
int currentIndex = levels.indexOf(level);
                // if (level + 1 > _maxVisibleLevel) {
                //   _maxVisibleLevel = level + 1;
                // }

                if (currentIndex != -1 && currentIndex + 1 < levels.length) {
                int nextLevel = levels[currentIndex + 1]; // Grab the actual next level (e.g., 5)
                if (nextLevel > _maxVisibleLevel) {
                  _maxVisibleLevel = nextLevel;
                }} else {
                // Fallback just in case
                if (level + 1 > _maxVisibleLevel) {
                  _maxVisibleLevel = level + 1;
                }
              }
              }
            });
          },
        ),
      );
    }).toList(),
  )

:Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            "No disposition available for this campaign",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
                      ),
      
                      const SizedBox(height: 10),
      if (_selectedLevels.isNotEmpty) ...[
  const SizedBox(height: 12),

  Column(
    children: List.generate(_selectedLevels.length, (index) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.appColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.appColor.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedLevels[index],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            GestureDetector(
            onTap: () {
  setState(() {
    _selectedLevels.removeAt(index);
    _selectedLevelIds.removeAt(index);
  });
},
              child: const Icon(
                Icons.close,
                size: 18,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }),
  ),
],                      const SizedBox(height: 10),

                      // Remark
                      _sectionLabel("Remarks"),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: 
                        TextFormField(
                          controller: _remarkController,
  minLines: 3,
  maxLines: 5,                        
                          decoration: InputDecoration(
                            hintText: "Enter your remarks here...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
      
                      const SizedBox(height: 10),
      
                      // Rating
                      _sectionLabel("Rate this call"),
                      const SizedBox(height: 12),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) {
                            return GestureDetector(
                              onTap: () => setState(() => _rating = i + 1),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  i < _rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 36,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
      
            // Save Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
 

onPressed: (_isSaving || _autoClosed)
    ? null
    : () async {
        _timer.cancel();       // stop the countdown immediately
        _autoClosed = true;    // block _autoCloseWrapUp from racing
        setState(() => _isSaving = true);
       

        try {
          final selectedEntries = _selectedDispositionNames.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));

          final dispositionName = selectedEntries.isNotEmpty
              ? selectedEntries.map((e) => e.value).join(", ")
              : "";

          final dispositionId = selectedEntries.isNotEmpty
              ? _selectedDispositionIds[selectedEntries.last.key]
              : "";

          final cubit = context.read<CallStateCubit>();

          if (widget.waitingForConnection) {
            await cubit.saveWrapUpInRingingState(
              context: context,
              dispositionName: dispositionName,
              dispositionId: dispositionId ?? '',
              remarks: _remarkController.text.trim(),
              rating: _rating,
              wrapUpSeconds: displayTimer.inSeconds,
            );

          
if (mounted) {
    setState(() {
      _resetForm();     
    });
  }
            //  show confirmation
            if (mounted) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text("Form submitted successfully"),
              //     backgroundColor: Colors.green,
              //   ),
              // );
                  FToastManager().showToast(message: "Form submitted successfully");

            }

          } else {
            await cubit.saveWrapUp(
              context: context,
              dispositionName: dispositionName,
              dispositionId: dispositionId ?? '',
              remarks: _remarkController.text.trim(),
              rating: _rating,
              wrapUpSeconds: displayTimer.inSeconds,
            );

            if (mounted) Navigator.pop(context);
          }
        } finally {
          if (mounted) setState(() => _isSaving = false);
        }
      },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
    ? const     AppLoadingIndicator()

    : const Text(
        "Save & Continue",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
  void _checkAutoClose() {
  if (_autoClosed) return;

  //  Do NOT auto wrapup if waiting for customer
  if (widget.waitingForConnection) {
    debugPrint(" Waiting for customer → Auto wrapup paused");
    return;
  }

  if (_wrapupEnabled &&
      _wrapupLimitSeconds > 0 &&
      displayTimer.inSeconds >= _wrapupLimitSeconds &&
      _selectedDispositionNames.isEmpty) {

    debugPrint("WrapUp time completed → Auto closing screen");

    _autoClosed = true;
    _timer.cancel();

    _autoCloseWrapUp();
  }
}

void _resetForm() {
  // Clear remark
  _remarkController.clear();

  // Reset rating
  _rating = 0;

  // Reset dispositions
  _selectedDispositionIds.clear();
  _selectedDispositionNames.clear();

  // Reset level visibility
  _maxVisibleLevel = 1;

  // (Optional) clear old multi-select chips if still used
  _selectedLevels.clear();
  _selectedLevelIds.clear();
}

Future<void> _autoCloseWrapUp() async {
    if (!mounted) return;
  if (_isSaving) return; // user already saving manually —

  try {

final selectedEntries = _selectedDispositionNames.entries.toList()
  ..sort((a, b) => a.key.compareTo(b.key));

final dispositionName = selectedEntries.isNotEmpty
    ? selectedEntries.map((e) => e.value).join(", ")
    : "";

final dispositionId = selectedEntries.isNotEmpty
    ? _selectedDispositionIds[selectedEntries.last.key]
    : "";
    await context.read<CallStateCubit>().saveWrapUp(
      context: context,
     dispositionName: dispositionName??'',
      dispositionId: dispositionId??"",
      remarks: _remarkController.text.trim(),
      rating: _rating,
                                  wrapUpSeconds: displayTimer.inSeconds, 

    );
  } catch (e) {
    debugPrint("Auto wrapup save failed: $e");
  }

  if (mounted) {
    Navigator.pop(context);
  }
}

  /// DECORATION
  InputDecoration _outlinedDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(height: 2),
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppColors.appColor.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColors.appColor,
          width: 2,
        ),
      ),
    );
  }
}