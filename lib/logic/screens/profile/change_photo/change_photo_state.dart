part of 'change_photo_cubit.dart';

enum PhotoStatus { none, url, bytes, error }

class ChangePhotoState extends Equatable {
  const ChangePhotoState(
      {this.status = PhotoStatus.none, this.imageData, this.url, this.error});
  final PhotoStatus status;
  final Uint8List? imageData;
  final String? url;
  final ErrorModel? error;

  @override
  List<Object?> get props => [imageData, url, status, error];
}
