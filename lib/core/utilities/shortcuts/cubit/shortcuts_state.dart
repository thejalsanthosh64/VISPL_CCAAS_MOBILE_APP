part of 'shortcuts_cubit.dart';

final class ShortcutsState extends Equatable {
  final ShortcutsEnum? selectedShortcut;

  final bool isOpened;

  const ShortcutsState({this.selectedShortcut, this.isOpened = false});

  ShortcutsState copyWith(
      {ShortcutsEnum? Function()? selectedShortcut, bool? isOpened}) {
    return ShortcutsState(
      isOpened: isOpened ?? this.isOpened,
      selectedShortcut:
          selectedShortcut != null ? selectedShortcut() : this.selectedShortcut,
    );
  }

  @override
  List<Object?> get props => [isOpened, selectedShortcut];
}
