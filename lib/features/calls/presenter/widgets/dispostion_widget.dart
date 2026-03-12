import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';

// class DispositionBottomSheet extends StatefulWidget {
//   final CallStateCubit cubit;

//   const DispositionBottomSheet({
//     super.key,
//     required this.cubit,
//   });

//   @override
//   State<DispositionBottomSheet> createState() =>
//       _DispositionBottomSheetState();
// }

// class _DispositionBottomSheetState extends State<DispositionBottomSheet> {
//   final TextEditingController _remarkController = TextEditingController();

//   String? _selectedDisposition;
//   String? _selectedDispositionId;
//   int _rating = 0;

//   @override
//   void dispose() {
//     _remarkController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaign = CampaignManager.campaign;
//     final dispositions = campaign?.dispositions ?? [];
// final bool hasDispositions = dispositions.isNotEmpty;
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 20,
//         right: 20,
//         top: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Title
//           const Text(
//             "Disposition *",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),

//           /// Disposition dropdown
//           // DropdownButtonFormField<String>(
            
//           //   decoration: _outlinedDecoration(
//           //     hint: "Select Disposition",
//           //   ),
//           //   value: _selectedDisposition,
//           //   items: dispositions.map((d) {
//           //     return DropdownMenuItem(
//           //       value: d.combinedField,
//           //       child: Text(d.combinedField ?? ""),
//           //       onTap: () => _selectedDispositionId = d.id,
//           //     );
//           //   }).toList(),
//           //   onChanged: (val) {
//           //     setState(() => _selectedDisposition = val);
//           //   },
//           // ),

// //           DropdownButtonFormField2<String>(
// //   isExpanded: true,
// //   decoration: _outlinedDecoration(hint: "Select Disposition"),
// //   value: _selectedDisposition,
// //   items: dispositions.map((d) {
// //     return DropdownMenuItem<String>(
// //       value: d.combinedField,
// //       child: Text(d.combinedField ?? ""),
// //     );
// //   }).toList(),
// //   onChanged: (val) {
// //     setState(() {
// //       _selectedDisposition = val;
// //       _selectedDispositionId =
// //           dispositions.firstWhere((e) => e.combinedField == val).id;
// //     });
// //   },

// //   onMenuStateChange: (isOpen) {
// //     if (isOpen) {
// //       FocusScope.of(context).unfocus();
// //     }
// //   },
// // ),

// if (!hasDispositions) ...[
//   Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(18),
//       border: Border.all(color: Colors.grey.shade300),
//     ),
//     child: const Text(
//       "No disposition available for this campaign",
//       style: TextStyle(
//         color: Colors.grey,
//         fontSize: 14,
//       ),
//     ),
//   ),
// ] else ...[
//   DropdownButtonFormField2<String>(
//     isExpanded: true,
//     decoration: _outlinedDecoration(hint: "Select Disposition"),
//     value: _selectedDisposition,
//     items: dispositions.map((d) {
//       return DropdownMenuItem<String>(
//         value: d.combinedField,
//         child: Text(d.combinedField ?? ""),
//       );
//     }).toList(),
//     onChanged: (val) {
//       setState(() {
//         _selectedDisposition = val;
//         _selectedDispositionId =
//             dispositions.firstWhere((e) => e.combinedField == val).id;
//       });
//     },
//     onMenuStateChange: (isOpen) {
//       if (isOpen) FocusScope.of(context).unfocus();
//     },
//   ),
// ],

//           const SizedBox(height: 10),
// if (_selectedDisposition != null && _selectedLevels.isNotEmpty) ...[
//   const SizedBox(height: 12),

//   Column(
//     children: List.generate(_selectedLevels.length, (index) {
//       final levelText = _selectedLevels[index];

//       return Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: AppColors.appColor.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: AppColors.appColor.withOpacity(0.4),
//           ),
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 levelText,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),

//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   // 🔥 Remove this level and everything after it
//                   final updated = _selectedLevels.sublist(0, index);

