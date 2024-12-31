import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/controllers/filter_controller.dart';
import 'package:bureau_couple/getx/controllers/matches_controller.dart';
import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/features/screens/filter/filter_category_screen.dart';
import 'package:bureau_couple/getx/features/widgets/custom_button%20_widget.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/utils/colors.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/sizeboxes.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/textstyles.dart';
import 'package:bureau_couple/src/models/LoginResponse.dart';
import 'package:bureau_couple/src/utils/widgets/buttons.dart';
import 'package:bureau_couple/src/utils/widgets/customAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../src/views/home/matches/matches_screen.dart';
import '../../../../src/views/signup/sign_up_expectation_screen.dart';
import 'filter_screen_field_widget.dart';

class FilterScreen extends StatefulWidget {
  final LoginResponse response;
   FilterScreen({super.key, required this.response,});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final stateController = TextEditingController();

  final districtController = TextEditingController();
  bool isAge  = false;
  bool isHeight = false;


  RangeValues _currentRangeValues = RangeValues(
    4.0,
    7.0,
  );


  String _formatHeight(double value) {
    int feet = value.floor(); // Get the whole number as feet
    int inches = ((value - feet) * 12).round(); // Convert decimal to inches

    // Handle edge cases where inches reach 12
    if (inches >= 12) {
      feet++;
      inches = 0;
    }

    return "$feet'${inches}";
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().getReligionsList();
      Get.find<AuthController>().getCommunityList();
      Get.find<AuthController>().getMotherTongueList();
      Get.find<AuthController>().getProfessionList();
    });
    return GetBuilder<AuthController>(builder: (authControl) {
      return Scaffold(
        appBar: const CustomAppBar(title: "", isBackButtonExist: true,),
        bottomNavigationBar: SingleChildScrollView(
          child: Container(

            padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CustomButtonWidget(buttonText: 'Apply', onPressed: () {


              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          MatchesScreen(
                            state: Get.find<AuthController>().filterPostingState.isNotEmpty?Get.find<AuthController>().filterPostingState:"",
                            profession: Get.find<FilterController>().filterProfessionList.isNotEmpty?Get.find<FilterController>().filterProfessionList:"",
                            response: widget.response,
                            religion: Get.find<FilterController>().filterReligionList.isNotEmpty?Get.find<FilterController>().filterReligionList:"",
                            motherTongue: Get.find<FilterController>().filterMotherTongueList.isNotEmpty?Get.find<FilterController>().filterMotherTongueList:"",
                            minHeight: isHeight?(_formatHeight(Get.find<AuthController>().startHeightValue.value)).toString().replaceAll("'", "."): "",
                            maxHeight: isHeight?(_formatHeight(Get.find<AuthController>().endHeightValue.value)).toString().replaceAll("'", "."):"",
                            maxAge: isAge?(Get.find<AuthController>().startValue.value).toStringAsFixed(0):"",
                            minAge: isAge?(Get.find<AuthController>().endValue.value).toStringAsFixed(0):"",
                            based: '',
                            community: Get.find<FilterController>().filterCommunityList.isNotEmpty?Get.find<FilterController>().filterCommunityList:"",
                            appbar: true,
                          )));

              // Get.find<MatchesController>().getMatches('1',
              //     Get.find<ProfileController>().profile!.basicInfo!.gender!.contains('Male')
              //         ? "Female" :
              //     Get.find<ProfileController>().profile!.basicInfo!.gender!.contains('Female')
              //         ? "Male" :
              //     "Others",
              //     authControl.partnerReligion.toString(),
              //     authControl.partnerProfession.toString(),
              //     authControl.posselectedState.toString(),
              //     '',
              //     '',
              //     authControl.partnerMotherTongue.toString(),
              //     '');
              // Get.back();
            }),
          ),
        ),
        body: SingleChildScrollView(
          child: authControl.partReligionList == null ||
              authControl.partReligionList!.isEmpty ||
              authControl.partCommunityList == null ||
              authControl.partCommunityList!.isEmpty ||
              authControl.partProfessionList == null ||
              authControl.partProfessionList!.isEmpty ||
              authControl.partProfessionList == null ||
              authControl.partProfessionList!.isEmpty ||
              authControl.partMotherTongueList == null ||
              authControl.partMotherTongueList!.isEmpty ?
          Container(height: Get.size.height * 0.8,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius15)
              ),
              child: const Center(child: CircularProgressIndicator())) :
          GetBuilder<FilterController>(builder: (filterController) {
            final visibleCommunityChips = authControl.isExpanded
                ? authControl.partCommunityList
                : authControl.partCommunityList!.take(10).toList();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Preferred Matches",
                            style: styleSatoshiLight(size: 12, color: Colors.black),),
                          button(height: 24,
                              width: 80,
                              style: kManrope14Medium626262.copyWith(
                                  color: Colors.white),
                              context: context,
                              onTap: () {
                                Get.find<MatchesController>().getMatches('1',
                                    Get.find<ProfileController>().profile!.basicInfo!.gender!.contains('Male')
                                        ? "Female" :
                                    Get
                                        .find<ProfileController>()
                                        .profile!
                                        .basicInfo!
                                        .gender!
                                        .contains('Female')
                                        ? "Male" :
                                    "Others",
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                   "",
                                  "",
                                  "",
                                );
                                // Get.find<MatchesController>().getMatchesList(
                                //   "1",
                                //   profileControl.userDetails!.basicInfo!.gender!.contains("M") ? "F" : "M",
                                //   '', '', '', '', '', '', '',
                                // );
                                Get.back();
                              },
                              title: 'Clear All')
                        ],
                      )),
                  sizedBox16(),
                  Column(
                    children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Age Bracket ",
                              textAlign: TextAlign.left,
                              style: styleSatoshiBold(
                                  size: 16, color: Colors.black),),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Checkbox(value: isAge, onChanged:
                            (value) {
                              setState(() {
                                isAge = value!;
                              });
                            },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    // Text("Min Age", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                                    Text('${authControl.startValue.value.round().toString()} yrs',
                                      style: satoshiBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).primaryColor),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('${authControl.endValue.value.round().toString()} yrs',
                                      style: satoshiBold.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).primaryColor),),
                                  ],
                                ),
                              ],),
                            RangeSlider(
                              min: 20.0,
                              max: 60.0,
                              divisions: 30,
                              labels: RangeLabels(
                                authControl.startValue.value.round()
                                    .toString(),
                                authControl.endValue.value.round()
                                    .toString(),
                              ),
                              values: RangeValues(
                                authControl.startValue.value,
                                authControl.endValue.value,
                              ),
                              onChanged: (values) {
                                authControl.setAgeValue(values);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Height Bracket ",
                              textAlign: TextAlign.left,
                              style: styleSatoshiBold(size: 16, color: Colors.black),),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Checkbox(
                              value: isHeight, onChanged:
                                (value) {
                              setState(() {
                                isHeight = value!;
                              });
                            },
                            ),
                          ),
                        ],
                      ),
                      sizedBox12(),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('${_formatHeight(authControl.startHeightValue.value).toString()} Ft',
                                      style: satoshiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                          color: Theme.of(context).primaryColor),),
                                  ],
                                ),
                                Column(
                                  children: [
                                    // Text("Max Height", style: satoshiMedium.copyWith(fontSize: Dimensions.fontSizeDefault,)),
                                    Text(
                                      '${_formatHeight(authControl.endHeightValue.value).toString()} Ft',
                                      style: satoshiBold.copyWith(
                                          fontSize: Dimensions
                                              .fontSizeDefault,
                                          color: Theme
                                              .of(context)
                                              .primaryColor),),
                                  ],
                                ),
                              ],),
                            SizedBox(
                              width: double.infinity,
                              child:  HeightRangeSlider(
                                authControl:
                                authControl,
                                onChanged:
                                    (RangeValues
                                values)
                               {

                                 setState(() {
                                   _currentRangeValues =
                                       values;
                                 });
                                 authControl.setHeightValue(
                                     _currentRangeValues); // Update the values when slider changes
                                 print(
                                     'Updated range values: ${values
                                         .start.toStringAsFixed(
                                         0)} - ${values.end
                                         .toStringAsFixed(0)}');
                               },
                                values:
                                _currentRangeValues,
                                labels:  RangeLabels(
                                  _formatHeight(_currentRangeValues.start),
                                  _formatHeight(_currentRangeValues.end),
                                ),
                              ),



                              // Obx(() =>
                              //     RangeSlider(
                              //       min: 4.0,
                              //       // Minimum value
                              //       max: 7.0,
                              //       // Maximum value
                              //       divisions: 20,
                              //       // Number of divisions for finer granularity
                              //       labels: RangeLabels(
                              //         authControl.startHeightValue.value
                              //             .toStringAsFixed(1),
                              //         // Format to 1 decimal place
                              //         authControl.endHeightValue.value
                              //             .toStringAsFixed(
                              //             1), // Format to 1 decimal place
                              //       ),
                              //       values: RangeValues(
                              //         authControl.startHeightValue.value,
                              //         authControl.endHeightValue.value,
                              //       ),
                              //       onChanged: (values) {
                              //         authControl.setHeightValue(
                              //             values); // Update the values when slider changes
                              //         print(
                              //             'Updated range values: ${values
                              //                 .start.toStringAsFixed(
                              //                 1)} - ${values.end
                              //                 .toStringAsFixed(1)}');
                              //       },
                              //     )),
                            ),
                          ],
                        ),
                      ),
                      sizedBox16(),
                      FilterScreenField(
                        tap: () {
                          Get.to(FilterCategoryScreen(
                            filterType: 'Religions',));
                        },
                        title: 'Religions',
                        data: filterController.filterReligion.isEmpty ?
                        'Add Religion' :
                        '${filterController.filterReligion.join(', ')} ',
                      ),
                      sizedBox12(),
                      FilterScreenField(
                        tap: () {
                          Get.to(FilterCategoryScreen(
                            filterType: 'Community',));
                        },
                        title: 'Community',
                        data: filterController.filterCommunity.isEmpty ?
                        'Add Community' :
                        '${filterController.filterCommunity.join(', ')} ',
                      ),
                      sizedBox12(),
                      FilterScreenField(
                        tap: () {
                          Get.to(FilterCategoryScreen(
                            filterType: 'MotherTongue',));
                        },
                        title: 'MotherTongue',
                        data: filterController.filterMotherTongue.isEmpty
                            ?
                        'Add Mother Tongue'
                            :
                        '${filterController.filterMotherTongue.join(
                            ', ')} ',
                      ),
                      sizedBox12(),
                      FilterScreenField(
                        tap: () {
                          Get.to(FilterCategoryScreen(
                            filterType: 'Profession',));
                        },
                        title: 'Profession',
                        data: filterController.filterProfession.isEmpty ?
                        'Add Profession' :
                        '${filterController.filterProfession.join(
                            ', ')} ',
                      ),

                      sizedBox12(),
                      FilterScreenField(
                        tap: () {
                          Get.to(FilterCategoryScreen(
                            filterType: 'State',));
                        },
                        title: 'State',
                        data: authControl.filterPostingState.isEmpty ?
                        'Add State' :
                        '${authControl.filterPostingState.join(', ')} ',
                      ),


                    ],
                  ),

                ],
              ),
            );
          }),

        ),
      );}
    );
  }
}



