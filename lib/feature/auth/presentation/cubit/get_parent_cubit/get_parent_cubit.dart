import 'package:call_son/core/errors/failures.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_parent_state.dart';


class GetParentCubit extends Cubit<GetParentState> {
  final AuthRepoImplementation authRepoImp;
  static GetParentCubit get(context) => BlocProvider.of(context);
  GetParentCubit(this.authRepoImp) : super(GetParentInitial());

  ParentModel? parentModel;
  void getParent() async {
    emit(GetParentLoading());
    final result = await authRepoImp.getParent();
    result.fold((l) => emit(GetParentFailure(failure: l)),
            (r) {parentModel = r; emit(GetParentSuccess(parentModel: r));});
  }

  void assignParent({required Map<String, dynamic> json}) async {
    emit(GetParentLoading());
    try {
      parentModel = ParentModel.fromJson(json);
      emit(GetParentSuccess(parentModel: parentModel!));
    }
    catch(e)
    {
      emit(GetParentFailure(failure: DataFailure(e.toString())));
    }
  }
}