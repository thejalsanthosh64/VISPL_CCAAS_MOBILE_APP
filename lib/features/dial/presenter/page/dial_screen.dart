import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/add_new_contact_button.dart';
import 'package:kommuno/core/common/widget/app_icon_button.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/utilities/shortcuts/widget/app_shortcut_button.dart';
import 'package:kommuno/features/break/presenter/view/break_in_button.dart';
import 'package:kommuno/core/common/widget/mobile_textfield.dart';
import 'package:kommuno/core/common/widget/my_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/features/dial/cubit/dial_cubit.dart';
import 'package:kommuno/features/dial/presenter/widget/num_widget.dart';
import 'package:kommuno/generated/assets.dart';

class DialScreen extends StatelessWidget {
  const DialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DialCubit(),
      child: const _DialScreenState(),
    );
  }
}

class _DialScreenState extends StatelessWidget {
  const _DialScreenState();

  SizedBox get _kSized15 => const SizedBox(height: AppConstant.kSized15, width: AppConstant.kSized15);

  SizedBox get _kSized10 => const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  DialCubit _dialCubit(BuildContext context) => context.read<DialCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppShortcutButton(),
      appBar: MyAppBar(
        title: AppLocalizations.of(context)!.dial,
        actions: [BreakInButton.outline()],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstant.kBodyHorizontalPadding),
      child: FittedBox(
        fit: BoxFit.cover,
        child: BlocBuilder<DialCubit, DialState>(
          builder: (context, state) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _kSized10,
                        Center(
                          child: AddNewContactButton(
                            onAddedNewContact: (newContactDetails) {},
                          ),
                        ),
                        _kSized10,
                        MobileTextField(
                          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                            return const SizedBox();
                          },
                          autofocus: true,
                          keyboardType: TextInputType.none,
                          controller: _dialCubit(context).dialController,
                          textInputAction: TextInputAction.done,
                          suffixIconConstraints: const BoxConstraints(
                            maxWidth: 90,
                          ),
                          suffixIcon: AppIconButton(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRouteNames.contactList);
                            },
                            padding: const EdgeInsets.only(right: 10),
                            icon: const AppSvgPicture(
                              assetName: Assets.iconsContacts,
                              color: AppColors.appColor,
                            ),
                          ),
                        ),
                        _kSized15,
                        /*   AppButton(
                          text: AppLocalizations.of(context)!.call,
                          suffixWidget: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: AppConstant.kCenterPadding),
                              child: const Icon(
                                Icons.phone,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppConstant.kSized5)
                          ],
                          onTap: state.number.length == 10 ? () {} : null,
                        )*/
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppIconButton(
                            onLongPress: () {
                              _dialCubit(context).clearDialField();
                            },
                            onTap: () {
                              _dialCubit(context).deleteDialNo();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                        const Divider(height: 0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: NumWidget(state: state),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
