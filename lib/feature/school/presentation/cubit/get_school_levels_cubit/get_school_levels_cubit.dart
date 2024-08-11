import 'package:call_son/core/models/level_model.dart';
import 'package:call_son/feature/school/data/repo/school_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'get_school_levels_state.dart';

class GetSchoolLevelsCubit extends Cubit<GetSchoolLevelsState> {
  GetSchoolLevelsCubit(this.schoolRepoImp) : super(GetSchoolLevelsInitial());
  final SchoolRepoImplementation schoolRepoImp;
  static GetSchoolLevelsCubit get(context) => BlocProvider.of(context);

  void getLevels() async
  {
    emit(GetSchoolLevelsLoading());
    var response = await schoolRepoImp.getLevels();
    response.fold((failure)
    {
      emit(GetSchoolLevelsError(failure.errorMessage));
    }, (result) async
    {
      emit(GetSchoolLevelsSuccess(levels: result));
    }
    );
  }
}
