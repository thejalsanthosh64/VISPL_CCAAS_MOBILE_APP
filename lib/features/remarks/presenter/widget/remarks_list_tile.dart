import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/features/remarks/data/model/response/remarks_data_model.dart';

// class RemarksListTile extends StatelessWidget {
//   const RemarksListTile(
//       {super.key, required this.dateTime, required this.remarks});

//   final DateTime dateTime;
//   final String remarks;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 18),
//       decoration: BoxDecoration(
//           color: AppColors.appColor, borderRadius: BorderRadius.circular(50)),
//       child: Stack(
//         alignment: Alignment.centerLeft,
//         children: [
//           Positioned(
//             top: 0,
//             right: 0,
//             child: Text(
//               DateUtility.getDisplayDateTimeWithMonthName(date: dateTime),
//               style: AppTextStyle.white11,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Text(
//               remarks,
//               style: AppTextStyle.white18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class RemarksListTile extends StatelessWidget {
  final RemarksDataModel remark;
  final int currentUserId;
  final VoidCallback onEdit;

  const RemarksListTile({
    super.key,
    required this.remark,
    required this.currentUserId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final displayDate = remark.updatedAt ?? remark.createdAt;
    final isEdited = remark.editCount > 0;
    final canEdit = remark.createdBy.id == currentUserId;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.appColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${remark.createdBy.name} (${getDisplayRole(remark.createdBy.role)})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.appColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canEdit)
                InkWell(
                  onTap: onEdit,
                  child: const Icon(Icons.edit, size: 16, color: AppColors.appColor),
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            remark.message,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${DateUtility.getDisplayDateTimeWithMonthName(date: displayDate.toLocal())}${isEdited ? ' (Edited)' : ''}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

String getDisplayRole(String role) {
  switch (role.toLowerCase()) {
    case 'client': return 'Admin';
    case 'agent': return 'Agent';
    case 'teamlead': return 'Team Lead';
    case 'supervisor': return 'Supervisor';
    case 'voicelogger': return 'Voice Logger';
    case 'campaignsupervisor': return 'Campaign Supervisor';
    default: return role.isNotEmpty ? role : 'Unknown';
  }
}