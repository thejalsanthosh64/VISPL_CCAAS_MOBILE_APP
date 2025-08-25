import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/features/dial/cubit/dial_cubit.dart';
import 'package:kommuno/features/dial/data/model/dial_data_model.dart';

class NumWidget extends StatelessWidget {
  const NumWidget({
    super.key,
    required this.state,
  });

  final DialState state;

  SizedBox get _kSized15 =>
      const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  DialCubit _dialCubit(BuildContext context) => context.read<DialCubit>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _kSized15,
        _buildRow(dialDataModel: dialList123, context: context),
        _kSized15,
        _buildRow(dialDataModel: dialList456, context: context),
        _kSized15,
        _buildRow(dialDataModel: dialList789, context: context),
        _kSized15,
        _buildRow(dialDataModel: dialListSpecialAnd0, context: context),
        _kSized15,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: SizedBox.square(
                  dimension: 60,
                ),
              ),
              Expanded(
                child: Center(
                  child: SizedBox.square(
                    dimension: 60,
                    child: IconButton(
                      onPressed: () {
                        _dialCubit(context).makeNewCall();
                      },
                      icon: const Icon(
                        Icons.phone,
                        color: AppColors.white,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            state.number.length == 10
                                ? AppColors.green
                                : AppColors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox.square(
                  dimension: 60,
                ),
              ),
            ],
          ),
        ),
        _kSized15,
      ],
    );
  }

  Widget _buildRow(
      {required List<DialDataModel> dialDataModel,
      required BuildContext context}) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          dialDataModel.length,
          (index) => _buildSingleNo(
            dialData: dialDataModel[index],
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildSingleNo(
      {required DialDataModel dialData, required BuildContext context}) {
    return Expanded(
      child: _BuildSingleNo(
        dialData: dialData,
        onTapNo: (dialData) {
          _dialCubit(context).changeDialNo(dialData);
        },
      ),
    );
  }
}

class _BuildSingleNo extends StatelessWidget {
  const _BuildSingleNo({required this.dialData, required this.onTapNo});

  final DialDataModel dialData;

  final void Function(DialDataModel dialData) onTapNo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        onTapNo(dialData);
      },
      child: Center(
        child: SizedBox.square(
          dimension: 60,
          child: FittedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dialData.dialNo,
                  style: AppTextStyle.black25,
                ),
                Text(
                  dialData.dialText,
                  style: AppTextStyle.greyNormal.copyWith(fontSize: 10),
                ),
                const SizedBox(height: AppConstant.kSized5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
