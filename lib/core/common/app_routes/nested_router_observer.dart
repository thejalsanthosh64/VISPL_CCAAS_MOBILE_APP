part of 'app_routes_manager.dart';

class NestedRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static bool canPop = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if ([AppRouteNames.homeScreen].contains(route.settings.name)) {
      _onShortCutHomePage();
      canPop = false;
    } else {
      canPop = true;
      _onShortCutChange(routeName: route.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if ([AppRouteNames.homeScreen].contains(previousRoute?.settings.name)) {
      _onShortCutHomePage();
      canPop = false;
    } else {
      canPop = true;
    }
  }

  void _onShortCutHomePage() {
    AppKeys.nestedNavigatorKey.currentContext!.read<ShortcutsCubit>().onSelectedMenu(
          selectedShortcut: null,
        );
  }

  void _onShortCutChange({String? routeName}) {
    ShortcutsEnum? selectedShortcut;
    switch (routeName) {
      case AppRouteNames.assignedCalls:
        selectedShortcut = ShortcutsEnum.assignedCalls;
        break;
      case AppRouteNames.dialScreen:
        selectedShortcut = ShortcutsEnum.dial;
        break;
      case AppRouteNames.inSights:
        selectedShortcut = ShortcutsEnum.insights;
        break;
      case AppRouteNames.recentCalls:
        selectedShortcut = ShortcutsEnum.recentCalls;
        break;
      case AppRouteNames.followUp:
        selectedShortcut = ShortcutsEnum.followUp;
        break;
      case AppRouteNames.contactList:
        selectedShortcut = ShortcutsEnum.contacts;
        break;
      case AppRouteNames.leads:
        selectedShortcut = ShortcutsEnum.leads;
        break;
    }
    if (selectedShortcut != null) {
      AppKeys.nestedNavigatorKey.currentContext!.read<ShortcutsCubit>().onSelectedMenu(
            selectedShortcut: selectedShortcut,
          );
    }
  }
}
