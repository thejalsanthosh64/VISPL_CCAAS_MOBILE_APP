import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/features/assigned_calls/cubit/assigned_calls_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'assigned_calls_list_tile.dart';

class AssignedCallsList extends StatefulWidget {
  const AssignedCallsList({super.key});

  @override
  State<AssignedCallsList> createState() => _AssignedCallsListState();
}

class _AssignedCallsListState extends State<AssignedCallsList>
    with TickerProviderStateMixin {
  final Map<int, SlidableController> _slidableControllers = {};
  late final int _smeId;

  AssignedCallsCubit get _assignedCallsCubit =>
      context.read<AssignedCallsCubit>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    _assignedCallsCubit.paginationScrollController.init(loadAction: () {
      if (_assignedCallsCubit.state is AssignedCallsSuccessState &&
          (_assignedCallsCubit.state as AssignedCallsSuccessState)
                  .searchedAssignedCallsDetails ==
              null) {
        return _assignedCallsCubit.getAssignedCalls(
          isLoading: false,
          smeId: _smeId,
        );
      }
      return Future.value(
          _assignedCallsCubit.paginationScrollController.hasMoreData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignedCallsCubit, AssignedCallsState>(
      builder: (__, state) {
        if (state is AssignedCallsSuccessState) {
          final assignedCallsDetails =
              state.searchedAssignedCallsDetails == null
                  ? state.assignedCallsDetails
                  : state.searchedAssignedCallsDetails!;
          if (assignedCallsDetails.isEmpty) {
            return EmptyErrorWidget(
              showButton: state.searchedAssignedCallsDetails == null,
              text: AppLocalizations.of(context)!.noRecordFound,
              onTap: () {
                _assignedCallsCubit.getAssignedCalls(smeId: _smeId);
              },
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _assignedCallsCubit.getAssignedCalls(
                    isLoading: false, initialRecordValue: 1, smeId: _smeId);
              },
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: false,
                child: ListView.builder(
                  controller: _assignedCallsCubit
                      .paginationScrollController.scrollController,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: assignedCallsDetails.length,
                  itemBuilder: (__, index) {
                    if (_slidableControllers[assignedCallsDetails[index].id] ==
                        null) {
                      _slidableControllers[assignedCallsDetails[index].id] =
                          SlidableController(this);
                    }
                    return AssignedCallsListTile(
                      assignedCallsDetails: assignedCallsDetails[index],
                      index: index,
                      slidableController:
                          _slidableControllers[assignedCallsDetails[index].id]!,
                    );
                  },
                ),
              ),
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
