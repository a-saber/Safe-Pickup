import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_state.dart';
import 'package:call_son/feature/auth/presentation/views/login_view.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_state.dart';
import 'package:call_son/feature/guardian/presentation/views/parent_kids_view.dart';
import 'package:call_son/feature/guardian/presentation/views/parent_profile_view.dart';
import 'package:call_son/feature/guardian_history/presentation/views/history_view.dart';
import 'package:call_son/feature/school/presentation/views/widgets/logout_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocConsumer<GetParentCubit, GetParentState>(
        listener: (context, state)
        {
          if( state is GetParentFailure)
          {
            Get.off(()=> const LoginView(),);
          }
        },
        builder: (context, state) {
          if(state is GetParentLoading)
          {
            return const Center(child: CircularProgressIndicator());
          }
          else
          {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: ColorsManager.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.asset(
                                AssetsManager.logo,
                                fit: BoxFit.cover,
                                //color: ColorsManager.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: (){scaffoldKey.currentState!.closeDrawer();},
                              icon: const Icon(IconlyLight.close_square, color: ColorsManager.white,))
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Hello, ',
                                  style: StyleManager.medium.copyWith(
                                      fontSize: 15.0,
                                      color: ColorsManager.white
                                  ),
                                ),
                                Builder(
                                    builder: (context) {
                                      return Text(
                                        GetParentCubit.get(context).parentModel!.name??'',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: StyleManager.regular.copyWith(
                                            fontSize: 18.0,
                                            color: ColorsManager.white
                                        ),
                                      );
                                    }
                                )
                              ],
                            ),
                          ),
                          IconButton(
                              splashColor: ColorsManager.white,
                              onPressed: (){},
                              icon: const Icon(IconlyLight.edit_square, color: ColorsManager.white,)
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(IconlyLight.home,),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.profile),
                  title: const Text('Profile'),
                  onTap: () {
                    Get.to(()=> const ParentProfileView(),
                        duration: const Duration(milliseconds: 500),
                        transition: DelayManager.rightToLeftWithFade);
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.time_square),
                  title: const Text('History'),
                  onTap: () {
                    Get.to(()=> const GuardianHistoryView(),
                        duration: const Duration(milliseconds: 500),
                        transition: DelayManager.rightToLeftWithFade);
                  },
                ),
                Builder(
                    builder: (context)
                    {
                      if( GetParentCubit.get(context).parentModel!.fullAccess!)
                      {
                        return BlocBuilder<GetAllParentKidsCubit, GetAllParentKidsState>(
                          builder: (context, allKidsState)
                          {
                            return ListTile(
                              leading: const Icon(IconlyLight.work),
                              title: const Text('Kids'),
                              onTap: () {
                                if(allKidsState is ! GetAllParentKidsSuccess)
                                {
                                  GetAllParentKidsCubit.get(context).getAllParentKids(
                                      superParentId: GetParentCubit.get(context).parentModel!.superParentId!
                                  );
                                }
                                Get.to(()=> const ParentKidsView(),
                                    duration: const Duration(milliseconds: 500),
                                    transition: DelayManager.rightToLeftWithFade
                                );
                              },
                            );
                          },
                        );
                      }
                      else
                      {
                        // todo: get kids assigned to parent

                        return ListTile(
                          leading: const Icon(IconlyLight.work),
                          title: const Text('Kids'),
                          onTap: () {
                            Get.to(()=> const ParentKidsView(),
                                duration: const Duration(milliseconds: 500),
                                transition: DelayManager.rightToLeftWithFade
                            );
                          },
                        );
                      }

                    }
                ),
                ListTile(
                  leading: const Icon(IconlyLight.user_1),
                  title: const Text('Schools'),
                  onTap: () {
                    // Handle School tap
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.setting),
                  title: const Text('Settings'),
                  onTap: () {
                    // Handle Settings tap
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: const Icon(IconlyLight.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) => alertLogout(context),
                        barrierDismissible: false); // Close the drawer
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
