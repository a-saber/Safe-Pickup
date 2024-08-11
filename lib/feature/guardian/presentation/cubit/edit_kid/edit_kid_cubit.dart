import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_kid_state.dart';

class EditKidCubit extends Cubit<EditKidState> {
  EditKidCubit(this.parentRepoImp)
      : super(EditKidInitial());
  final GuardianRepoImplementation parentRepoImp;

  static EditKidCubit get(context) => BlocProvider.of(context);

  void editKid({required KidModel kid}) async {
    emit(EditKidLoading());
    var response = await parentRepoImp.editKidData(kid: kid);
    response.fold((failure) {
      emit(EditKidFailure(failure: failure));
    }, (result) async {
      emit(EditKidSuccess());
    });
  }
}
