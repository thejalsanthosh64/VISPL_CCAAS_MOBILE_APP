import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';


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

  String? _selectedDisposition;
  String? _selectedDispositionId;
  int _rating = 0;

  late Timer _timer;
  Duration displayTimer = Duration.zero;

  @override
  void initState() {
    super.initState();
    displayTimer = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        displayTimer += const Duration(seconds: 1);
      });
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

  @override
  Widget build(BuildContext context) {
    final timeText = _format(displayTimer);
    final campaign = CampaignManager.campaign;
    final dispositions = campaign?.dispositions ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        title: Text(
          "Wrap-up Call",
          style: AppTextStyle.whiteNormal.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Column(
        children: [
          // Header Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: const BorderRadius.only(
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
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Disposition
                    _sectionLabel("Disposition *"),
                    const SizedBox(height: 8),
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
                        hint: const Text("Select Disposition"),
                        value: _selectedDisposition,
                        items: dispositions.map((d) {
                          return DropdownMenuItem(
                            value: d.combinedField,
                            child: Text(d.combinedField ?? ""),
                            onTap: () {
                              _selectedDispositionId = d.id;
                            },
                          );
                        }).toList(),
                        validator: (value) =>
                            value == null ? "Please select disposition" : null,
                        onChanged: (value) {
                          setState(() => _selectedDisposition = value);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Remark
                    _sectionLabel("Remarks *"),
                    const SizedBox(height: 8),
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
                      child: TextFormField(
                        controller: _remarkController,
                        maxLines: 4,
                        validator: (v) =>
                            v!.trim().isEmpty ? "Enter remark" : null,
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

                    const SizedBox(height: 20),

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
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  await context.read<CallStateCubit>().saveWrapUp(
                    context: context,
                        dispositionName: _selectedDisposition ?? "",
                        dispositionId: _selectedDispositionId ?? "",
                        remarks: _remarkController.text.trim(),
                        rating: _rating,
                        
                      );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
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
}