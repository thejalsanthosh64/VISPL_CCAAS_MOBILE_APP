import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/generated/assets.dart';

enum ShortcutsEnum {
  assignedCalls,
  dial,
  insights,
  recentCalls,
  followUp,
  contacts,
  leads,
}

extension ShortcutsEnumExtension on ShortcutsEnum {
  String get text {
    switch (this) {
      case ShortcutsEnum.assignedCalls:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .assignedCalls;
      case ShortcutsEnum.dial:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.dial;
      case ShortcutsEnum.insights:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .insights;
      case ShortcutsEnum.followUp:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .followUp;
      case ShortcutsEnum.contacts:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .contacts;
      case ShortcutsEnum.leads:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.leads;
      case ShortcutsEnum.recentCalls:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .recentCalls;
    }
  }

  String get assetName {
    switch (this) {
      case ShortcutsEnum.assignedCalls:
        return Assets.iconsAssignedCall;
      case ShortcutsEnum.dial:
        return Assets.iconsDial;
      case ShortcutsEnum.insights:
        return Assets.iconsInsights;
      case ShortcutsEnum.followUp:
        return Assets.iconsFollowUp;
      case ShortcutsEnum.contacts:
        return Assets.iconsContacts;
      case ShortcutsEnum.leads:
        return Assets.iconsLeads;
      case ShortcutsEnum.recentCalls:
        return Assets.iconsRecentCalls;
    }
  }
}
