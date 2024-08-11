import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/feature/school/presentation/cubit/school_layout_cubit/school_layout_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/school_layout_cubit/school_layout_state.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class SchoolNavBar extends StatelessWidget {
  const SchoolNavBar({super.key});

  final Color selectedItemColor = ColorsManager.white;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolLayoutCubit, SchoolLayoutState>(
      builder: (context, state) {
        var cubit = SchoolLayoutCubit.get(context);
        return SizedBox(
          height: 90,
          child: CrystalNavigationBar(
            paddingR: const EdgeInsets.only(bottom: 5),
            currentIndex: cubit.currentIndex,
            unselectedItemColor: Colors.white70,
            backgroundColor: ColorsManager.primary,
            onTap: (int index) { cubit.changeNavIndex(index: index);},
            items: [

              // Home
              CrystalNavigationBarItem(
                icon: IconlyBold.home,
                unselectedIcon: IconlyLight.home,
                selectedColor: selectedItemColor,
              ),

              // Calls
              CrystalNavigationBarItem(
                icon: IconlyBold.call,
                unselectedIcon: IconlyLight.call,
                selectedColor: selectedItemColor,
              ),

              // Parents Requests
              CrystalNavigationBarItem(
                icon: IconlyBold.user_2,
                unselectedIcon: IconlyLight.user,
                selectedColor: selectedItemColor,
              ),

              // Settings
              CrystalNavigationBarItem(
                icon: IconlyBold.setting,
                unselectedIcon: IconlyLight.setting,
                selectedColor: selectedItemColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

