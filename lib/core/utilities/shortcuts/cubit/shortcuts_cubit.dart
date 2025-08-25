import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/utilities/shortcuts/enum/shortcuts_enum.dart';

part 'shortcuts_state.dart';

class ShortcutsCubit extends Cubit<ShortcutsState> {
  ShortcutsCubit() : super(const ShortcutsState());

  void onOpenMenu() {
    emit(state.copyWith(isOpened: true));
  }

  void onCloseMenu() {
    emit(state.copyWith(isOpened: false));
  }

  void onSelectedMenu({ShortcutsEnum? selectedShortcut}) {
    if (selectedShortcut != state.selectedShortcut) {
      emit(state.copyWith(
        isOpened: false,
        selectedShortcut: () => selectedShortcut,
      ));
    }
  }
}
