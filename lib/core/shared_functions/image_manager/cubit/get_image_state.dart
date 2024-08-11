
import 'package:call_son/core/errors/failures.dart';
import 'package:image_picker/image_picker.dart';

sealed class GetImageState {}

final class GetImageInitial extends GetImageState {}

final class GetImageLoading extends GetImageState {}

final class GetImageSuccess extends GetImageState {}

final class GetImageError extends GetImageState
{
  Failure failure;
  GetImageError({required this.failure});
}
