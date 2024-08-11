import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'school_register_state.dart';

class SchoolRegisterCubit extends Cubit<SchoolRegisterState> {
  SchoolRegisterCubit(this.schoolAuthRepoImp) : super(SchoolRegisterInitial());
  final AuthRepoImplementation schoolAuthRepoImp;
  static SchoolRegisterCubit get(context) => BlocProvider.of(context);
  SchoolModel schoolModel = SchoolModel();

  void register() async
  {
    emit(SchoolRegisterLoading());
    var response = await schoolAuthRepoImp.registerSchool(
      schoolModel: schoolModel,
    );
    response.fold((failure)
    {
      emit(SchoolRegisterError(failure.errorMessage));
    }, (result) async
    {
      emit(SchoolRegisterSuccess());
    }
    );
  }
}
