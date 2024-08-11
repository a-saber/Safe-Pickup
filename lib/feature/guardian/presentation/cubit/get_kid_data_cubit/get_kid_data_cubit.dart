import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_kid_data_state.dart';



class GetKidDataCubit extends Cubit<GetKidDataState> {
  GetKidDataCubit(this.parentRepoImp) : super(GetKidDataInitial());
  final GuardianRepoImplementation parentRepoImp;
  static GetKidDataCubit get(context) => BlocProvider.of(context);

  List<SchoolModel> schools=[];
  String kidId='';
  void getKidData({required String kidId}) async
  {
    emit(GetKidDataLoading());
    var response = await parentRepoImp.getKidData(kidId: kidId);
    response.fold((failure)
    {
      emit(GetKidDataError(failure.errorMessage));
    }, (result) async
    {
      this.kidId = kidId;
      schools = result;
      emit(GetKidDataSuccess());
    }
    );
  }

}