//                   if (updated.isEmpty) {
//                     _selectedDisposition = null;
//                     _selectedDispositionId = null;
//                   } else {
//                     _selectedDisposition = updated.join(', ');
//                   }
//                 });
//               },
//               child: const Icon(
//                 Icons.close,
//                 size: 18,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       );
//     }),
//   ),
// ],

//           const SizedBox(height: 10),
//           /// Remarks
//           const Text(
//             "Remarks",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),

//           TextField(
//             controller: _remarkController,
//             maxLines: 4,
//             decoration: _outlinedDecoration(
//               hint: "Enter your remarks here...",
//             ),
//           ),

//           const SizedBox(height: 20),

//           /// Rating
//           const Text(
//             "Rate this call",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),

//           Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(5, (i) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() => _rating = i + 1);
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: Icon(
//                       i < _rating ? Icons.star : Icons.star_border,
//                       color: Colors.amber,
//                       size: 34,
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),

//           const SizedBox(height: 30),

//           /// Save button
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.appColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//               onPressed: _onSave,
//               child: const Text(
//                 "Save",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   InputDecoration _outlinedDecoration({required String hint}) {
//     return InputDecoration(
      
//       hintText: hint,
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide: BorderSide(
//           color: AppColors.appColor.withOpacity(0.6),
//           width: 1.5,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(18),
//         borderSide:  const BorderSide(
//           color: AppColors.appColor,
//           width: 2,
//         ),
//       ),
//     );
//   }

//   Future<void> _onSave() async {

//   final levels = _selectedDisposition!.split(',');

//   if (levels.length > 5) {
//     FToastManager().showToast(
//       message: "You can select disposition only up to 5 levels",
//     );
//     return;
//   }
// widget.cubit.state.isDispositionFilled ==false;

// print("isDispositionFilledinwrapupSheet${widget.cubit.state.isDispositionFilled}");
//     await widget.cubit.saveWrapUpInCall(
//       context: context,
//       dispositionName: _selectedDisposition ?? "",
//       dispositionId: _selectedDispositionId ?? "",
//       remarks: _remarkController.text.trim(),
//       rating: _rating,
//       wrapUpSeconds: widget.cubit.state.duration.inSeconds,
//     );


//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   List<String> get _selectedLevels {
//   if (_selectedDisposition == null || _selectedDisposition!.isEmpty) {
//     return [];
//   }
//   return _selectedDisposition!
//       .split(',')
//       .map((e) => e.trim())
//       .toList();
// }
// }


class DispositionBottomSheet extends StatefulWidget {
  final CallStateCubit cubit;

  const DispositionBottomSheet({
    super.key,
    required this.cubit,
  });

  @override
  State<DispositionBottomSheet> createState() =>
      _DispositionBottomSheetState();
}

class _DispositionBottomSheetState extends State<DispositionBottomSheet> {
  final TextEditingController _remarkController = TextEditingController();

late Map<int, List<DispositionItem>> _groupedDispositions;

final Map<int, String?> _selectedDispositionNames = {};
final Map<int, String?> _selectedDispositionIds = {};

  String? _selectedDisposition;
  String? _selectedDispositionId;
  int _rating = 0;
int _maxVisibleLevel = 1;
bool _isSaving = false;
  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignManager.campaign;
    final dispositions = campaign?.dispositions ?? [];
    final bool hasDispositions = dispositions.isNotEmpty;


_groupedDispositions = CampaignManager.groupDispositionsByLevel(dispositions);

// how many levels exist (max 5)
final levels = _groupedDispositions.keys.toList()..sort();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Disposition *",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
      
            ///  DISPOSITION CASE
            if (!hasDispositions)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  "No disposition available for this campaign",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            else
    //           DropdownButtonFormField2<String>(
    //             isExpanded: true,
    //             decoration: _outlinedDecoration(
    //               hint: "Select Disposition",
    //             ),
    //             hint: const Text("Select Disposition"),
    //             value: null, // ❗ always null → prevents replacement
    //             items: dispositions.map((d) {
    //               return DropdownMenuItem<String>(
    //                 value: d.combinedField,
    //                 child: Text(
    //                   d.combinedField ?? "",
    //                   textAlign: TextAlign.center,
    //                 ),
    //               );
    //             }).toList(),
    //             onChanged: (val) {
    //               if (val == null) return;
      
    //               setState(() {
    //                 final current = _selectedLevels;
      
           
    //                 // max 5
    //                 if (current.length >= 5) {
    //                   FToastManager().showToast(
    //                     message:
    //                         "You can select disposition only up to 5 levels",
    //                   );
    //                   return;
    //                 }
    //            // prevent duplicate
    //                 if (current.contains(val)){
    //                   FToastManager().showToast(
    //   message: "This disposition is already selected",
    // );
    // return;
    //                 }
      
    //                 current.add(val);
      
    //                 _selectedDisposition = current.join(', ');
    //                 _selectedDispositionId = dispositions
    //                     .firstWhere((e) => e.combinedField == val)
    //                     .id;
    //               });
    //             },
    //             onMenuStateChange: (isOpen) {
    //               if (isOpen) FocusScope.of(context).unfocus();
    //             },
    //           ),

  Column(
  children: levels.map((level) {
    final bool shouldShow = level <= _maxVisibleLevel;
    if (!shouldShow) return const SizedBox();

    final items = _groupedDispositions[level]!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,

        decoration: _outlinedDecoration(
          hint: "Select Level $level Disposition",

        
        ).copyWith(
          suffixIcon: _selectedDispositionIds[level] != null
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.red),
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

              if (level + 1 > _maxVisibleLevel) {
                _maxVisibleLevel = level + 1;
              }
            }
          });
        },
      ),
    );
  }).toList(),
),
      
            /// SELECTED LEVELS UI
            if (_selectedLevels.isNotEmpty) ...[
              const SizedBox(height: 14),
              Column(
                children: List.generate(_selectedLevels.length, (index) {
                  final level = _selectedLevels[index];
      
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                            level,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              final updated =
                                  _selectedLevels.sublist(0, index);
      
                              if (updated.isEmpty) {
                                _selectedDisposition = null;
                                _selectedDispositionId = null;
                              } else {
                                _selectedDisposition = updated.join(', ');
                              }
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
            ],
      
            const SizedBox(height: 12),
      
            /// REMARKS
            const Text(
              "Remarks",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remarkController,
              maxLines: 4,
              decoration: _outlinedDecoration(
                hint: "Enter your remarks here...",
              ),
            ),
      
            const SizedBox(height: 20),
      
            /// RATING
            const Text(
              "Rate this call",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 34,
                      ),
                    ),
                  );
                }),
              ),
            ),
      
            const SizedBox(height: 30),
      
            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                // onPressed: _onSave,

