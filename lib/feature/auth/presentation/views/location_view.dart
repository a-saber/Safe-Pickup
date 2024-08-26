import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/localization/translation_key_manager.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:call_son/feature/auth/presentation/cubit/location/location_cubit.dart';
import 'package:call_son/feature/auth/presentation/cubit/school_register/school_register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'school_register_view.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});


  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  @override
  void initState() {
    LocationCubit.get(context).init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title:  TranslationKeyManager.location.tr, showPopup: true,),
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
                  text: TranslationKeyManager.currentLocation.tr,
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
                  text: TranslationKeyManager.pickAnotherLocation.tr,
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
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20.0, right: 80, left: 80),
                          child: DefaultButton(
                              onTap: () {
                                if (cubit.currentLocation != null ||
                                    cubit.markers.isNotEmpty) {
                                  if (cubit.useCurrent) {
                                    SchoolRegisterCubit.get(context).schoolModel.long = cubit
                                        .currentLocation!.longitude;
                                    SchoolRegisterCubit.get(context).schoolModel.lat = cubit
                                        .currentLocation!.latitude;
                                  } else {
                                    SchoolRegisterCubit.get(context).schoolModel.long = cubit
                                        .markers[0].position.longitude;
                                    SchoolRegisterCubit.get(context).schoolModel.lat = cubit
                                        .markers[0].position.latitude;
                                  }
                                  Get.to(() => const SchoolRegisterView());
                                }
                              },
                              text: TranslationKeyManager.continueBTN.tr
                          )
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


class DefaultCheckBox extends StatelessWidget {
  const DefaultCheckBox(
      {super.key,
      required this.selected,
      required this.text,
      required this.icon,
      required this.onTap});

  final bool selected;
  final String text;
  final String icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorsManager.primary)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                text,
                textAlign: TextAlign.start,
                    style: StyleManager.semiBold.copyWith(
                      fontSize: 15.0,
                    ),
              )),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: selected ? ColorsManager.primary : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: ColorsManager.primary),
                ),
                child: const Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
