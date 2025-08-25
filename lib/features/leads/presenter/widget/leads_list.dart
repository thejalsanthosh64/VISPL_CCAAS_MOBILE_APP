import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_icon_button.dart';
import 'package:kommuno/core/common/widget/app_outlined_avatar.dart';
import 'package:kommuno/core/common/widget/app_slidable_action.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/make_call_button.dart';
import 'package:kommuno/core/common/widget/slidable_icon_button.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/whatsapp_launcher_button.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/extension_method.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/features/leads/cubit/lead_cubit/leads_cubit.dart';
import 'package:kommuno/features/leads/data/model/request/edit_lead_request_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_source_city_product_status_data.dart';
import 'package:kommuno/features/leads/data/model/response/leads_unique_calls_model.dart';
import 'package:kommuno/features/leads/presenter/page/add_lead_note.dart';
import 'package:kommuno/features/leads/presenter/page/edit_lead.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'leads_list_tile.dart';

class LeadsList extends StatefulWidget {
  const LeadsList({super.key});

  @override
  State<LeadsList> createState() => _LeadsListState();
}

class _LeadsListState extends State<LeadsList> with TickerProviderStateMixin {
  final Map<int, SlidableController> _slidableControllers = {};

  late int _smeId;

  @override
  void initState() {
    super.initState();
    _smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    _leadsCubit.paginationScrollController.init(loadAction: () {
      if (_leadsCubit.state is LeadsSuccessState) {
        return _leadsCubit.getLeadsUniqueCalls(
          smeId: _smeId,
          isLoading: false,
        );
      }
      return Future.value(_leadsCubit.paginationScrollController.hasMoreData);
    });

    _leadsCubit.paginationSearchScrollController.init(loadAction: () {
      if (_leadsCubit.state is LeadsFilterState) {
        return _leadsCubit.getFilterLeadsUniqueCalls(
            smeId: _smeId,
            leadsFilterRequestModel: (_leadsCubit.state as LeadsFilterState)
                .leadsFilterRequestModel);
      }
      return Future.value(
          _leadsCubit.paginationSearchScrollController.hasMoreData);
    });
  }

  @override
  void dispose() {
    _slidableControllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  LeadsCubit get _leadsCubit => context.read<LeadsCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadsCubit, LeadsState>(
      builder: (__, state) {
        if (state is LeadsSuccessState || state is LeadsFilterState) {
          bool isExpanded = false;
          List<LeadsUniqueCallsModel> leadsUniqueCallsModel = [];
          LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;
          if (state is LeadsSuccessState) {
            isExpanded = state.isExpanded;
            leadsUniqueCallsModel = state.leadsUniqueCallsModel;
            leadsSourceCityProductStatusData =
                state.leadsSourceCityProductStatusData;
          } else if (state is LeadsFilterState) {
            isExpanded = state.isExpanded;
            leadsUniqueCallsModel = state.leadsUniqueCallsModel;
            leadsSourceCityProductStatusData =
                state.leadsSourceCityProductStatusData;
          }

          if (leadsUniqueCallsModel.isEmpty) {
            return EmptyErrorWidget(
              showButton: state is LeadsSuccessState,
              text: AppLocalizations.of(context)!.noRecordFound,
              onTap: () {
                if (state is LeadsFilterState) {
                  _leadsCubit.getFilterLeadsUniqueCalls(
                    smeId: _smeId,
                    initialRecordValue: 1,
                    leadsFilterRequestModel: state.leadsFilterRequestModel,
                  );
                } else {
                  _leadsCubit.getLeadsUniqueCalls(
                      smeId: _smeId, initialRecordValue: 1, isLoading: false);
                }
              },
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                if (state is LeadsFilterState) {
                  _leadsCubit.getFilterLeadsUniqueCalls(
                    smeId: _smeId,
                    initialRecordValue: 1,
                    leadsFilterRequestModel: state.leadsFilterRequestModel,
                  );
                } else {
                  _leadsCubit.getLeadsUniqueCalls(
                      smeId: _smeId, initialRecordValue: 1, isLoading: false);
                }
              },
              child: SlidableAutoCloseBehavior(
                closeWhenTapped: false,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: leadsUniqueCallsModel.length,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: state is LeadsFilterState
                      ? _leadsCubit
                          .paginationSearchScrollController.scrollController
                      : _leadsCubit.paginationScrollController.scrollController,
                  itemBuilder: (__, index) {
                    final leadsUniqueCall = leadsUniqueCallsModel[index];
                    if (_slidableControllers[leadsUniqueCall.id] == null) {
                      _slidableControllers[leadsUniqueCall.id] =
                          SlidableController(this);
                    }
                    return LeadsListTile(
                      index: index,
                      slidableController:
                          _slidableControllers[leadsUniqueCall.id]!,
                      leadsUniqueCall: leadsUniqueCall,
                      isExpanded: isExpanded,
                      leadsSourceCityProductStatusData:
                          leadsSourceCityProductStatusData,
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
