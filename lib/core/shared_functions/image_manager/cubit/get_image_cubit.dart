

import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/shared_functions/image_manager/get_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'get_image_state.dart';

class GetImageCubit extends Cubit<GetImageState> {
  GetImageCubit() : super(GetImageInitial());
  static GetImageCubit get(context) => BlocProvider.of(context);

  XFile? image;

  Future<void> getImage() async {
    emit(GetImageLoading());
    try {
      image = await GetImageManager.getImage();
      if(image != null){
        emit(GetImageSuccess());
      }
      else{
        emit(GetImageInitial());
      }
    } catch (e) {
      emit(GetImageError(failure: DataFailure(e.toString())));
    }
  }


}
