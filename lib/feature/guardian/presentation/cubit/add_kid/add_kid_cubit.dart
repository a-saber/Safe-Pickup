import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_kid_state.dart';

class AddKidCubit extends Cubit<AddKidState> {
  AddKidCubit(this.parentRepoImp)
      : super(AddKidInitial());
  final GuardianRepoImplementation parentRepoImp;

  static AddKidCubit get(context) => BlocProvider.of(context);

  void addKid({required KidModel kid}) async {
    emit(AddKidLoading());
    var response = await parentRepoImp.newKid(kid: kid);
    response.fold((failure) {
      emit(AddKidFailure(failure: failure));
    }, (result) async {
      emit(AddKidSuccess());
    });
  }
}
