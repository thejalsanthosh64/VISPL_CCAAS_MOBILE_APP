import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';

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

  String? _selectedDisposition;
  String? _selectedDispositionId;
  int _rating = 0;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaign = CampaignManager.campaign;
    final dispositions = campaign?.dispositions ?? [];

    return Padding(
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
          /// Title
          const Text(
            "Disposition *",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          /// Disposition dropdown
          DropdownButtonFormField<String>(
            decoration: _outlinedDecoration(
              hint: "Select Disposition",
            ),
            value: _selectedDisposition,
            items: dispositions.map((d) {
              return DropdownMenuItem(
                value: d.combinedField,
                child: Text(d.combinedField ?? ""),
                onTap: () => _selectedDispositionId = d.id,
              );
            }).toList(),
            onChanged: (val) {
              setState(() => _selectedDisposition = val);
            },
          ),

          const SizedBox(height: 20),

          /// Remarks
          const Text(
            "Remarks",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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

          /// Rating
          const Text(
            "Rate this call",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _rating = i + 1);
                  },
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

          /// Save button
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
              onPressed: _onSave,
              child: const Text(
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
    );
  }

  InputDecoration _outlinedDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
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

  Future<void> _onSave() async {
    await widget.cubit.saveWrapUp(
      context: context,
      dispositionName: _selectedDisposition ?? "",
      dispositionId: _selectedDispositionId ?? "",
      remarks: _remarkController.text.trim(),
      rating: _rating,
      wrapUpSeconds: widget.cubit.state.duration.inSeconds,
    );


    if (mounted) {
      Navigator.pop(context);
    }
  }
}
