import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:call_son/core/core_widgets/default_button/default_button.dart';
import 'package:call_son/core/resources_manager/assets_manager.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_cubit.dart';
import 'package:call_son/core/shared_functions/image_manager/cubit/get_image_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class GetImageManager {
  static Future<XFile?> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}

class FileImageView extends StatelessWidget {
  const FileImageView({super.key, this.imagePath});

  final String? imagePath;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetImageCubit, GetImageState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GetImageCubit.get(context);
          return Column(
            children: [
              Builder(
                builder: (context) {
                  if(cubit.image != null )
                  {
                    return Container(
                      height: 100,
                      width: 100,
                      decoration:
                      BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(cubit.image!.path)),
                            fit: BoxFit.cover,
                          )
                      )
                    );
                  }
                  else if(imagePath != null)
                  {
                    return CloudImageViewer(imagePath: imagePath!);
                  }
                  else
                  {
                    return const IconImageViewer();
                  }

                }
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                child: DefaultButton(onTap: (){cubit.getImage();}, icon: const Icon(
                  IconlyLight.camera,
                  color: Colors.white,
                  size: 20,
                ), text: imagePath != null? 'Change Image':'Choose Image',),
              ),
            ],
          );
        });
  }
}

class IconImageViewer extends StatelessWidget {
  const IconImageViewer({super.key, this.isSchool = true});

  final bool isSchool;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration:
      BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: ColorsManager.primary, width: 1),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            isSchool?
            AssetsManager.school:
            AssetsManager.family,
            color: ColorsManager.primary,
          ),
        ),
      ),
    );
  }
}


class CloudImageViewer extends StatelessWidget {
  const CloudImageViewer({super.key, required this.imagePath});

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: CachedNetworkImage(
          placeholder: (context, url) =>
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) =>
          const Icon(Icons.person),
          imageUrl: imagePath,
          fit: BoxFit.cover,
          height: 60,
          width: 60,
        )
    );
  }
}

