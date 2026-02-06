import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';


class InteractionHistorySheet extends StatelessWidget {
  const InteractionHistorySheet({super.key});

  String displayValue(dynamic value) {
    if (value == null) return "No Information Available";
    if (value is String && value.trim().isEmpty) {
      return "No Information Available";
    }
    return value.toString();
  }




String formatDate(dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return "No Information Available";
  }

  try {
    final dt = DateTime.parse(value.toString()).toLocal();
    return DateFormat("dd-MM-yyyy HH:mm").format(dt);
  } catch (e) {
    return value.toString();
  }
}

  Widget detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Text(
              displayValue(value),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetailSheet(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                const Text(
                  "Interaction Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),

                detailRow("Call Type", item["call_direction"]),
                detailRow("Agent", item["agent_name"]),
                detailRow("Campaign Name", item["campaign_name"]),
                detailRow("Campaign Type", item["campaign_type"]),
                detailRow("Queue Name", item["queue_name"]),
                detailRow("Call Result", item["final_status"]),
                detailRow("Start Time", formatDate(item["start_date_time"])),
detailRow("End Time", formatDate(item["end_date_time"])),

                detailRow("Duration", item["duration"]),
                detailRow("Transfer Status", item["transferStatus"]),
                detailRow("Conference Status", item["conferenceStatus"]),
                detailRow("Survey Status", item["surveyStatus"]),
                detailRow("Abandoned Reason", item["abandoned_reason"]),

                const SizedBox(height: 16),
                const Divider(),

                const Text("CRM Form",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(displayValue(item["crm_form_name"])),

                const SizedBox(height: 16),
                const Text("Evaluation Form",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(displayValue(item["evaluation_form_name"])),

                const SizedBox(height: 16),
                const Text("Disposition",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(displayValue(item["disposition_form_name"])),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: BlocBuilder<CallStateCubit, CallState>(
        builder: (context, state) {
          if (state.isLoadingInteractions) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.interactions.isEmpty) {
            return const Center(child: Text("No previous interactions"));
          }

          return Column(
            children: [
              const SizedBox(height: 12),
              Text(
                "Interaction History",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(),

          Expanded(
  child: Column(
    children: [
      //  Heading Row
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Campaign",
                style: TextStyle(
                  fontWeight: FontWeight.bold,

                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                "Start & End Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      const Divider(height: 1),

      Expanded(
        child: ListView.builder(
          itemCount: state.interactions.length,
          itemBuilder: (_, index) {
            final item = state.interactions[index];

            return InkWell(
              onTap: () => _openDetailSheet(context, item),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Campaign
                    Expanded(
                      flex: 3,
                      child: Text(
                        displayValue(item["campaign_name"]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Date
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${formatDate(item["start_date_time"])} → ${formatDate(item["end_date_time"])}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                    // Status
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          displayValue(item["final_status"]),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  ),
),

            ],
          );
        },
      ),
    );
  }
}
