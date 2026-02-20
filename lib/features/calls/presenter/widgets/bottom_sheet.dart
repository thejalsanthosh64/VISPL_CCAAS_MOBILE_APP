import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/data/model/agent_queue_model.dart';


class TransferBottomSheet extends StatefulWidget {
  final bool isAttended;
  final bool isConference;

  const TransferBottomSheet({
    super.key,
    required this.isAttended,
    required this.isConference,
  });

  @override
  State<TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<TransferBottomSheet> {
  // Step 1: Transfer type selection
  String? selectedTransferType;
  
  // Step 2: Specific selection based on type
  dynamic selectedAgent;
  dynamic selectedTeamLead;
  dynamic selectedQueue;
  dynamic selectedQueueAgent;
  dynamic selectedSameQueueAgent;
  String? externalNumber;

  // Data lists
  List<dynamic> agents = [];
  List<dynamic> teamLeads = [];
  List<dynamic> queues = [];
  List<QueueAgentModel> queueAgents = [];
  List<QueueAgentModel> sameQueueAgents = [];
  
  bool loading = false;
  bool loadingSecondary = false;

  final transferTypes = [
    {'value': 'agent', 'label': 'Transfer to Agent'},
    {'value': 'team_lead', 'label': 'Transfer to Team Lead'},
    {'value': 'specific_queue_agent', 'label': 'Specific Agent of Specific Queue'},
    {'value': 'specific_queue', 'label': 'Specific Queue'},
    {'value': 'same_queue', 'label': 'Same Queue'},
    {'value': 'outside_number', 'label': 'External Number'},
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadDataForType(String type) async {
    setState(() {
      loading = true;
      // Reset selections
      selectedAgent = null;
      selectedTeamLead = null;
      selectedQueue = null;
      selectedQueueAgent = null;
      selectedSameQueueAgent = null;
      externalNumber = null;
    });

    final cubit = context.read<CallStateCubit>();
    final smeId = CallSession.smeId!;

    try {
      switch (type) {
        case 'agent':
           final allAgents = await cubit.loadAllAgents(smeId);
  agents = cubit.getWaitingAgentsOnly(allAgents);

          break;
        case 'team_lead':
          // teamLeads = await cubit.loadTeamLeads(smeId);
 agents = await cubit.loadTeamLeads(smeId);

// teamLeads = allTeamLeads.where((lead) {
//   return lead["agent_live_status"] == "Waiting" &&
//          lead["agent_id"] != CallSession.agentId;
// }).toList();

          break;
        case 'specific_queue_agent':
        case 'specific_queue':
          queues = await cubit.loadAllQueues(smeId);
          break;
        case 'same_queue':
          // sameQueueAgents = await cubit.loadSameQueueAgents();
 agents = await cubit.loadSameQueueAgents();

// sameQueueAgents = allSameQueueAgents
//     .where((a) =>
//         a.agentLiveStatus == "Waiting" &&
//         a.agentId != CallSession.agentId)
//     .toList();

          break;
        case 'outside_number':
          // No data to load
          break;
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }

    setState(() => loading = false);
  }

  Future<void> loadQueueAgentsForQueue(String queueId) async {
    setState(() => loadingSecondary = true);

    final cubit = context.read<CallStateCubit>();
    final smeId = CallSession.smeId!;

    queueAgents = await cubit.loadQueueAgents(smeId, queueId);
    
    setState(() {
      loadingSecondary = false;
      selectedQueueAgent = null; // Reset selection
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isConference
        ? "Conference"
        : widget.isAttended
            ? "Attended Transfer"
            : "Blind Transfer";

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandleBar(),
          _buildHeader(title),
          if (widget.isAttended && !widget.isConference)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This call will be auto Unmuted / Unhold before Transfer",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransferTypeDropdown(),
                  if (selectedTransferType != null) ...[
                    const SizedBox(height: 20),
                    if (loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: AppColors.appColor,
                          ),
                        ),
                      )
                    else
                      _buildSecondarySelection(),
                  ],
                ],
              ),
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 16),
      height: 4,
      width: 45,
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.appColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.isConference ? Icons.group : Icons.swap_horiz,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyle.appColorNormal.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTransferTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Call Transfer To",
          style: AppTextStyle.blackNormal.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text("Select Call Transfer To"),
            value: selectedTransferType,
            items: transferTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type['value'] as String,
                child: Text(type['label'] as String),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedTransferType = value);
                loadDataForType(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecondarySelection() {
    switch (selectedTransferType) {
      case 'agent':
        return _buildAgentDropdown();
      case 'team_lead':
        return _buildTeamLeadDropdown();
      case 'specific_queue_agent':
        return Column(
          children: [
            _buildQueueDropdown(),
            if (selectedQueue != null) ...[
              const SizedBox(height: 16),
              if (loadingSecondary)
                const Center(child: CircularProgressIndicator())
              else
                _buildQueueAgentDropdown(),
            ],
          ],
        );
      case 'specific_queue':
        return _buildQueueDropdown();
      case 'same_queue':
        return _buildSameQueueDropdown();
      case 'outside_number':
        return _buildExternalNumberField();
      default:
        return const SizedBox();
    }
  }
Widget _buildAgentDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Select Agent *",
        style: AppTextStyle.blackNormal.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: DropdownButtonFormField<dynamic>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          hint: const Text("Select Agent"),
          value: selectedAgent,
          items: agents.map((agent) {
            final status = agent["agent_live_status"] ?? "-";
            final name = agent["agent_name"] ?? "Unknown";
            
            return DropdownMenuItem(
              value: agent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible( 
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: status.toString().toLowerCase() == "free"
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: status.toString().toLowerCase() == "free"
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedAgent = value);
          },
        ),
      ),
    ],
  );
}

  Widget _buildTeamLeadDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Team Lead *",
          style: AppTextStyle.blackNormal.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text("Select Team Lead"),
            value: selectedTeamLead,
            items: teamLeads.map((lead) {
              return DropdownMenuItem(
                value: lead,
                child: Text(lead["agent_name"] ?? "Unknown"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedTeamLead = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQueueDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Queue *",
          style: AppTextStyle.blackNormal.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            hint: const Text("Select Queue"),
            value: selectedQueue,
            items: queues.map((queue) {
              return DropdownMenuItem(
                value: queue,
                child: Text(queue["name"] ?? "Unknown"),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedQueue = value);
              if (selectedTransferType == 'specific_queue_agent') {
                loadQueueAgentsForQueue(value["id"].toString());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQueueAgentDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Select Agent from Queue *",
        style: AppTextStyle.blackNormal.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: DropdownButtonFormField<QueueAgentModel>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          hint: const Text("Select Agent"),
          value: selectedQueueAgent,
          items: queueAgents.map((agent) {
            final name = agent.agentName ?? "Unknown";
            
            return DropdownMenuItem(
              value: agent,
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Flexible( 
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (agent.agentLiveStatus != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: agent.agentLiveStatus?.toLowerCase() == "free"
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        agent.agentLiveStatus!,
                        style: TextStyle(
                          color: agent.agentLiveStatus?.toLowerCase() == "free"
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedQueueAgent = value);
          },
        ),
      ),
    ],
  );
}

  Widget _buildSameQueueDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Select Agent from Same Queue *",
        style: AppTextStyle.blackNormal.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: DropdownButtonFormField<QueueAgentModel>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          hint: const Text("Select Agent"),
          value: selectedSameQueueAgent,
          items: sameQueueAgents.map((agent) {
            final name = agent.agentName ?? "Unknown";
            
            return DropdownMenuItem(
              value: agent,
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Flexible( 
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (agent.agentLiveStatus != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: agent.agentLiveStatus?.toLowerCase() == "free"
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        agent.agentLiveStatus!,
                        style: TextStyle(
                          color: agent.agentLiveStatus?.toLowerCase() == "free"
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedSameQueueAgent = value);
          },
        ),
      ),
    ],
  );
}
Widget _buildExternalNumberField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Enter External Number *",
        style: AppTextStyle.blackNormal.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          setState(() {
            externalNumber = value.trim(); 
          });
        },
        decoration: InputDecoration(
          hintText: "Enter phone number (e.g., 917857684748)",
          prefixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Note: Enter number with country code (e.g., 91xxxxxxxxxx)",
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}
  Widget _buildActionButtons() {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: AppColors.appColor),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canTransfer() ? _performTransfer : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Transfer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 bool _canTransfer() {
  if (selectedTransferType == null) return false;

  switch (selectedTransferType) {
    case 'agent':
      return selectedAgent != null;
    case 'team_lead':
      return selectedTeamLead != null;
    case 'specific_queue_agent':
      return selectedQueue != null && selectedQueueAgent != null;
    case 'specific_queue':
      return selectedQueue != null;
    case 'same_queue':
      return selectedSameQueueAgent != null;
    case 'outside_number':
      //  FIX: Proper validation for external number
      return externalNumber != null && 
             externalNumber!.trim().isNotEmpty &&
             externalNumber!.trim().length >= 10; 
    default:
      return false;
  }
}


Future<void> _performTransfer() async {
  final cubit = context.read<CallStateCubit>();
  final smeId = CallSession.smeId!;
  final sessionId = CallSession.sessionId!;
  final channelId = CallSession.channelId!;
  final agentId = CallSession.agentId!;
  final agentName = CallSession.agentName!;

  try {
    
 int? targetAgentId;

  switch (selectedTransferType) {
    case 'agent':
      targetAgentId = selectedAgent?["agent_id"];
      break;
    case 'team_lead':
      targetAgentId = selectedTeamLead?["agent_id"];
      break;
    case 'specific_queue_agent':
      targetAgentId = selectedQueueAgent?.agentId;
      break;
    case 'same_queue':
      targetAgentId = selectedSameQueueAgent?.agentId;
      break;
  }

  if (targetAgentId != null &&
      targetAgentId == CallSession.agentId) {
    _showError("You cannot transfer call to yourself");
    return;
  }

  if (selectedTransferType == 'outside_number') {
    final userCubit = UserDetailsCubit.instance;
    final agentMobile = userCubit?.userDetailsModel.agentMobile;

    String normalize(String n) =>
        n.replaceAll(RegExp(r'\D'), '');

    final entered = normalize(externalNumber ?? "");
    final myNumber = normalize(agentMobile ?? "");
print("entered$entered");
print("myNumber$myNumber");

    if (entered.isNotEmpty && entered == myNumber) {
      _showError("You cannot transfer call to your own number");
      return;
    }
  }

    switch (selectedTransferType) {
      
      case 'agent':
        final agent = selectedAgent;
        final status = agent["agent_live_status"] ?? "";
        
        // if (status.toString().toLowerCase() != "free") {
        //   _showError("Agent is not available");
        //   return;
        // }

        if (widget.isConference) {
          // Conference flow
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            transferToAgentId: agent["agent_id"],
            agentMobile: agent["agent_mobile"],
          );
          await Future.delayed(const Duration(seconds: 1));
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            action: "conference",
          );
        } else if (widget.isAttended) {
          // Attended transfer
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            transferToAgentId: agent["agent_id"],
            agentMobile: agent["agent_mobile"],
          );
        } else {
          // Blind transfer
          await cubit.unattendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            transferToAgentId: agent["agent_id"],
            agentMobile: agent["agent_mobile"],
          );
        }
        break;

      case 'team_lead':
        final lead = selectedTeamLead;
        await cubit.unattendedTransfer(
          smeId: smeId,
          sessionId: sessionId,
          channelId: channelId,
          agentId: agentId,
          agentName: agentName,
          transferToAgentId: lead["agent_id"],
          agentMobile: lead["agent_mobile"],
        );
        break;

      case 'specific_queue_agent':
        final agent = selectedQueueAgent!;
        await cubit.unattendedTransfer(
          smeId: smeId,
          sessionId: sessionId,
          channelId: channelId,
          agentId: agentId,
          agentName: agentName,
          transferToAgentId: agent.agentId!,
          agentMobile: agent.agentMobile ?? "",
        );
        break;

      case 'specific_queue':
        await cubit.unattendedTransfer(
          smeId: smeId,
          sessionId: sessionId,
          channelId: channelId,
          agentId: agentId,
          agentName: agentName,
          queueId: selectedQueue["id"].toString(),
        );
        break;

      case 'same_queue':
        final agent = selectedSameQueueAgent!;
        // if (agent.agentLiveStatus?.toLowerCase() != "free") {
        //   _showError("Agent is not available");
        //   return;
        // }
        await cubit.unattendedTransfer(
          smeId: smeId,
          sessionId: sessionId,
          channelId: channelId,
          agentId: agentId,
          agentName: agentName,
          transferToAgentId: agent.agentId!,
          agentMobile: agent.agentMobile ?? "",
        );
        break;

      case 'outside_number':
        final cleanNumber = externalNumber!.trim();
        
        debugPrint(" [EXTERNAL TRANSFER] Number: $cleanNumber");
        
        if (widget.isConference) {
          //  Conference to external number
          debugPrint(" [EXTERNAL TRANSFER] Conference mode");
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            outsideNumber: cleanNumber, //  Pass outside number
          );
          await Future.delayed(const Duration(seconds: 1));
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            action: "conference",
          );
        } else if (widget.isAttended) {
          //  Attended transfer to external number
          debugPrint(" [EXTERNAL TRANSFER] Attended mode");
          await cubit.attendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            outsideNumber: cleanNumber, //  Pass outside number
          );
        } else {
          //  Blind transfer to external number
          debugPrint(" [EXTERNAL TRANSFER] Blind mode");
          await cubit.unattendedTransfer(
            smeId: smeId,
            sessionId: sessionId,
            channelId: channelId,
            agentId: agentId,
            agentName: agentName,
            outsideNumber: cleanNumber, //  Pass outside number
          );
        }
        break;
    }

    if (mounted) {
      Navigator.pop(context);
      _showSuccess("Transfer initiated successfully");
    }
  } catch (e) {
    debugPrint(" [TRANSFER ERROR] $e");
    _showError("Transfer failed: $e");
  }
}


  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}