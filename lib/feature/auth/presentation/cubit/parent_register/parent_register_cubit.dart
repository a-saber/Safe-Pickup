import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parent_register_state.dart';

class ParentRegisterCubit extends Cubit<ParentRegisterState> {
  ParentRegisterCubit(this.authRepo) : super(ParentRegisterInitial());
  final AuthRepoImplementation authRepo;
  static ParentRegisterCubit get(context) => BlocProvider.of(context);

  Future<void> register({
    required ParentModel parentModel,
  }) async
  {
    emit(ParentRegisterLoading());
    String? check = checkKidSchoolDuplicate(parentModel: parentModel);
    if(check != null)
    {
      emit(ParentRegisterDuplicateError(check));
      return;
    }
    var response = await authRepo.registerSuperParent( parentModel: parentModel);
    response.fold((failure)
    {
      emit(ParentRegisterError(failure.errorMessage));
    }, (result) async
    {
      emit(ParentRegisterSuccess());
    }
    );
  }

  String? checkKidSchoolDuplicate({required ParentModel parentModel})
  {
    for (var kid in parentModel.kidsModels) {
      int occurrence = parentModel.kidsModels.where((item) => item.nameController.text == kid.nameController.text).length;
      if (occurrence > 1) {
        return '${kid.nameController.text} exists more than once.';
      }
      else
      {
        for (var school in kid.schools) {
          int occurrence = kid.schools.where(
            (item) => item.name == school.name &&
                      item.kidLevelModel!.name == school.kidLevelModel!.name
          ).length;
          if (occurrence > 1) {
            return '${school.name} exists more than once with the same level ${school.kidLevelModel!.name} .';
          }
        }
      }
    }
    return null;
  }


}
