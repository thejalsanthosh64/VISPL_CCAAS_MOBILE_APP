import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';

import 'cubit/user_details_cubit.dart';

/// Use this widget only after login success.
class UserDetailsWidget extends StatelessWidget {
  const UserDetailsWidget({
    super.key,
    required this.builder,
  });

  final Widget Function(UserDetailsModel userDetails) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsCubit, UserDetailsState>(
      builder: (__, state) {
        if (state is UserDetailsInitialState) {
          context.read<UserDetailsCubit>().loadUserDetails();
          return const AppLoadingIndicator();
        } else if (state is UserDetailsErrorState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.somethingWentWrong,
            onTap: () {
              context.read<UserDetailsCubit>().loadUserDetails();
            },
          );
        } else if (state is UserDetailsNotFoundState) {
          return EmptyErrorWidget(
            text: AppLocalizations.of(context)!.dataNotFound,
            onTap: () {
              context.read<UserDetailsCubit>().loadUserDetails();
            },
          );
        } else if (state is UserDetailsSuccessState) {
          return builder(state.userDetailsModel);
        }
        return const SizedBox();
      },
    );
  }
}
