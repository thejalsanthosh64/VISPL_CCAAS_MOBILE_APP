import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/features/recent_calls/cubit/recent_calls_cubit/recent_calls_cubit.dart';
import 'package:kommuno/features/recent_calls/presenter/widget/recent_calls_list_tile.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class RecentCallsList extends StatefulWidget {
  const RecentCallsList({super.key});

  @override
  State<RecentCallsList> createState() => _RecentCallsListState();
}

class _RecentCallsListState extends State<RecentCallsList>
    with TickerProviderStateMixin {
  final Map<int, SlidableController> _slidableControllers = {};

  late final int _smeId;
  late final agentNumber;

  RecentCallsCubit get _recentCallsCubit => context.read<RecentCallsCubit>();

  @override
  void initState() {
    super.initState();
    _smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
     agentNumber = context.read<UserDetailsCubit>().userDetailsModel.agentMobile;

    _recentCallsCubit.paginationScrollController.init(loadAction: () {
      if (_recentCallsCubit.state is RecentCallsSuccessState &&
          (_recentCallsCubit.state as RecentCallsSuccessState)
                  .searchedRecentCallsData ==
              null) {
        return _recentCallsCubit.getRecentCalls(
          isLoading: false,
          smeId: _smeId,
          agentNumber: agentNumber
          // recentCallsRequestModel:
          //     (_recentCallsCubit.state as RecentCallsSuccessState)
          //         .recentCallsRequestModel,
        );
      }
      return Future.value(
          _recentCallsCubit.paginationScrollController.hasMoreData);
    });
  }

  @override
  void dispose() {
    _slidableControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentCallsCubit, RecentCallsState>(
      builder: (context, state) {
        if (state is RecentCallsSuccessState) {
          final recentCallsData = state.searchedRecentCallsData == null
              ? state.recentCallsData
              : state.searchedRecentCallsData!;
          if (recentCallsData.isEmpty) {
            return EmptyErrorWidget(
              showButton: state.searchedRecentCallsData == null,
              text: AppLocalizations.of(context)!.noRecordFound,
              onTap: () {
                _recentCallsCubit.getRecentCalls(
                    smeId: _smeId,
                    isLoading: false,
                    // recentCallsRequestModel: state.recentCallsRequestModel,
                    agentNumber: agentNumber,
                    initialRecordValue: 1);
              },
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _recentCallsCubit.getRecentCalls(
                    smeId: _smeId,
                    isLoading: false,
                    // recentCallsRequestModel: state.recentCallsRequestModel,
                    agentNumber: agentNumber,
                    initialRecordValue: 1);
              },
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: false,
                child: ListView.builder(
                  controller: _recentCallsCubit
                      .paginationScrollController.scrollController,
                  padding: EdgeInsets.zero,
                  itemCount: recentCallsData.length,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (__, index) {
                    if (_slidableControllers[index] == null) {
                      _slidableControllers[index] = SlidableController(this);
                    }
                    return RecentCallsListTile(
                      index: index,
                      slidableController: _slidableControllers[index]!,
                      recentCallsData: recentCallsData[index],
                      recentCallsRequestModel: state.recentCallsRequestModel,
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
