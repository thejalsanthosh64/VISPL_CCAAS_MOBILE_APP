import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/campaigns/data/model/response/campaign_data.dart';

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

final state = widget.cubit.state;
    final isIncoming = CallSession.callType?.toLowerCase() == "incoming";

    final dispositions = isIncoming 
        ? state.incomingDispositions 
        : (CampaignManager.campaign?.dispositions ?? []);
    // 👆 -------------------------------------------------------------

    final bool hasDispositions = dispositions.isNotEmpty;
    _groupedDispositions = CampaignManager.groupDispositionsByLevel(dispositions);
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

if (hasDispositions) ...[

            const Text(
              "Disposition *",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
      
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
int currentIndex = levels.indexOf(level);

              // if (level + 1 > _maxVisibleLevel) {
              //   _maxVisibleLevel = level + 1;
              // }

              if (currentIndex != -1 && currentIndex + 1 < levels.length) {
                int nextLevel = levels[currentIndex + 1]; // Grab the actual next level (e.g., 5)
                if (nextLevel > _maxVisibleLevel) {
                  _maxVisibleLevel = nextLevel;
                }
              } else {
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
      ],
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