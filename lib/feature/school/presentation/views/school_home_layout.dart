import 'package:call_son/feature/school/presentation/cubit/school_layout_cubit/school_layout_cubit.dart';
import 'package:call_son/feature/school/presentation/cubit/school_layout_cubit/school_layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/school_home_nav_bar.dart';


class SchoolHomeLayout extends StatelessWidget {
  const SchoolHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolLayoutCubit, SchoolLayoutState>(
      builder: (context, state)
        {
          var cubit = SchoolLayoutCubit.get(context);
          return Scaffold(
            extendBody: true,

            appBar: cubit.currentIndex == 0 ?
            null:
            AppBar(
              title: Text(cubit.currentTitle),
            ),
            bottomNavigationBar: const SchoolNavBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SchoolLayoutCubit.get(context).currentScreen,
            ),
          );
        });
  }
}
