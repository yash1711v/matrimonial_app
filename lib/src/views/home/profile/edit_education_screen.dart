import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/data/response/profile_model.dart';
import 'package:bureau_couple/getx/features/widgets/custom_dropdown_button_field.dart';
import 'package:bureau_couple/getx/features/widgets/edit_details_textfield.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/src/constants/colors.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/models/profie_model.dart';
import 'package:bureau_couple/src/utils/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../apis/profile_apis/education_info_api.dart';
import '../../../apis/profile_apis/get_profile_api.dart';
import '../../../constants/assets.dart';
import '../../../constants/string.dart';
import '../../../constants/textstyles.dart';
import '../../../models/education_info_model.dart';
import '../../../utils/widgets/common_widgets.dart';
import '../../../utils/widgets/customAppbar.dart';
import '../../../utils/widgets/loader.dart';
import '../../../utils/widgets/name_edit_dialog.dart';
import '../../../utils/widgets/textfield_decoration.dart';
import 'package:get/get.dart';

class EditEducationScreen extends StatefulWidget {
  const EditEducationScreen({super.key});

  @override
  State<EditEducationScreen> createState() => _EditEducationScreenState();
}

class _EditEducationScreenState extends State<EditEducationScreen> {
  bool isLoading = false;

  List<String> fieldNames = []; // Initial constant fields
  Map<String, TextEditingController> controllers = {};


