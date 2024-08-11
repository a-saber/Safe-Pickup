import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/location/location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'school_change_location_view.dart';

class SchoolLocationView extends StatelessWidget {
  const SchoolLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Location", showPopup: true,),
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LocationCubit.get(context);
          return Builder(builder: (context) {
            if (cubit.kGooglePlex == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    onTap: cubit.mapOnTap,
                    markers: Set<Marker>.of(cubit.markers),
                    mapType: MapType.hybrid,
                    initialCameraPosition: cubit.kGooglePlex!,
                    onMapCreated: (GoogleMapController controller) {
                      cubit.controller.complete(controller);
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, right: 80, left: 80),
                      child: DefaultButton(
                        onTap: () {
                          cubit.init(context, useCurrent: false);
                          Get.to(() => const SchoolChangeLocationView(),
                              duration: const Duration(milliseconds: 500),
                              transition: DelayManager.rightToLeftWithFade);
                        },
                        text: 'Edit School Location',
                      )
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
