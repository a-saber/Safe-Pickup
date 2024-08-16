import 'package:call_son/core/resources_manager/constants_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_cubit.dart';
import 'package:call_son/feature/auth/data/auth_repo/auth_repo_imp.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_schools/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_user_cubit/get_user_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/guardian_register_ui/guardian_register_ui_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/parent_register/parent_register_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid/add_kid_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/add_kid_level/add_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/delete_kid_level/delete_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/edit_kid/edit_kid_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_all_schools/get_all_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_kid_data_cubit/get_kid_data_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_levels/get_levels_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_nearby_schools/get_nearby_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/parent_edit_kid_level/parent_edit_kid_level_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/search_schools/search_schools_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/update_parent_data_cubit/update_parent_data_cubit.dart';
import 'package:call_son/feature/guardian_history/data/repo/guardian_history_repo_imp.dart';
import 'package:call_son/feature/guardian_history/presentation/cubit/history/history_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/change_guardian_verification/change_guardian_verification_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/edit_school_levels_cubit/edit_school_levels_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/get_calls/get_calls_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/get_school_levels_cubit/get_school_levels_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/get_verified_guardians/get_verified_guardians_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/school_forgot_pass_cubit/school_forgot_pass_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/school_layout_cubit/school_layout_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/update_school_data_cubit/update_school_data_cubit.dart';
import 'package:call_son/feature/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../feature/guardian/data/repo/guardian_repo_imp.dart';
import '../../feature/guardian/presentation/cubit/call/call_cubit.dart';
import '../../feature/school/data/repo/school_repo_imp.dart';
import '../../feature/school/presentation/cubit/change_call_status/change_call_status_cubit.dart';
import '../../feature/school/presentation/cubit/get_not_verified_guardians/get_not_verified_guardians_cubit.dart';
import '../../feature/auth/presentation/cubit/location/location_cubit.dart';
import '../../feature/auth/presentation/cubit/school_register/school_register_cubit.dart';
import '../cache_helper/cache_data.dart';
import '../localization/app_localization.dart';
import '../service/service_locator.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(create: (context)=>GetImageCubit()),
        BlocProvider(create: (context)=>SearchSchoolsCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>GetNearBySchoolsCubit(getIt.get<GuardianRepoImplementation>())..getNearBySchools(context, distanceInKm: 1)),
        BlocProvider(create: (context)=>GetLevelsCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>GetAllSchoolsCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>EditKidCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>AddKidCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>AddKidLevelCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>DeleteKidLevelCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>ParentEditKidLevelCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>SchoolLayoutCubit()),
        BlocProvider(create: (context)=>GetKidDataCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>GetAllParentKidsCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>UpdateParentCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>GetSchoolLevelsCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>EditSchoolLevelsCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>UpdateSchoolCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>GetParentCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>GetUserCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>LocationCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>GetSchoolCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>SchoolForgetPassCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>LoginCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>LogoutCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>ParentRegisterUiCubit()),
        BlocProvider(create: (context)=>SchoolRegisterCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>ParentRegisterCubit(getIt.get<AuthRepoImplementation>())),
        BlocProvider(create: (context)=>CallCubit(getIt.get<GuardianRepoImplementation>())),
        BlocProvider(create: (context)=>GetVerifiedGuardiansCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>GetNotVerifiedGuardiansCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>ChangeGuardianVerificationCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>GetCallsCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>ChangeCallStatusCubit(getIt.get<SchoolRepoImplementation>())),
        BlocProvider(create: (context)=>HistoryCubit(getIt.get<GuardianHistoryRepoImplementation>())),
        BlocProvider(create: (context)=>GetSchoolsCubit(getIt.get<AuthRepoImplementation>())),
      ],
      child: GetMaterialApp(
        locale: Locale(CacheData.lang!),
        translations: AppLocalization(),
        title: ConstantsManager.appTitle,
        theme: ThemeManager.theme,
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
      )
    );
  }
}