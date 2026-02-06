import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';

class CrmFormSheet extends StatelessWidget {
  const CrmFormSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallStateCubit, CallState>(
      builder: (context, state) {
        final form = state.crmFormJson;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Column(
            children: [
              // ───────── Header ─────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.crmFormName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // ───────── Form ─────────
              Expanded(
                child: form.isEmpty
                    ? const Center(child: Text("No CRM fields"))
                    : ListView.builder(
                        itemCount: form.length,
                        itemBuilder: (_, index) {
                          return _buildField(
                            context,
                            field: form[index],
                            index: index,
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              // ───────── Footer Buttons ─────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.appColor),
                      
                      onPressed: state.isSavingCrm
                          ? null
                          : () => _saveCrm(context),
                      child: state.isSavingCrm
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Save",style:TextStyle(color: AppColors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildField(
  BuildContext context, {
  required Map<String, dynamic> field,
  required int index,
}) {
  final type = field["type"];
  final title = field["title"];
  final mandatory = field["mandatory"] == true;

  Widget input;

  switch (type) {
    case "textfield":
      input = TextFormField(
        initialValue: field["value"] ?? "",
        decoration: InputDecoration(
          labelText: mandatory ? "$title *" : title,
        ),
        onChanged: (v) => field["value"] = v,
      );
      break;

    case "textarea":
      input = TextFormField(
        initialValue: field["value"] ?? "",
        maxLines: 4,
        decoration: InputDecoration(
          labelText: mandatory ? "$title *" : title,
        ),
        onChanged: (v) => field["value"] = v,
      );
      break;

    case "dropdown":
      input = DropdownButtonFormField<String>(
        value: field["value"],
        items: (field["options"] as List)
            .map<DropdownMenuItem<String>>(
              (o) => DropdownMenuItem(
                value: o["title"],
                child: Text(o["title"]),
              ),
            )
            .toList(),
        onChanged: (v) => field["value"] = v,
        decoration: InputDecoration(
          labelText: mandatory ? "$title *" : title,
        ),
      );
      break;

    case "radio":
      input = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          ...List<Widget>.from(
            (field["options"] as List).map(
              (o) => RadioListTile<String>(
                title: Text(o["title"]),
                value: o["title"],
                groupValue: field["value"],
                onChanged: (v) => field["value"] = v,
              ),
            ),
          ),
        ],
      );
      break;

    case "date":
  input = InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.tryParse(field["value"] ?? "") ?? DateTime.now(),
      );
      if (picked != null) {
        field["value"] = picked.toIso8601String().split("T").first;
        (context as Element).markNeedsBuild();
      }
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: mandatory ? "$title *" : title,
      ),
      child: Text(
        field["value"]?.toString().isNotEmpty == true
            ? field["value"]
            : "Select date",
        style: TextStyle(
          color: field["value"] != null
              ? Colors.black
              : Colors.grey,
        ),
      ),
    ),
  );
  break;

    default:
      return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: input,
  );
}

void _saveCrm(BuildContext context) async {
  final cubit = context.read<CallStateCubit>();
  final form = cubit.state.crmFormJson;

  final hasError = form.any((f) =>
      f["mandatory"] == true &&
      (f["value"] == null || f["value"].toString().isEmpty));

  if (hasError) {
    FToastManager().showToast(
      message: "Please fill all mandatory fields",
    );
    return;
  }

  final success = await cubit.saveCrmForm(form);

  if (success && context.mounted) {
    Navigator.pop(context); 
  }
}

