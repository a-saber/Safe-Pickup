import 'package:call_son/core/models/call_model.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/parent_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repo/guardian_repo_imp.dart';
part 'call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit(this.authRepo) : super(CallInitial());
  final GuardianRepoImplementation authRepo;
  static CallCubit get(context) => BlocProvider.of(context);

  void callUp({
    required KidModel kid,
    required SchoolModel schoolModel,
    required ParentModel parent,
  }) async
  {
    emit(CallLoading());
    var response = await authRepo.callUp(
      kid: kid,
      parent: parent,
      schoolModel: schoolModel
    );
    response.fold((failure)
    {
      print(failure.errorMessage);
      emit(CallError(failure.errorMessage));
    }, (result)
    {
      emit(CallSuccess(result));
    }
    );
  }
}
