import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

/// A screen for handling post-call wrap-up activities.
/// 
/// This screen allows users to add disposition, remarks, and rating for a completed call.
class AfterCallWrapUpScreen extends StatefulWidget {
  const AfterCallWrapUpScreen({
    super.key,
    required this.callerName,
    required this.phoneNumber,
    required this.duration,
  });

  final String callerName;
  final String phoneNumber;
  final Duration duration;

  @override
  State<AfterCallWrapUpScreen> createState() => _AfterCallWrapUpScreenState();
}

class _AfterCallWrapUpScreenState extends State<AfterCallWrapUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDisposition;
  final _remarkController = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = _format(widget.duration);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Text("Preferred CLI", style: AppTextStyle.appColorNormal),
      ),

      /// Body
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kBodyHorizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// HEADER
                      Row(
                        children: [
                          const Icon(Icons.headset_mic, size: 30, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text("Wrap up", style: AppTextStyle.black18),
                          const SizedBox(width: 10),
                          Text(time, style: AppTextStyle.black18.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// CALLER INFO
                      Center(
                        child: Column(
                          children: [
                            Text(widget.callerName, style: AppTextStyle.black25),
                            Text(widget.phoneNumber, style: AppTextStyle.appColorNormal),
                            Text("Outgoing", style: AppTextStyle.greyNormal),
                            Text("click_to_call_campaign", style: AppTextStyle.greyNormal),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// DISPOSITION LABEL
                      Text("Disposition", style: AppTextStyle.black18),
                      const SizedBox(height: 8),

                      /// DISPOSITION DROPDOWN
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            items: ["Busy", "Wrong Number", "Follow-up"].map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList(),
                            decoration: const InputDecoration(border: InputBorder.none),
                            hint: const Text("Select Disposition"),
                            validator: (value) => value == null ? "Please select a disposition" : null,
                            onChanged: (value) {
                              setState(() => _selectedDisposition = value);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// REMARK LABEL
                      Text("Remark", style: AppTextStyle.black18),
                      const SizedBox(height: 8),

                      /// REMARK FIELD
                      TextFormField(
                        controller: _remarkController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter remarks",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter remarks';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      /// RATING LABEL
                      Text("Rate this call", style: AppTextStyle.black18),
                      const SizedBox(height: 8),

                      /// STAR RATING
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () => setState(() => _rating = index + 1),
                            child: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              size: 32,
                              color: Colors.amber,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              /// SAVE BUTTON STICKED TO BOTTOM
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _handleSave,
                  child: Text(
                    "Save",
                    style: AppTextStyle.black18.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats duration
  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }
}
