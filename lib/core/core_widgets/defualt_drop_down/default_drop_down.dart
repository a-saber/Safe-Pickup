import 'package:call_son/core/core_widgets/defualt_drop_down/search_drop_down_form_field.dart';
import 'package:call_son/core/models/kid_model.dart';
import 'package:call_son/core/models/school_model.dart';
import 'package:call_son/core/resources_manager/color_manager.dart';
import 'package:call_son/core/resources_manager/style_manager.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DefaultDropDown extends StatefulWidget {
  const DefaultDropDown({
    super.key,
    required this.text,
    required this.textEditingController,
    required this.items,
    required this.onChanged,
  });
  final String text;
  final List<String> items;
  final Function(String?) onChanged;
  final TextEditingController textEditingController;

  @override
  State<DefaultDropDown> createState() => _RequestPricingDropDown();
}

class _RequestPricingDropDown extends State<DefaultDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          widget.text,
          style: StyleManager.semiBold.copyWith(
            fontSize: 18.0,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down,color: ColorsManager.black,),
          iconDisabledColor: ColorsManager.black,
          iconEnabledColor: ColorsManager.black,
        ),
        isDense: true,
        alignment: AlignmentDirectional.centerStart,
        items: widget.items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: StyleManager.semiBold.copyWith(
              fontSize: 18.0,
            ),
          ),
        ))
            .toList(),
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height:  45,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: ColorsManager.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        dropdownStyleData: const DropdownStyleData(
          maxHeight: 300,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: widget.textEditingController,
          searchInnerWidgetHeight: 10,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: SearchDropDownFormField(
              controller: widget.textEditingController,
              text: widget.text,
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().contains(searchValue);
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            widget.textEditingController.clear();
          }
        },
      ),
    );
  }
}



class KidsDropDown extends StatefulWidget {
  const KidsDropDown({
    super.key,
    required this.text,
    required this.value,
    required this.textEditingController,
    required this.kids,
    required this.onChanged,
  });
  final String text;
  final KidModel? value;
  final List<KidModel> kids;
  final Function(KidModel?) onChanged;
  final TextEditingController textEditingController;

  @override
  State<KidsDropDown> createState() => _RequestPricingDropDown2();
}

class _RequestPricingDropDown2 extends State<KidsDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<KidModel>(
        value: widget.value,
        isExpanded: true,
        hint: Text(
          widget.text,
          style: StyleManager.semiBold.copyWith(
            fontSize: 18.0,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down,color: ColorsManager.primary,),
          iconDisabledColor: ColorsManager.grey,
          iconEnabledColor: ColorsManager.primary,
        ),
        isDense: true,
        alignment: AlignmentDirectional.centerStart,
        items: widget.kids
            .map((KidModel item) => DropdownMenuItem<KidModel>(
          value: item,
          child: Text(
            item.name!,
            style: StyleManager.semiBold.copyWith(
              fontSize: 18.0,
            ),
          ),
        ))
            .toList(),
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height:  45,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsManager.grey),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        dropdownStyleData: const DropdownStyleData(
          maxHeight: 300,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: widget.textEditingController,
          searchInnerWidgetHeight: 10,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: SearchDropDownFormField(
              controller: widget.textEditingController,
              text: widget.text,
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value!.name!.contains(searchValue);
          },
        ),
        onMenuStateChange: (isOpen) {
          //if (!isOpen) {
            widget.textEditingController.clear();
          //}
        },
      ),
    );
  }
}



class SchoolsDropDown extends StatefulWidget {
  const SchoolsDropDown({
    super.key,
    required this.text,
    required this.textEditingController,
    required this.schools,
    required this.onChanged,
    required this.value,
  });
  final String text;
  final List<SchoolModel> schools;
  final Function(SchoolModel?) onChanged;
  final SchoolModel? value;
  final TextEditingController textEditingController;

  @override
  State<SchoolsDropDown> createState() => _RequestPricingDropDown3();
}

class _RequestPricingDropDown3 extends State<SchoolsDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<SchoolModel>(
        value: widget.value,
        isExpanded: true,
        hint: Text(
          widget.text,
          style: StyleManager.semiBold.copyWith(
            fontSize: 18.0,),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down,color: ColorsManager.primary,),
          iconDisabledColor: ColorsManager.grey,
          iconEnabledColor: ColorsManager.primary,
        ),
        isDense: true,
        alignment: AlignmentDirectional.centerStart,
        items: widget.schools
            .map((SchoolModel item) => DropdownMenuItem<SchoolModel>(
          value: item,
          child: Text(
            '${item.name!} ${item.kidLevelModel!.name}',
            style: StyleManager.semiBold.copyWith(
              fontSize: 18.0,),
          ),
        ))
            .toList(),
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height:  45,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsManager.grey),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        dropdownStyleData: const DropdownStyleData(
          maxHeight: 300,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: widget.textEditingController,
          searchInnerWidgetHeight: 10,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: SearchDropDownFormField(
              controller: widget.textEditingController,
              text: widget.text,
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return '${item.value!.name!} ${item.value!.kidLevelModel!.name}'.contains(searchValue);
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            widget.textEditingController.clear();
          }
        },
      ),
    );
  }
}
