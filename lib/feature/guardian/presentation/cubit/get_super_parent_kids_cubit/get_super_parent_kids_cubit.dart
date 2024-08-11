import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/feature/guardian/data/repo/guardian_repo_imp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_super_parent_kids_state.dart';



class GetAllParentKidsCubit extends Cubit<GetAllParentKidsState> {
  GetAllParentKidsCubit(this.parentRepoImp) : super(GetAllParentKidsInitial());
  final GuardianRepoImplementation parentRepoImp;
  static GetAllParentKidsCubit get(context) => BlocProvider.of(context);

  List<KidModel> kids = [];
  void getAllParentKids({required String superParentId}) async
  {
    emit(GetAllParentKidsLoading());
    var response = await parentRepoImp.getAllParentKids(superParentId: superParentId);
    response.fold((failure)
    {
      emit(GetAllParentKidsError(failure.errorMessage));
    }, (result) async
    {
      kids = result;
      emit(GetAllParentKidsSuccess());
    }
    );
  }


}
