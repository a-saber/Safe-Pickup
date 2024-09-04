import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/feature/school/presentation/views/school_settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'school_layout_state.dart';
import 'package:call_son/feature/school/presentation/views/school_calls_view.dart';
import 'package:call_son/feature/school/presentation/views/school_guardian_view.dart';
import 'package:call_son/feature/school/presentation/views/school_home_view.dart';


class SchoolLayoutCubit extends Cubit<SchoolLayoutState> {
  SchoolLayoutCubit() : super(SchoolLayoutInitial());
  static SchoolLayoutCubit get(context) => BlocProvider.of(context);

  Widget currentScreen = const SchoolHomeView();
  int currentIndex = 0;
  String currentTitle = '' ;

  void changeNavIndex({ required int index})
  {
    currentIndex = index;
    switch(index)
    {
      case 0:
        currentScreen = const SchoolHomeView();
        currentTitle = '';
        break;
      case 1:
        currentScreen = const SchoolCallsView();
        currentTitle = TranslationKeyManager.pickupRequests;
        break;
      case 2:
        currentScreen = const SchoolSettingsView();
        currentTitle = TranslationKeyManager.settings;
        break;
      // case 4:
      //   currentScreen = const SchoolGuardiansView();
      //   currentTitle = TranslationKeyManager.parents;
      //   break;

    }
    emit(SchoolLayoutChangeNavIndex());
  }

}

