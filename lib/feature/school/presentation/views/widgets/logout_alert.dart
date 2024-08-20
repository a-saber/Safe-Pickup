import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/logout_cubit/logout_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

AlertDialog alertLogout(context) => AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorsManager.white,
            ),
            padding: const EdgeInsets.all(10.0),
            width: width * 0.35,
            height: height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  IconlyLight.logout,
                  size: 55,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  TranslationKeyManager.sureUWantToLogout.tr,
                  textAlign: TextAlign.center,
                  style: StyleManager.bold.copyWith(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                            color: ColorsManager.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(TranslationKeyManager.noCancel.tr,
                                  style: StyleManager.semiBold.copyWith(
                                    color: Colors.white,
                                    fontSize: 19,
                                  )),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocConsumer<LogoutCubit, LogoutState>(
                        listener: (context, state) {
                          if (state is LogoutFailure)
                          {
                            callMySnackBar(context: context, text: state.failure.errorMessage);
                          }
                          if(state is LogoutSuccess)
                          {
                            Get.off(()=> const LoginView(),
                                transition: DelayManager.fadeIn,
                                duration: const Duration(milliseconds: 500));
                          }
                        },
                        builder: (context, state) {
                          if(state is LogoutLoading)
                          {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else
                          {
                            return SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                  color: ColorsManager.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color: ColorsManager.primary, width: 2),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(TranslationKeyManager.yesLogout.tr,
                                        style: StyleManager.semiBold.copyWith(
                                          color: ColorsManager.primary,
                                          fontSize: 19,
                                        )),
                                  ),
                                  onPressed: () {LogoutCubit.get(context).logout();}),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
