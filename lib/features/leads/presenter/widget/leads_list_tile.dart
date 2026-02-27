part of 'leads_list.dart';

class LeadsListTile extends StatelessWidget {
  const LeadsListTile({
    super.key,
    required this.index,
    required this.slidableController,
    required this.leadsUniqueCall,
    required this.isExpanded,
    this.leadsSourceCityProductStatusData,
  });

  final int index;
  final SlidableController slidableController;
  final LeadsUniqueCallsModel leadsUniqueCall;
  final bool isExpanded;
  final LeadsSourceCityProductStatusData? leadsSourceCityProductStatusData;

  SizedBox get _kSized20 =>
      const SizedBox(height: AppConstant.kSized20, width: AppConstant.kSized20);

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  LeadsCubit _leadsCubit(BuildContext context) => context.read<LeadsCubit>();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      key: ValueKey<String>(
          "LeadsList_LeadsListTile_Slidable_$index${leadsUniqueCall.id}"),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          AppSlidableAction(
            onPressed: (__) {
              _addLeadNote(context: context);
            },
            backgroundColor: AppColors.orange,
            text: AppLocalizations.of(context)!.note,
            iconName: Assets.iconsEdit,
          ),
          AppSlidableAction(
            onPressed: (__) {
              Navigator.of(context)
                  .pushNamed(AppRouteNames.addScheduleCall, arguments: {
                "number": leadsUniqueCall.customerNumber,
                "customerName": leadsUniqueCall.customerName
              });
            },
            backgroundColor: AppColors.green,
            text: AppLocalizations.of(context)!.schedule,
            iconName: Assets.iconsSchedule,
          ),
          AppSlidableAction(
            onPressed: (__) async {
              final userDetailsModel =
                  context.read<UserDetailsCubit>().userDetailsModel;
              final updatedContactDetails = await Navigator.of(context)
                  .pushNamed(AppRouteNames.addUpdateContact, arguments: {
                "updateContactDetails": AddUpdateContactsRequestModel(
                  customerNumber: leadsUniqueCall.customerNumber,
                  customerName: leadsUniqueCall.customerName ?? '',
                  addressBookId: leadsUniqueCall.addressBookId ??
                      AddUpdateContactsRequestModel.defaultAddressBookId,
                  agentNumber: userDetailsModel.agentMobile,
                  companyName: leadsUniqueCall.companyName ?? '',
                  createdBy: userDetailsModel.agentId,
                  emailId: leadsUniqueCall.emailId ?? '',
                  insertDateTime: leadsUniqueCall.insertDateTime,
                  updatedDateTime: DateTime.now(),
                  smeId: "${userDetailsModel.smeId}",
                )
              });
              if (context.mounted &&
                  updatedContactDetails is AddUpdateContactsRequestModel) {
                _reloadData(context: context);
              }
            },
            backgroundColor: AppColors.appColor,
            text: AppLocalizations.of(context)!.update,
            iconName: Assets.iconsSettings,
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(AppRouteNames.leadsDetails);
        },
        child: ColoredBox(
          color: index.isOdd ? AppColors.white : AppColors.whiteGrey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 15, horizontal: AppConstant.kBodyHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppOutlinedAvatar(
                            child: (leadsUniqueCall.customerName ?? '')
                                    .trim()
                                    .isEmpty
                                ? const Icon(Icons.person)
                                : Padding(
                                    padding: EdgeInsets.only(
                                        bottom: AppConstant.kCenterPadding),
                                    child: Text(
                                      (leadsUniqueCall.customerName ?? '')
                                          .capitalizeFirstLetterOfTwoWords,
                                      style: AppTextStyle.appColor16,
                                    ),
                                  ),
                          ),
                          _kSized10,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  child: Text(
                                    leadsUniqueCall.customerName ??
                                        addByIndiaCountryCodeWithoutPlus(
                                            number:
                                                leadsUniqueCall.customerNumber),
                                    style: AppTextStyle.black16,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    DateUtility.getDisplayDateTimeWithMonthName(
                                        date: leadsUniqueCall.insertDateTime),
                                    style: AppTextStyle.grey13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    _kSized5,
                    WhatsappLauncherButton(
                        number: leadsUniqueCall.customerNumber),
                    _kSized5,
                    MakeCallButton(
                      number: leadsUniqueCall.customerNumber,
                    ),
                    SlidableIconButton(
                      slidableController: slidableController,
                      padding: EdgeInsets.only(
                        top: AppIconButton.iconPadding,
                        bottom: AppIconButton.iconPadding,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  child: isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _kSized20,
                            Row(
                              children: [
                                Expanded(
                                  child: _LeadsFields(
                                      asset: Assets.iconsStatus,
                                      data: leadsUniqueCall.leadStatusName,
                                      hintText:
                                          AppLocalizations.of(context)!.status),
                                ),
                                _kSized20,
                                Expanded(
                                  child: _LeadsFields(
                                      data: leadsUniqueCall.leadSource,
                                      asset: Assets.iconsSource,
                                      hintText:
                                          AppLocalizations.of(context)!.source),
                                ),
                              ],
                            ),
                            _kSized20,
                            Row(
                              children: [
                                Expanded(
                                  child: _LeadsFields(
                                      asset: Assets.iconsCity,
                                      data: leadsUniqueCall.cityName,
                                      hintText:
                                          AppLocalizations.of(context)!.city),
                                ),
                                _kSized20,
                                Expanded(
                                  child: _LeadsFields(
                                      data: leadsUniqueCall.productName,
                                      asset: Assets.iconsProduct,
                                      hintText: AppLocalizations.of(context)!
                                          .product),
                                ),
                              ],
                            ),
                            _kSized20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _addLeadNote(context: context);
                                  },
                                  icon:  AppSvgPicture(
                                    assetName: Assets.iconsEdit,
                                    color: AppColors.appColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final editLeadRequestData =
                                        await appBottomSheet(
                                      context: context,
                                      child: (ctx) => EditLeadScreen(
                                        leadsSourceCityProductStatusData:
                                            leadsSourceCityProductStatusData,
                                        leadsUniqueCall: leadsUniqueCall,
                                      ),
                                      height: 450,
                                    );
                                    if (context.mounted &&
                                        editLeadRequestData
                                            is EditLeadRequestData) {
                                      _reloadData(context: context);
                                    }
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            )
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addLeadNote({required BuildContext context}) async {
    await appBottomSheet(
      context: context,
      child: (ctx) => AddLeadNote(
        customerName: leadsUniqueCall.customerName,
        customerNumber: leadsUniqueCall.customerNumber,
      ),
      height: 315,
    );
  }

  void _reloadData({required BuildContext context}) {
    final smeId = context.read<UserDetailsCubit>().userDetailsModel.smeId;
    if (_leadsCubit(context).state is LeadsFilterState) {
      _leadsCubit(context).getFilterLeadsUniqueCalls(
        smeId: smeId,
        leadsFilterRequestModel:
            (_leadsCubit(context).state as LeadsFilterState)
                .leadsFilterRequestModel,
        initialRecordValue: 1,
      );
    } else {
      _leadsCubit(context).getLeadsUniqueCalls(
        smeId: smeId,
        initialRecordValue: 1,
        isLoading: false,
      );
    }
  }
}

class _LeadsFields extends StatelessWidget {
  const _LeadsFields({required this.asset, required this.hintText, this.data});

  final String asset;
  final String hintText;
  final String? data;

  SizedBox get _kSized10 =>
      const SizedBox(height: AppConstant.kSized10, width: AppConstant.kSized10);

  SizedBox get _kSized5 =>
      const SizedBox(height: AppConstant.kSized5, width: AppConstant.kSized5);

  @override
  Widget build(BuildContext context) {
    final isHintText = (data ?? '').isEmpty;
    return Container(
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.appColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _kSized10,
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: AppSvgPicture(
              assetName: asset,
              height: 20,
              width: 18,
              color: AppColors.grey.withValues(alpha: 0.7),
            ),
          ),
          _kSized5,
          Padding(
            padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
            child: Text(
              isHintText ? hintText : data!,
              style: isHintText ? AppTextStyle.grey13 : null,
            ),
          ),
        ],
      ),
    );
  }
}
