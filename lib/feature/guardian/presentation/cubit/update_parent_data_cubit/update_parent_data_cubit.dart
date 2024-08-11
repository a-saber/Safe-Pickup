import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'update_parent_data_state.dart';



class UpdateParentCubit extends Cubit<UpdateParentState> {
  UpdateParentCubit(this.parentRepoImp) : super(UpdateParentInitial());
  final GuardianRepoImplementation parentRepoImp;
  static UpdateParentCubit get(context) => BlocProvider.of(context);

  void update({required ParentModel parent}) async
  {
    emit(UpdateParentLoading());
    var response = await parentRepoImp.updateParentData(
      parent: parent,
    );
    response.fold((failure)
    {
      emit(UpdateParentError(failure.errorMessage));
    }, (result) async
    {
      emit(UpdateParentSuccess());
    }
    );
  }

}
