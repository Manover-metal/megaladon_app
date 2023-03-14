import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_performers_main_state.dart';

class MyPerformersMainCubit extends Cubit<MyPerformersMainState> {
  MyPerformersMainCubit() : super(MyPerformersMainInitial());
}
