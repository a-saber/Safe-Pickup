import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_user_cubit/get_user_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_user_cubit/get_user_state.dart';
import 'package:call_son/feature/guardian/presentation/views/parents_home_view.dart';
import 'package:call_son/feature/school/presentation/views/school_home_layout.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  User? user;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      debugPrint('User is currently signed out!');
      user = null;
    } else {
      setState(() {
        isLoading = false;
      });
      GetUserCubit.get(context).getUser();
      debugPrint('User is signed in!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context)
        {
          if(isLoading)
          {
            return const SplashViewBody();
          }
          else
          {
          if (user == null) {
            print('object');
            navigateToNextScreen(nextScreen: const LoginView());
          }
          return BlocListener<GetUserCubit, GetUserState>(
            listener: (context, state) {
              if (state is GetUserSuccess) {
                if(state.loginModel.isSchool)
                {
                  GetSchoolCubit.get(context).assignSchool(json: state.loginModel.json);
                  navigateToNextScreen(nextScreen: const SchoolHomeLayout());
                }
                else
                {
                  GetParentCubit.get(context).assignParent(json: state.loginModel.json);
                  navigateToNextScreen(nextScreen: const ParentsHomeView());
                }

              } else if (state is GetUserFailure) {
                callMySnackBar(context: context, text: state.failure.errorMessage);
                navigateToNextScreen(nextScreen: const LoginView());
              }
            },
            child: const SplashViewBody(),
          );
        }
      }
      ),
    );
  }



  void navigateToNextScreen({required Widget nextScreen}) {
    Future.delayed(
      const Duration(seconds: 1),
          () async {
        Get.off(() => nextScreen,
            duration: const Duration(milliseconds: 1000),
            transition: DelayManager.fade);
      },
    );
  }
}

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(AssetsManager.logo),
      ],
    );
  }
}


/*
FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        debugPrint('User is currently signed out!');
        this.user = null;
      } else {
        setState(() {
          isLoading = false;
        });
        GetSchoolCubit.get(context).getSchool();
        this.user = user;
        debugPrint('User is signed in!');
      }
    });
 */