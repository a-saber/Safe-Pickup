import 'package:call_son/core/core_widgets/custom_app_bar.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/delay_manager.dart';
import 'package:call_son/feature/auth/presentation/views/parent_register_view.dart';
import 'package:call_son/feature/auth/presentation/views/location_view.dart';
import 'package:call_son/feature/welcome/presentation/views/widgets/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {

  bool? schoolSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Choose Your User Type", showPopup: true,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OptionWidget(
                  onTap: () {
                    setState(() {
                      schoolSelected = true;
                    });
                  },
                  image: AssetsManager.school,
                  isSelected: schoolSelected ==null?false:schoolSelected!,
                  text: "School",
                ),
                const SizedBox(
                  width: 70,
                ),
                OptionWidget(
                  onTap: ()
                  {
                    setState(() {
                      schoolSelected = false;
                    });
                  },
                  image: AssetsManager.family, isSelected: schoolSelected ==null?false: !schoolSelected!,
                  text: "Parents",
                ),
              ],
            ),
            const SizedBox(height: 50.0,),
            DefaultButton(
              onTap: schoolSelected==null?null:
                  ()
              {
                if(schoolSelected!)
                {
                  Get.to(()=> const LocationView(),
                  duration: const Duration(milliseconds: 500),
                  transition: DelayManager.rightToLeftWithFade);
                }
                else
                {
                  Get.to(()=> const ParentRegisterView(),
                      duration: const Duration(milliseconds: 500),
                      transition: DelayManager.rightToLeftWithFade);
                }
              }, text: 'Continue')
          ],
        ),
      ),
    );
  }
}