onPressed: _isSaving
    ? null
    : () async {
        setState(() => _isSaving = true);
        try {
          await _onSave();
        } finally {
          if (mounted) setState(() => _isSaving = false);
        }
      },
               child: _isSaving
    ? const AppLoadingIndicator()
    : const Text(
        "Save",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
              ),
            ),
          ],
        ),
      ),
    );
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

  /// SAVE
  Future<void> _onSave() async {

widget.cubit.state.isDispositionFilled ==false;
 final selectedEntries = _selectedDispositionNames.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  final dispositionName = selectedEntries.isNotEmpty
      ? selectedEntries.map((e) => e.value).join(", ")
      : "";

  final dispositionId = selectedEntries.isNotEmpty
      ? _selectedDispositionIds[selectedEntries.last.key]
      : "";


print("isDispositionFilledinwrapupSheet${widget.cubit.state.isDispositionFilled}");

    await widget.cubit.saveWrapUpInCall(
      context: context,
      dispositionName: dispositionName??'',
  dispositionId: dispositionId??"",
      remarks: _remarkController.text.trim(),
      rating: _rating,
      wrapUpSeconds: widget.cubit.state.duration.inSeconds,
    );

    if (mounted) Navigator.pop(context);
  }

  /// HELPERS
  List<String> get _selectedLevels {
    if (_selectedDisposition == null || _selectedDisposition!.isEmpty) {
      return [];
    }
    return _selectedDisposition!
        .split(',')
        .map((e) => e.trim())
        .toList();
  }
}