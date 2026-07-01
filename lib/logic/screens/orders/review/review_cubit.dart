import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:megaladon/data/models/error_model.dart';
import 'package:megaladon/data/repositories/review_repository.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit(this._repository) : super(ReviewInitial());

  final ReviewRepository _repository;

  Future<void> submit(
    int orderId,
    int rate,
    String comment,
    List<PlatformFile> images,
  ) async {
    if (state is ReviewLoading) return;

    emit(ReviewLoading());

    final files = <MultipartFile>[];
    for (final file in images) {
      if (file.path != null) {
        files.add(
          await MultipartFile.fromFile(file.path!, filename: file.name),
        );
      }
    }

    final data = FormData.fromMap({
      'rate': rate,
      if (comment.trim().isNotEmpty) 'comment': comment.trim(),
    });
    for (final file in files) {
      data.files.add(MapEntry('images[]', file));
    }

    await _repository.review(orderId, data).then((_) {
      emit(ReviewSuccess());
    }).catchError((Object error) {
      if (error is DioException) {
        emit(ReviewError(ErrorModel.parseDio(error)));
      } else {
        emit(ReviewError(ErrorModel.nothing));
      }
    });
  }
}
