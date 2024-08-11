import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_parent_cubit/get_parent_cubit.dart';
import 'package:call_son/feature/guardian/presentation/cubit/get_super_parent_kids_cubit/get_super_parent_kids_cubit.dart';
import 'package:call_son/feature/guardian/presentation/views/call_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorsManager.primary,
      onPressed: () {
        GetAllParentKidsCubit.get(context).getAllParentKids(
            superParentId: GetParentCubit.get(context).parentModel!.superParentId!
        );
        Get.to(()=> const CallView(),
            duration: const Duration(milliseconds: 500),
            transition: DelayManager.rightToLeftWithFade,);
      },
      child: const Icon(IconlyLight.call, color: ColorsManager.white,),
    );
  }
}
