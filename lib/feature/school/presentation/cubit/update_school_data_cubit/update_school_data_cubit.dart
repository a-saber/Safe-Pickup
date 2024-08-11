import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/school/data/repo/school_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'update_school_data_state.dart';

class UpdateSchoolCubit extends Cubit<UpdateSchoolState> {
  UpdateSchoolCubit(this.schoolRepoImp) : super(UpdateSchoolInitial());
  final SchoolRepoImplementation schoolRepoImp;
  static UpdateSchoolCubit get(context) => BlocProvider.of(context);

  void update({required SchoolModel schoolModel}) async
  {
    emit(UpdateSchoolLoading());
    var response = await schoolRepoImp.updateData(
      schoolModel: schoolModel,
    );
    response.fold((failure)
    {
      emit(UpdateSchoolError(failure.errorMessage));
    }, (result) async
    {
      emit(UpdateSchoolSuccess());
    }
    );
  }

  void updateLocation({required SchoolModel schoolModel}) async
  {
    emit(UpdateSchoolLoading());
    var response = await schoolRepoImp.updateLocationData(
      schoolModel: schoolModel,
    );
    response.fold((failure)
    {
      emit(UpdateSchoolError(failure.errorMessage));
    }, (result) async
    {
      emit(UpdateSchoolSuccess());
    }
    );
  }
}
