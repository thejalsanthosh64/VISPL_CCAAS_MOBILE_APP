part of 'permission_handler_cubit.dart';

sealed class PermissionHandlerState extends Equatable {
  const PermissionHandlerState();
}

final class PermissionHandlerInitial extends PermissionHandlerState {
  const PermissionHandlerInitial();

  @override
  List<Object> get props => [];
}

final class DeniedDisplayOverApps extends PermissionHandlerState {
  const DeniedDisplayOverApps();

  @override
  List<Object> get props => [];
}

final class DeniedRequiredPermissionsState extends PermissionHandlerState {
  const DeniedRequiredPermissionsState({required this.permission});

  final Permission permission;

  @override
  List<Object> get props => [permission];
}

final class AllPermissionsGranted extends PermissionHandlerState {
  const AllPermissionsGranted();

  @override
  List<Object> get props => [];
}
