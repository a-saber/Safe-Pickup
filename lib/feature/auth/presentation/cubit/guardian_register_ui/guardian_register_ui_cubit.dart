import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'guardian_register_ui_state.dart';

class ParentRegisterUiCubit extends Cubit<ParentRegisterUiState> {
  ParentRegisterUiCubit() : super(ParentRegisterUiInitial());
  static ParentRegisterUiCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  List<KidModel> kids=
  [
    KidModel(schools: [SchoolModel()]),
  ];

  void addNewChild()
  {
    kids.add(KidModel(schools: [SchoolModel()]));
    emit(NewChild());
  }

  bool canRemove()
  {
    return kids.length > 1;
  }

  void removeChild(int index)
  {
    if(kids.length != 1)
    {
      kids.removeAt(index);
      emit(RemoveChild());
    }
  }

  void addSchool({required int kidIndex})
  {
    kids[kidIndex].schools.add(SchoolModel());
    emit(AddSchool());
  }
  void chooseSchool({required int kidIndex, required int schoolIndex, required SchoolModel schoolModel})
  {
    SchoolModel school = SchoolModel(
      id: schoolModel.id,
      name: schoolModel.name,
      phone: schoolModel.phone,
      lat: schoolModel.lat,
      long: schoolModel.long,
      imagePath: schoolModel.imagePath,
      ssnRequired: schoolModel.ssnRequired,
    );
    school.levels = schoolModel.levels;
    kids[kidIndex].schools[schoolIndex] =school;

    emit(ChooseSchool());
  }
  void chooseLevel({required int kidIndex, required int schoolIndex, required int levelIndex})
  {
    kids[kidIndex].schools[schoolIndex].kidLevelModel = kids[kidIndex].schools[schoolIndex].levels[levelIndex];
    emit(ChooseLevel());
  }
  void removeSchool({required int kidIndex, required int schoolIndex})
  {
    if(kids[kidIndex].schools.length !=1) {
      kids[kidIndex].schools.removeAt(schoolIndex);
      emit(RemoveSchool());
    }
  }

}
