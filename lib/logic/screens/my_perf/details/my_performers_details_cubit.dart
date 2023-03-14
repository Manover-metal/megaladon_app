import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_performers_details_state.dart';

class MyPerformersDetailsCubit extends Cubit<MyPerformersDetailsState> {
  MyPerformersDetailsCubit() : super(MyPerformersDetailsInitial());
}