  @override
  void initState() {
    educationInfo();
    super.initState();
    for (var name in fieldNames) {
      controllers[name] = TextEditingController();
    }
  }
  void showAddFieldDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Field"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Enter field name"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                String newFieldName = nameController.text.trim();
                if (newFieldName.isNotEmpty) {
                  setState(() {
                    fieldNames.add(newFieldName);
                    controllers[newFieldName] = TextEditingController();
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  List<EducationInfo> educationDetails = [];

  educationInfo() {
    isLoading = true;
    var resp = getProfileApi();
    resp.then((value) {
      educationDetails.clear();
      if (value['status'] == true) {
        setState(() {
          // profile = ProfileModel.fromJson(value);
          for (var v in value['data']['user']['education_info']) {
            educationDetails.add(EducationInfo.fromJson(v));
          }
          fields();
          // print(career.length);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  final instituteController = TextEditingController();
  final degreeController = TextEditingController();
  final universityController = TextEditingController();
  final fieldOfStudyController = TextEditingController();
  final registrationNoController = TextEditingController();
  final rollNoController = TextEditingController();
  final startingYearController = TextEditingController();
  final endingYearController = TextEditingController();
  final resultController = TextEditingController();
  final outOfController = TextEditingController();
  final _highestDegreeIdController = TextEditingController();

  void fields() {
    degreeController.text = educationDetails[0].degree.toString() ?? '';
    fieldOfStudyController.text =
        educationDetails[0].fieldOfStudy.toString() ?? '';
    universityController.text = educationDetails[0].institute.toString() ?? '';
    // _highestDegreeIdController.text = educationDetails[0].
  }

  bool loading = false;
  List<String> selectedItems = [];
  String selectedItemId = '';// Controllers for TextFields



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (educationController) {
      return GetBuilder<AuthController>(builder: (authControl) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Education Info",
            menuWidget:
                IconButton(onPressed: () {
                  debugPrint("Menu pressed");
                  showAddFieldDialog();
                }, icon: const Icon(Icons.add)),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: educationController.isEducationLoading
                  ? loadingElevatedButton(context: context, color: primaryColor)
                  : button(
                      context: context,
                      onTap: () {
                        educationController.editEducationInfoApi(
                            'educationInfo',
                            educationDetails[0].id.toString(),
                            degreeController.text,
                            fieldOfStudyController.text,
                            universityController.text);
                        Get.back();
                      },
                      title: "Save"),
            ),
          ),
          body: isLoading
              ? const Loading()
              : CustomRefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      isLoading = true;
                    });
                    return educationInfo();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: [
                          educationDetails.isEmpty || educationDetails == null
                              ? Center(
                                  child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return EditDialogWidget(
                                                  addTextField: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Education",
                                                    style: styleSatoshiBold(
                                                        size: 18,
                                                        color: Colors.black),
                                                  ),
                                                  sizedBox16(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint: 'University',
                                                            controller:
                                                                instituteController),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint: 'Degress',
                                                            controller:
                                                                degreeController),
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox10(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint:
                                                                'Field Of Study',
                                                            controller:
                                                                fieldOfStudyController),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint:
                                                                'Registration No',
                                                            controller:
                                                                registrationNoController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox10(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint: 'Roll No',
                                                            controller:
                                                                rollNoController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint:
                                                                'Starting year',
                                                            controller:
                                                                startingYearController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox10(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint: 'Ending Year',
                                                            controller:
                                                                endingYearController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                      const SizedBox(
                                                        width: 6,
                                                      ),
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint:
                                                                'Result in no',
                                                            controller:
                                                                resultController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox10(),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: buildTextFormField(
                                                            context,
                                                            hint: 'Out of',
                                                            controller:
                                                                outOfController,
                                                            keyboard:
                                                                TextInputType
                                                                    .number),
                                                      ),
                                                    ],
                                                  ),
                                                  sizedBox16(),
                                                  loading
                                                      ? loadingElevatedButton(
                                                          context: context,
                                                          color: primaryColor)
                                                      : elevatedButton(
                                                          color: primaryColor,
                                                          context: context,
                                                          onTap: () {
                                                            setState(() {
                                                              loading = true;
                                                            });
                                                            Get.back();

                                                            educationInfoAddApi(
                                                                    institute:
                                                                        instituteController
                                                                            .text,
                                                                    degree:
                                                                        degreeController
                                                                            .text,
                                                                    fieldOfStudy:
                                                                        fieldOfStudyController
                                                                            .text,
                                                                    regNO:
                                                                        resultController
                                                                            .text,
                                                                    start:
                                                                        startingYearController
                                                                            .text,
                                                                    end: endingYearController
                                                                        .text,
                                                                    result:
                                                                        resultController
                                                                            .text,
                                                                    outOf:
                                                                        outOfController
                                                                            .text,
                                                                    rollNo:
                                                                        rollNoController
                                                                            .text)
                                                                .then((value) {
                                                              /*  setState(() {
                                              });*/
                                                              if (value[
                                                                      'status'] ==
                                                                  true) {
                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });
                                                                ToastUtil.showToast(
                                                                    "Updated Successfully");
                                                                instituteController
                                                                    .clear();
                                                                degreeController
                                                                    .clear();
                                                                fieldOfStudyController
                                                                    .clear();
                                                                resultController
                                                                    .clear();
                                                                startingYearController
                                                                    .clear();
                                                                degreeController
                                                                    .clear();
                                                                endingYearController
                                                                    .clear();
                                                                resultController
                                                                    .clear();
                                                                outOfController
                                                                    .clear();
                                                                rollNoController
                                                                    .clear();
                                                              } else {
                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });
                                                                List<dynamic>
                                                                    errors =
                                                                    value['message']
                                                                        [
                                                                        'error'];
                                                                String
                                                                    errorMessage =
                                                                    errors.isNotEmpty
                                                                        ? errors[
                                                                            0]
                                                                        : "An unknown error occurred.";
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            errorMessage);
                                                              }
                                                            });
                                                          },
                                                          title: "Save")
                                                ],
                                              ));
                                            });
                                          },
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 50.0),
                                        child: DottedPlaceHolder(
                                            text: "Add Education Info"),
                                      )))
                              : Column(
                            children: [
                              for(int i = 0; i < educationDetails.length; i++)
                            Container(
                              width: double.infinity,
                              height: 230,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                                child: Column(
                                  children: [
                                    EditDetailsTextField(
                                        title: 'University / institute',
                                        controller: universityController),
                                    sizedBox6(),
                                    EditDetailsTextField(
                                      title: 'Highest Degree',
                                      controller: degreeController,
                                      readOnly: true,
                                      onTap: () {
                                        Get.bottomSheet(
                                          SingleChildScrollView(
                                            child: Container(
                                              color: Theme.of(context).cardColor,
                                              padding: const EdgeInsets.all(
                                                  Dimensions.paddingSizeDefault),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Highest Degree',
                                                    style: kManrope25Black.copyWith(
                                                        fontSize: 16),
                                                  ),
                                                  sizedBox12(),
                                                  CustomDropdownButtonFormField<String>(
                                                    value: authControl.highestDegree,
                                                    items: authControl.highestDegreeList,
                                                    hintText: "Select Highest Degree",
                                                    onChanged: (String? value) {
                                                      authControl
                                                          .setHighestDegree(value!);
                                                      degreeController.text = value;
                                                      print(authControl.highestDegree);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    sizedBox6(),
                                    EditDetailsTextField(
                                        title: 'Field of Study',
                                        controller: fieldOfStudyController),
                                    sizedBox6(),
                                    Visibility(
                                      visible: fieldNames.isNotEmpty && fieldNames.length > 0,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: fieldNames.length,
                                          itemBuilder: (_, i){

                                            return EditDetailsTextField(
                                              title: fieldNames[i],
                                              controller: controllers[fieldNames[i]] ?? TextEditingController(),
                                            );

                                          }),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],)


                          // ListView.builder(
                          //     physics: const NeverScrollableScrollPhysics(),
                          //     shrinkWrap: true,
                          //     itemCount: 1,
                          //     itemBuilder: (_,i) {
                          //       return GestureDetector(
                          //         behavior: HitTestBehavior.translucent,
                          //         // onLongPress: () {
                          //         //   setState(() {
                          //         //     selectedItemId = educationDetails[i].id.toString(); // Set the ID of the selected item
                          //         //   });
                          //         // },
                          //         child: Column(
                          //           children: [
                          //             buildListRow(title: 'University / institute', data1: StringUtils.capitalize(universityController.text), tap: () {
                          //               showDialog(
                          //                 context: context,
                          //                 builder: (BuildContext context) {
                          //                   return NameEditDialogWidget(
                          //                     title: 'University / institute ',
                          //                     addTextField: TextFormField(
                          //                       maxLength: 40,
                          //                       onChanged: (v) {
                          //                         setState(() {
                          //
                          //                         });
                          //                       },
                          //                       onEditingComplete: () {
                          //                         Navigator.pop(context); // Close the dialog
                          //                       },
                          //                       controller: universityController,
                          //                       decoration: AppTFDecoration(
                          //                           hint: 'University / institute').decoration(),
                          //                       //keyboardType: TextInputType.phone,
                          //                     ),
                          //                   );
                          //                 },
                          //               );
                          //             }, ),
                          //             const Divider(),
                          //             sizedBox10(),
                          //             buildListRow(title: 'Highest Degree', data1:  StringUtils.capitalize(
                          //                 degreeController.text), tap: () {
                          //               Get.bottomSheet(
                          //                 SingleChildScrollView(
                          //                   child: Container(color: Theme.of(context).cardColor,
                          //                     padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          //                     child: Column(
                          //                       children: [
                          //                         Text(
                          //                           'Highest Degree',
                          //                           style: kManrope25Black.copyWith(fontSize: 16),
                          //                         ),
                          //                         sizedBox12(),
                          //                         CustomDropdownButtonFormField<String>(
                          //                           value: authControl.highestDegree ,
                          //                           items: authControl.highestDegreeList,
                          //                           hintText: "Select Highest Degree",
                          //                           onChanged: (String ? value) {
                          //                             authControl.setHighestDegree(value!);
                          //                             degreeController.text = value;
                          //                             print(authControl.highestDegree);
                          //                           },
                          //
                          //                         ),
                          //                       ],
                          //                     ),),
                          //                 ),
                          //               );
                          //             }, ),
                          //             const Divider(),
                          //             sizedBox10(),
                          //             buildListRow(title: 'Field Of Study', data1: StringUtils.capitalize(fieldOfStudyController.text), tap: () {
                          //               showDialog(
                          //                 context: context,
                          //                 builder: (BuildContext context) {
                          //                   return NameEditDialogWidget(
                          //                     title: 'Field Of Study ',
                          //                     addTextField: TextFormField(
                          //                       maxLength: 40,
                          //                       onChanged: (v) {
                          //                         setState(() {
                          //
                          //                         });
                          //                       },
                          //                       onEditingComplete: () {
                          //                         Navigator.pop(context); // Close the dialog
                          //                       },
                          //                       controller: fieldOfStudyController,
                          //                       decoration: AppTFDecoration(
                          //                           hint: 'Field Of Study').decoration(),
                          //                       //keyboardType: TextInputType.phone,
                          //                     ),
                          //                   );
                          //                 },
                          //               );
                          //             }, ),
                          //             const Divider(),
                          //             sizedBox10(),
                          //             // buildListRow(title: 'Registration No', data1: educationDetails[i].regNo.toString(), ),
                          //             // sizedBox6(),
                          //             // buildListRow(title: 'Roll No', data1: educationDetails[i].rollNo.toString(), ),
                          //             // sizedBox6(),
                          //             // buildListRow(title: 'Starting Year', data1: educationDetails[i].start.toString(), ),
                          //             // sizedBox6(),
                          //             // buildListRow(title: 'Ending Year', data1: educationDetails[i].end.toString(), ),
                          //             // sizedBox6(),
                          //             // buildListRow(title: 'Result',
                          //             //   data1: double.parse(educationDetails[i].result.toString()).toStringAsFixed(0),),
                          //             // sizedBox6(),
                          //             // buildListRow(title: 'Out of',
                          //             //   data1: double.parse(educationDetails[i].outOf.toString()).toStringAsFixed(0),),
                          //
                          //
                          //           ],
                          //         ),
                          //       );
                          //       // return customCard(
                          //       //   child: GestureDetector(
                          //       //     behavior: HitTestBehavior.translucent,
                          //       //     // onLongPress: () {
                          //       //     //   setState(() {
                          //       //     //     selectedItemId = educationDetails[i].id.toString(); // Set the ID of the selected item
                          //       //     //   });
                          //       //     // },
                          //       //     child: Column(
                          //       //       children: [
                          //       //         buildListRow(title: 'University / institute', data1: StringUtils.capitalize(educationDetails[i].institute.toString()), ),
                          //       //         sizedBox6(),
                          //       //         buildListRow(title: 'Degree', data1:  StringUtils.capitalize(educationDetails[i].degree.toString()), ),
                          //       //         sizedBox6(),
                          //       //         buildListRow(title: 'Field Of Study', data1: StringUtils.capitalize(educationDetails[i].fieldOfStudy.toString()), ),
                          //       //         sizedBox6(),
                          //       //         // buildListRow(title: 'Registration No', data1: educationDetails[i].regNo.toString(), ),
                          //       //         // sizedBox6(),
                          //       //         // buildListRow(title: 'Roll No', data1: educationDetails[i].rollNo.toString(), ),
                          //       //         // sizedBox6(),
                          //       //         // buildListRow(title: 'Starting Year', data1: educationDetails[i].start.toString(), ),
                          //       //         // sizedBox6(),
                          //       //         // buildListRow(title: 'Ending Year', data1: educationDetails[i].end.toString(), ),
                          //       //         // sizedBox6(),
                          //       //         // buildListRow(title: 'Result',
                          //       //         //   data1: double.parse(educationDetails[i].result.toString()).toStringAsFixed(0),),
                          //       //         // sizedBox6(),
                          //       //         // buildListRow(title: 'Out of',
                          //       //         //   data1: double.parse(educationDetails[i].outOf.toString()).toStringAsFixed(0),),
                          //       //
                          //       //
                          //       //       ],
                          //       //     ),
                          //       //   ), tap: () {
                          //       //
                          //       //
                          //       // },
                          //       //   borderColor:  selectedItemId == educationDetails[i].id.toString()
                          //       //       ? Colors.red
                          //       //       : Colors.grey,
                          //       // );
                          //     }),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      });
    });
  }

  InkWell buildListRow({
    required String title,
    required String data1,
    required Function() tap,
  }) {
    return InkWell(
      onTap: tap,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '${title} ',
                ),
                const Icon(
                  Icons.edit,
                  size: 14,
                )
              ],
            ),
          ),
          Expanded(
            // flex: 3,
            child: SizedBox(
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data1,
                    maxLines: 4,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildDataAddRow({
    required String title,
    required String data1,
    required String data2,
    required bool isControllerTextEmpty,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
          ),
        ),
        isControllerTextEmpty
            ? Expanded(
                // flex: 3,
                child: SizedBox(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        data1,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data2,
                      maxLines: 4,
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: backButton(
            context: context,
            image: icArrowLeft,
            onTap: () {
              Navigator.pop(context);
            }),
      ),
      title: Text(
        "Education",
        style: styleSatoshiBold(size: 18, color: Colors.black),
      ),
      // actions: [
      //   selectedItemId.isNotEmpty ?
      //   GestureDetector(
      //     behavior: HitTestBehavior.translucent,
      //     onTap: () {
      //       educationInfoDeleteApi(id: selectedItemId
      //          ).then((value) {
      //         setState(() {
      //         });
      //         if (value['status'] == true) {
      //           setState(() {
      //             loading = false;
      //             isLoading  ?  const Loading() :  educationInfo();
      //           });
      //
      //           // isLoading ? Loading() :careerInfo();
      //           // Navigator.push(context, MaterialPageRoute(builder: (builder) =>
      //           // const KycWaitScreen()));
      //
      //           // ToastUtil.showToast("Login Successful");
      //
      //           ToastUtil.showToast("Deleted Successfully");
      //
      //         } else {
      //           setState(() {
      //             loading = false;
      //           });
      //
      //
      //           List<dynamic> errors = value['message']['error'];
      //           String errorMessage = errors.isNotEmpty ? errors[0] : "An unknown error occurred.";
      //           Fluttertoast.showToast(msg: errorMessage);
      //         }
      //       });
      //     },
      //       child:const  Icon(Icons.delete)) :
      //     const  SizedBox(),
      //   GestureDetector(
      //     onTap: () {
      //
      //       showDialog(
      //         context: context,
      //         builder: (BuildContext context) {
      //           return StatefulBuilder(
      //             builder: (BuildContext context, StateSetter setState) {
      //               return EditDialogWidget(
      //                   addTextField: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text("Education",
      //                         style: styleSatoshiBold(size: 18, color: Colors.black),),
      //                       sizedBox16(),
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'University / institute', controller: instituteController),
      //                           ),
      //                           const SizedBox(width: 6,),
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Degress', controller: degreeController),
      //                           ),
      //                         ],
      //                       ),
      //                       sizedBox10(),
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Field Of Study', controller: fieldOfStudyController),
      //                           ),
      //                           const SizedBox(width: 6,),
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Registration No',
      //                                 controller: registrationNoController,
      //                                 keyboard: TextInputType.number
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       sizedBox10(),
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Roll No', controller: rollNoController,
      //                                 keyboard: TextInputType.number),
      //                           ),
      //                           const SizedBox(width: 6,),
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Starting year', controller: startingYearController,
      //                                 keyboard: TextInputType.number),
      //                           ),
      //                         ],
      //                       ),
      //                       sizedBox10(),
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Ending Year', controller: endingYearController,
      //                                 keyboard: TextInputType.number),
      //                           ),
      //                           const SizedBox(width: 6,),
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Result in no', controller: resultController,
      //                                 keyboard: TextInputType.number),
      //                           ),
      //                         ],
      //                       ),
      //                       sizedBox10(),
      //                       Row(
      //                         children: [
      //                           Expanded(
      //                             child: buildTextFormField(context, hint: 'Out of', controller: outOfController,
      //                                 keyboard: TextInputType.number),
      //                           ),
      //
      //                         ],
      //                       ),
      //                       sizedBox16(),
      //                       loading ?
      //                       loadingElevatedButton(context: context,
      //                       color: primaryColor):
      //                       elevatedButton(
      //                           color: primaryColor,
      //                           context: context, onTap: () {
      //
      //
      //                    /*     setState(() {
      //                           loading =true;
      //                         });
      //                         educationInfoAddApi(
      //                             institute: instituteController.text,
      //                             degree: degreeController.text,
      //                             fieldOfStudy: fieldOfStudyController.text,
      //                             regNO: resultController.text,
      //                             start: startingYearController.text,
      //                             end: endingYearController.text,
      //                             result: resultController.text,
      //                             outOf: outOfController.text,
      //                             rollNo: rollNoController.text).then((value) {
      //                           setState(() {
      //                           });
      //                           if (value['status'] == true) {
      //
      //
      //                             setState(() {
      //                               loading = false;
      //                             });
      //                             instituteController.clear();
      //                             degreeController.clear();
      //                             fieldOfStudyController.clear();
      //                             resultController.clear();
      //                             startingYearController.clear();
      //                             endingYearController.clear();
      //                             resultController.clear();
      //                             outOfController.clear();
      //                             rollNoController.clear();
      //                             Navigator.pop(context);
      //                             ToastUtil.showToast("Updated Successfully");
      //
      //                           } else {
      //                             setState(() {
      //                               loading = false;
      //                             });
      //
      //
      //                             List<dynamic> errors = value['message']['error'];
      //                             String errorMessage = errors.isNotEmpty ? errors[0] : "An unknown error occurred.";
      //                             Fluttertoast.showToast(msg: errorMessage);
      //                           }
      //                         });*/
      //                       }, title: "Save")
      //                     ],
      //                   )
      //               );
      //           }
      //           );
      //         },
      //       );
      //
      //
      //     },
      //     child: const Padding(
      //       padding:  EdgeInsets.only(right: 16.0),
      //       child: Icon(Icons.add),
      //     ),
      //   )
      // ],
    );
  }

  TextFormField buildTextFormField(
    BuildContext context, {
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      keyboardType: keyboard ?? TextInputType.name,
      textInputAction: TextInputAction.next,

      inputFormatters: [
        LengthLimitingTextInputFormatter(40),
      ],
      onChanged: (v) {
        setState(() {});
      },
      onEditingComplete: () {
        // Navigator.pop(context); // Close the dialog
      },
      controller: controller,
      decoration: AppTFDecoration(hint: hint).decoration(),
      //keyboardType: TextInputType.phone,
    );
  }
}
