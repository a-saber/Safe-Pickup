import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/core_widgets/pop_up/my_snack_bar.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/get_school_cubit/get_school_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/location/location_cubit.dart';
import 'package:call_son/feature/auth/presentation/views/location_view.dart';
import 'package:call_son/feature/school/presentation/cubit/update_school_data_cubit/update_school_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SchoolChangeLocationView extends StatelessWidget {
  const SchoolChangeLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Edit Location", showPopup: true,),
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = LocationCubit.get(context);
          return Builder(builder: (context) {
            if (cubit.kGooglePlex == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                DefaultCheckBox(
                  selected: cubit.useCurrent,
                  text: 'Current Location',
                  icon: AssetsManager.logo,
                  onTap: () {
                    cubit.chooseUserCurrent(true);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultCheckBox(
                  selected: cubit.useAnother,
                  text: 'Pick another location',
                  icon: AssetsManager.logo,
                  onTap: () {
                    cubit.chooseAnotherLocation(true);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
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
                      BlocConsumer<UpdateSchoolCubit, UpdateSchoolState>(
                        listener: (context, state) {
                          if(state is UpdateSchoolSuccess){
                            callMySnackBar(context: context, text: 'Location Updated');
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                          else if(state is UpdateSchoolError){
                            callMySnackBar(context: context, text: state.error);
                          }
                        },
                        builder: (context, state) {
                          if(state is UpdateSchoolLoading){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          else
                          {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0, right: 80, left: 80),
                                child: DefaultButton(
                                  onTap: () {
                                    if (cubit.currentLocation != null ||
                                        cubit.markers.isNotEmpty) {
                                      if (cubit.useCurrent) {
                                        GetSchoolCubit.get(context).schoolModel!.long = cubit
                                            .currentLocation!.longitude;
                                        GetSchoolCubit.get(context).schoolModel!.lat = cubit
                                            .currentLocation!.latitude;
                                      } else {
                                        GetSchoolCubit.get(context).schoolModel!.long = cubit
                                            .markers[0].position.longitude;
                                        GetSchoolCubit.get(context).schoolModel!.lat = cubit
                                            .markers[0].position.latitude;
                                      }
                                      UpdateSchoolCubit.get(context).updateLocation(schoolModel: GetSchoolCubit.get(context).schoolModel!);
                                    }
                                  },
                                  text: 'Edit',
                                )
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          });
        },
      ),
    );
  }
}
