import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lead_details_state.dart';

class LeadDetailsCubit extends Cubit<LeadDetailsState> {
  LeadDetailsCubit() : super(const LeadDetailsInitialState());
}
