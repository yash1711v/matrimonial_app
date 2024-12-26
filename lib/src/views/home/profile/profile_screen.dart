import 'dart:developer';
import 'dart:io';

import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/controllers/profile_controller.dart';
import 'package:bureau_couple/getx/data/response/profile_model.dart';
import 'package:bureau_couple/getx/features/screens/interest/edit_interest_screen.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/styles.dart';
import 'package:bureau_couple/src/constants/fonts.dart';
import 'package:bureau_couple/src/constants/shared_prefs.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/models/interest_model.dart';
import 'package:bureau_couple/src/utils/urls.dart';
import 'package:bureau_couple/src/utils/widgets/common_widgets.dart';
import 'package:bureau_couple/src/utils/widgets/customAppbar.dart';
import 'package:bureau_couple/src/utils/widgets/custom_image_widget.dart';
import 'package:bureau_couple/src/views/home/profile/edit_career_info.dart';
import 'package:bureau_couple/src/views/home/profile/edit_education_screen.dart';
import 'package:bureau_couple/src/views/home/profile/edit_physical_atributes.dart';
import 'package:bureau_couple/src/views/signIn/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../apis/login/login_api.dart';
import '../../../apis/profile_apis/get_profile_api.dart';
import '../../../apis/profile_apis/images_apis.dart';
import '../../../constants/assets.dart';
import '../../../constants/colors.dart';
import '../../../constants/textstyles.dart';
import '../../../models/images_model.dart';
import '../../../utils/widgets/buttons.dart';
import '../../../utils/widgets/custom_dialog.dart';
import '../../../utils/widgets/hobbies_widget.dart';
import '../../../utils/widgets/pop_up_menu_button.dart';
import 'change_password_sheet.dart';
import 'edit_basic_info.dart';
import 'edit_preferred_matches.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Set<String>? userHobbies = {};
  Interest interests = Interest(interestName: "", hobbies: []);

  @override
  void initState() {
    Get.find<AuthController>().getReligionsList();
    profileDetail();
    getImage();
    super.initState();
  }

  File pickedImage = File("");
  final ImagePicker _imgPicker = ImagePicker();
  bool isLoading = false;
  ProfileModel profile = ProfileModel();

  profileDetail() {
    setState(() {
      isLoading = true;
    });

    var resp = getProfileApi();
    resp.then((value) {
      if (value['status'] == true) {
        if (mounted) {
          setState(() {
            var profileData = value['data']['user'];
            // interests = Interest.fromJson(value['data']['user']["interest"]);
            log("user: ${value['data']['user']}");
            if (profileData != null) {
              profile = ProfileModel.fromJson(profileData);
              print(profile.id);
              print(profile.firstname);
              Get.find<AuthController>()
                  .selectInterestList(profile.interest ?? []);
              profile.interest!.forEach((element) {
                element.hobbies!.forEach((hobbies) {
                  setState(() {
                    userHobbies!.add(hobbies);
                  });
                });
              });
              SharedPrefs().setProfilePhoto(profile.image.toString());
            }
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      // Handle error
      print("Error fetching profile: $error");
    });
  }

  //
  List<PhotosModel> photos = [];

  void getImage() {
    setState(() {
      isLoading = true;
    });

    var resp = getImagesApi();
    resp.then((value) {
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        isLoading = false;
        photos.clear();
        if (value['status'] == true) {
          List<dynamic> data = value['data'];
          for (var obj in data) {
            List<dynamic> galleries = obj['galleries'];
            for (var gallery in galleries) {
              photos.add(PhotosModel.fromJson(gallery));
            }
          }
        }
      });
    });
  }

  Future<void> refreshData() async {
    profileDetail();
    getImage();
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final aboutController = TextEditingController();
  final educationController = TextEditingController();
  final designationController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();
  final marriedController = TextEditingController();
  final livesInController = TextEditingController();
  final childrenController = TextEditingController();
  final religionController = TextEditingController();
  final communityController = TextEditingController();
  final motherTongueController = TextEditingController();
  final gotraController = TextEditingController();
  final dietController = TextEditingController();

  bool loading = false;


  String positionName(CareerInfo career){
    String selected = "";
     ( Get.find<AuthController>().professionList ?? [])
          .forEach((element){
            // debugPrint("element.id: ${element.id}");
            // debugPrint("career.position: ${career.position}");
        if(element.id == career.position){
          selected = element.name ?? "";
          // debugPrint("selected: $selected");
        }
      });
      // debugPrint("selected: $selected");
    return selected;
  }

  @override
  Widget build(BuildContext context) {
   // debugPrint("userHobbies: $userHobbies");
    return Scaffold(
      appBar: CustomAppBar2(
        title: "Profile",
        menuWidget: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: backButton(
              context: context,
              image: settings,
              onTap: () async {
                final result = await showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(20, 40, 0, 0),
                  // Adjust the position as needed
                  items: [
                    PopupMenuItem<String>(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteAccountDialog(
                                titleButton1: 'Cancel',
                                click1: () {},
                                click2: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const SignInScreen()));
                                },
                                heading: 'Delete this Account?',
                                subheading: 'Are You Sure You? Want to Delete',
                                mainButton: elevatedButton(
                                    height: 38,
                                    color: Colors.red,
                                    context: context,
                                    onTap: () {},
                                    title: 'Delete Account',
                                    style: styleSatoshiLight(
                                        size: 14, color: Colors.white)),
                              );
                            });
                      },
                      value: 'Delete Account',
                      child: const Text('Delete Account'),
                    ),
                    PopupMenuItem<String>(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const ChangePassSheet();
                          },
                        );
                      },
                      value: 'Change Password',
                      child: const Text('Change Password'),
                    ),
                    PopupMenuItem<String>(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return DeleteAccountDialog(
                                  titleButton1: 'Back',
                                  click1: () {
                                    Navigator.pop(context);
                                  },
                                  click2: () {
                                    Navigator.pop(context);
                                  },
                                  heading: 'Confirm Logout',
                                  subheading:
                                      'Are you sure you want to Logout?',
                                  mainButton: loading
                                      ? loadingElevatedButton(
                                          height: 38,
                                          color: Colors.red,
                                          context: context,
                                        )
                                      : elevatedButton(
                                          height: 38,
                                          color: Colors.red,
                                          context: context,
                                          onTap: () {
                                            setState(() {
                                              loading = true;
                                            });

                                            logOutApi().then((value) {
                                              setState(() {});

                                              if (value['status'] == 'ok') {
                                                setState(() {
                                                  loading = false;
                                                });
                                                SharedPrefs().setLoginFalse();

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            const SignInScreen()));

                                                ToastUtil.showToast(
                                                    "Logout Successfully");
                                              } else {
                                                setState(() {
                                                  loading = false;
                                                });

                                                List<dynamic>? errors =
                                                    value['message']['error'];
                                                String errorMessage = errors
                                                            ?.isNotEmpty ==
                                                        true
                                                    ? errors![0]
                                                    : "An unknown error occurred.";
                                                Fluttertoast.showToast(
                                                    msg: errorMessage);
                                              }
                                            });
                                          },
                                          title: 'Logout Account',
                                          style: styleSatoshiLight(
                                              size: 14, color: Colors.white),
                                        ),
                                );
                              },
                            );
                          },
                        );
                      },
                      value: 'Logout',
                      child: const Text('Logout'),
                    ),
                  ],
                );

                if (result != null) {
                  print('Selected: $result');
                }
              }),
        ),
      ),
      body: isLoading || profile.partnerExpectation == null || profile == null
          ? const BasicInfoShimmerWidget()
          : Stack(
              children: [
                CustomRefreshIndicator(
                  onRefresh: () {
                    setState(() {
                      isLoading = true;
                    });
                    return refreshData();
                  },
                  child: GetBuilder<ProfileController>(
                      builder: (profileController) {
                        log("${profile
                            .basicInfo?.maritalStatus}", name: "Marital Status");
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipOval(
                                  child: CustomImageWidget(
                                image: profile.image != null
                                    ? '$baseProfilePhotoUrl${profile.image}'
                                    : 'fallback_image_url_here',
                                height: 100,
                                width: 100,
                              )),
                            ),
                            sizedBox10(),
                            Container(
                              width: double.infinity,
                              height: 660,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Basic Details',
                                          style: kManrope25Black.copyWith(
                                              fontSize: Dimensions.fontSize18,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.65)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        EditBasicInfoScreen(
                                                          photos: photos,
                                                        )));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildInfoRow(
                                        title: 'About',
                                        text: profile.basicInfo?.aboutUs ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'First Name',
                                        text: profile.firstname ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Last Name',
                                        text: profile.lastname ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Username',
                                        text: profile.username ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Profession',
                                        text:
                                            profile.basicInfo?.professionName ??
                                                '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Email',
                                        text: profile.email ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Mobile no',
                                        text: profile.mobile ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Date of Birth',
                                        text:
                                            profile.basicInfo?.birthDate ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Gender',
                                        text: profile.basicInfo?.gender ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Religion',
                                        text: profile.basicInfo?.religionName ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Smoking habit',
                                        text: profile.basicInfo?.smokingName ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Drinking habit',
                                        text: profile.basicInfo?.drinkingName ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Community',
                                        text:
                                            profile.basicInfo?.communityName ??
                                                '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Diet',
                                        text: profile.basicInfo?.diet ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Annual Income',
                                        text: profile.basicInfo
                                                ?.financialCondition ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Mother Tongue',
                                        text: profile
                                                .basicInfo?.motherTongueName ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'State',
                                        text: profile.basicInfo?.presentAddress!
                                                .state ??
                                            '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Disability',
                                        text:
                                            profile.basicInfo?.disability ?? '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Marital Status',
                                        text: profile
                                                    .basicInfo?.maritalStatus ==
                                                "1"
                                            ? "Unmarried"
                                            : profile.basicInfo
                                                        ?.maritalStatus ==
                                                    "2"
                                                ? "Widow"
                                                : profile.basicInfo
                                                            ?.maritalStatus ==
                                                        "3"
                                                    ? "Divorce"
                                                    : "Widower",
                                        onTap: () {}),
                                  ],
                                ),
                              ),
                            ),
                            sizedBox10(),
                            Container(
                              width: double.infinity,
                              // height: 110,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Education Details',
                                          style: kManrope25Black.copyWith(
                                              fontSize: Dimensions.fontSize18,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.65)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const EditEducationScreen()));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for(int i = 0; i < profile.educationInfo!.length; i++)
                                    Column(
                                      children: [
                                        buildInfoRow(
                                          title: 'Degree',
                                          text:
                                          profile.educationInfo?.isEmpty ?? true
                                              ? ""
                                              : profile.educationInfo![i].degree
                                              .toString() ??
                                              "",
                                          onTap: () {},
                                        ),
                                        buildInfoRow(
                                          title: 'Study',
                                          text:
                                          profile.educationInfo?.isEmpty ?? true
                                              ? ""
                                              : profile.educationInfo?[i]
                                              .fieldOfStudy
                                              ?.toString() ??
                                              "",
                                          onTap: () {},
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            sizedBox10(),
                            Container(
                              width: double.infinity,
                              // height: 110,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Career Info',
                                          style: kManrope25Black.copyWith(
                                              fontSize: Dimensions.fontSize18,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.65)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const EditCareerInfoScreen()));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for(int i = 0; i < profile.careerInfo!.length; i++)
                                    Column(
                                      children: [
                                        buildInfoRow(
                                          title: 'Position',
                                          text: profile.careerInfo?[i].position
                                              ?.toString().isEmpty ??
                                              true
                                              ? ""
                                              : positionName(profile.careerInfo![i])
                                              .toString() ??
                                              "",
                                          onTap: () {},
                                        ),
                                        buildInfoRow(
                                          title: 'State Of Posting',
                                          text: profile.careerInfo?.isEmpty ?? true
                                              ? ""
                                              : profile.careerInfo?[0].statePosting
                                              ?.toString() ??
                                              "",
                                          onTap: () {},
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            sizedBox10(),
                            Container(
                              width: double.infinity,
                              height: 220,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Physical Attributes',
                                          style: kManrope25Black.copyWith(
                                              fontSize: Dimensions.fontSize18,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.65)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const EditPhysicalAttributesScreen()));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildInfoRow(
                                        title: 'Height',
                                        text: profileController
                                                .convertHeightToFeetInches(
                                                    profile.physicalAttributes!
                                                        .height
                                                        .toString()) ??
                                            "",
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Weight',
                                        text:
                                            '${profile.physicalAttributes?.weight?.split('.')[0] ?? ""} Kg',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Blood Group',
                                        text: profile
                                                .physicalAttributes?.bloodGroup
                                                .toString() ??
                                            "",
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Eye Color',
                                        text: profile
                                                .physicalAttributes?.eyeColor
                                                .toString() ??
                                            "",
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Hair Color',
                                        text: profile
                                                .physicalAttributes?.hairColor
                                                .toString() ??
                                            "",
                                        onTap: () {}),
                                  ],
                                ),
                              ),
                            ),
                            sizedBox10(),
                            Container(
                              width: double.infinity,
                              height: 270,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Partner Expectations',
                                          style: kManrope25Black.copyWith(
                                              fontSize: Dimensions.fontSize18,
                                              color: Theme.of(context)
                                                  .primaryColorDark
                                                  .withOpacity(0.65)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const EditPreferenceScreen()));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .primaryColorDark
                                                .withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                    buildInfoRow(
                                        title: 'Religion',
                                        text: /*profile.data?.user?.partnerExpectation!.religion.toString() ?? "",*/
                                            profile.partnerExpectation == null
                                                ? ""
                                                : profile.partnerExpectation!
                                                            .religionName
                                                            .take(
                                                                3) // Take the first 3 elements
                                                            .map((religion) =>
                                                                religion[0]
                                                                    .toUpperCase() +
                                                                religion
                                                                    .substring(
                                                                        1)
                                                                    .toLowerCase())
                                                            .join(', ') +
                                                        (profile
                                                                    .partnerExpectation!
                                                                    .religionName
                                                                    .length >
                                                                3
                                                            ? ' ..'
                                                            : '') ??
                                                    '',
                                        onTap: () {}),
                                    buildInfoRow(
                                        title: 'Profession',
                                        text: /*profile.data?.user?.partnerExpectation!.profession.toString() ?? "",*/
                                            profile.partnerExpectation == null
                                                ? ""
                                                : profile.partnerExpectation!
                                                            .professionName
                                                            .take(
                                                                3) // Take the first 3 elements
                                                            .map((religion) =>
                                                                religion[0]
                                                                    .toUpperCase() +
                                                                religion
                                                                    .substring(
                                                                        1)
                                                                    .toLowerCase())
                                                            .join(', ') +
                                                        (profile
                                                                    .partnerExpectation!
                                                                    .professionName
                                                                    .length >
                                                                3
                                                            ? ' ..'
                                                            : '') ??
                                                    '',
                                        onTap: () {}),
                                    buildInfoRow(
                                      title: 'Mother Tongue',
                                      text: profile.partnerExpectation
                                                  ?.motherTongueName
                                                  .take(
                                                      3) // Take the first 3 elements
                                                  .map((religion) =>
                                                      religion[0]
                                                          .toUpperCase() +
                                                      religion
                                                          .substring(1)
                                                          .toLowerCase())
                                                  .join(', ') +
                                              (profile
                                                          .partnerExpectation!
                                                          .motherTongueName
                                                          .length >
                                                      3
                                                  ? ' ..'
                                                  : '') ??
                                          '',
                                      onTap: () {},
                                    ),
                                    buildInfoRow(
                                      title: 'Community',
                                      text: profile
                                              .partnerExpectation?.communityName
                                          .take(
                                          3) // Take the first 3 elements
                                          .map((religion) =>
                                      religion[0]
                                          .toUpperCase() +
                                          religion
                                              .substring(1)
                                              .toLowerCase())
                                          .join(', ') +
                                          (profile
                                              .partnerExpectation!
                                              .communityName
                                              .length >
                                              3
                                              ? ' ..'
                                              : '') ??
                                          '',
                                      onTap: () {},
                                    ),
                                    buildInfoRow(
                                      title: 'Age bracket',
                                      text: profile.partnerExpectation!.minAge
                                                  .toString() +
                                              " - " +
                                              profile.partnerExpectation!.maxAge
                                                  .toString() +
                                      " yrs"
                                      ,
                                      onTap: () {},
                                    ),
                                    buildInfoRow(
                                      title: 'Highest bracket',
                                      text: profile
                                              .partnerExpectation!.minHeight
                                              .toString() +
                                          " - " +
                                          profile.partnerExpectation!.maxHeight
                                              .toString() +
                                          " ft",
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            sizedBox20(),
                            Container(
                              width: double.infinity,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 8),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Interest & Hobbies',
                                            style: kManrope25Black.copyWith(
                                                fontSize: Dimensions.fontSize18,
                                                color: Theme.of(context)
                                                    .primaryColorDark
                                                    .withOpacity(0.65)),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                Get.to(
                                                    () => EditInterestScreen());
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .primaryColorDark
                                                    .withOpacity(0.65),
                                              ))
                                        ],
                                      ),
                                    ),
                                    // const SizedBox(height: 12,),
                                    HobbiesWrap(
                                      allHobbies: userHobbies!,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // sizedBox10(),
                            // Container(
                            //   width: double.infinity,
                            //   height: photos.length>3?325:200,
                            //   decoration: BoxDecoration(
                            //       color: Theme.of(context).cardColor,
                            //       borderRadius: BorderRadius.circular(12),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: Colors.grey.withOpacity(0.5),
                            //           spreadRadius: 1,
                            //           blurRadius: 5,
                            //           offset: const Offset(
                            //               0, 3), // changes position of shadow
                            //         ),
                            //       ]),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
                            //     child: Column(
                            //       children: [
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               'Photos',
                            //               style: kManrope25Black.copyWith(
                            //                   fontSize: Dimensions.fontSize18,
                            //                   color: Theme.of(context)
                            //                       .primaryColorDark
                            //                       .withOpacity(0.65)),
                            //             ),
                            //             Visibility(
                            //                 visible: photos.length>3,
                            //                 child: customContainer(
                            //                     vertical: 5,
                            //                     horizontal: 10,
                            //                     child: Row(
                            //                       children: [
                            //                         SvgPicture.asset(ic4Dots),
                            //                         const SizedBox(
                            //                           width: 6,
                            //                         ),
                            //                         const Text("See All")
                            //                       ],
                            //                     ),
                            //                     radius: 8,
                            //                     color: Colors.white,
                            //                     click: () {
                            //                       Navigator.push(
                            //                           context,
                            //                           MaterialPageRoute(
                            //                               builder: (builder) =>
                            //                               const OurImagesScreen()));
                            //                     })),
                            //           ],
                            //         ),
                            //         // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         //   children: [
                            //         //     Text(
                            //         //       'Photos',
                            //         //       style: kManrope25Black.copyWith(fontSize: Dimensions.fontSize18,color: Theme.of(context).primaryColorDark.withOpacity(0.65)),
                            //         //     ),
                            //         //     IconButton(onPressed: () {
                            //         //         Navigator.push(context, MaterialPageRoute(
                            //         //             builder: (builder) => const EditPhotosScreen()));
                            //         //     }, icon: Icon(Icons.edit,
                            //         //     color: Theme.of(context).primaryColorDark.withOpacity(0.65),))
                            //         //   ],
                            //         // ),
                            //
                            //         // GestureDetector(onTap: () {
                            //         //   Navigator.push(context, MaterialPageRoute(
                            //         //       builder: (builder) => const EditPhotosScreen()));
                            //         //
                            //         // },
                            //         //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //         //     children: [
                            //         //       Text("Photos",style:styleSatoshiMedium(size: 16, color: primaryColor)),
                            //         //       Image.asset(icEdit,height: 20,width: 20,),
                            //         //     ],
                            //         //   ),
                            //         // ),
                            //         sizedBox16(),
                            //         photos.isEmpty || photos == null
                            //             ? Center(
                            //             child: GestureDetector(
                            //               onTap: () {
                            //                 Navigator.push(
                            //                     context,
                            //                     MaterialPageRoute(
                            //                         builder: (builder) =>
                            //                         const EditPhotosScreen()));
                            //               },
                            //               child: const DottedPlaceHolder(
                            //                 text: 'Add Photos',
                            //               ),
                            //             ))
                            //             : Stack(
                            //             children: [
                            //              GridView.builder(
                            //               shrinkWrap: true,
                            //               itemCount: photos.length,
                            //               gridDelegate:
                            //               const SliverGridDelegateWithFixedCrossAxisCount(
                            //                 crossAxisCount: 3,
                            //                 mainAxisSpacing: 8,
                            //                 crossAxisSpacing: 8,
                            //                 childAspectRatio: 1,
                            //               ),
                            //               itemBuilder: (_, i) {
                            //                 return GestureDetector(
                            //                   onTap: () {
                            //                     Navigator.push(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                         builder: (context) =>
                            //                             PhotoViewScreen(
                            //                               imageProvider: NetworkImage(
                            //                                 photos[i].image != null
                            //                                     ? '$baseGalleryImage${photos[i].image}'
                            //                                     : '',
                            //                               ),
                            //                             ),
                            //                       ),
                            //                     );
                            //                   },
                            //                   behavior:
                            //                   HitTestBehavior.translucent,
                            //                   child: Container(
                            //                     height: 220,
                            //                     width: 130,
                            //                     clipBehavior: Clip.hardEdge,
                            //                     decoration: BoxDecoration(
                            //                       border: Border.all(
                            //                         color: Colors.grey,
                            //                         width: 1,
                            //                       ),
                            //                       borderRadius:
                            //                       const BorderRadius.all(
                            //                           Radius.circular(10)),
                            //                     ),
                            //                     child: CachedNetworkImage(
                            //                       imageUrl: photos[i].image !=
                            //                           null
                            //                           ? '$baseGalleryImage${photos[i].image}'
                            //                           : '',
                            //                       fit: BoxFit.cover,
                            //                       errorWidget:
                            //                           (context, url, error) =>
                            //                           Padding(
                            //                             padding:
                            //                             const EdgeInsets.all(8.0),
                            //                             child: Image.asset(
                            //                               icLogo,
                            //                               height: 40,
                            //                               width: 40,
                            //                             ),
                            //                           ),
                            //                       progressIndicatorBuilder:
                            //                           (a, b, c) => customShimmer(
                            //                         height: 0, /*width: 0,*/
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 );
                            //               },
                            //             ),
                            //             Positioned(
                            //               bottom: 10,
                            //               right: 10,
                            //               child: Row(
                            //                 children: [
                            //                   InkWell(
                            //                     onTap: () {
                            //                       Navigator.push(
                            //                           context,
                            //                           MaterialPageRoute(
                            //                               builder: (builder) =>
                            //                               const EditPhotosScreen()));
                            //                     },
                            //                     child: Icon(
                            //                       Icons.edit,
                            //                       color: Theme.of(context)
                            //                           .primaryColorDark
                            //                           .withOpacity(0.65),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // sizedBox16(),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                // if (isLoading) Loading(),
              ],
            ),
    );
  }

  void _showCustomAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.topRight,
          title: const Text('Custom Alert Dialog'),
          content: Column(
            children: [
              const Text('This is a custom alert dialog.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomPopupMenu(BuildContext context) {
    Navigator.of(context).push(_customPopupPageRoute());
  }

  PageRouteBuilder _customPopupPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomPopupMenu();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

GestureDetector buildDataRowBold({
  required String title,
  required String text,
  required Function() onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: styleSatoshiBold(size: 16, color: color1C1C1c),
        ),
        Image.asset(
          icArrowRight,
          height: 18,
          width: 18,
        )
      ],
    ),
  );
}

GestureDetector buildInfoRow({
  required String title,
  required String text,
  required Function() onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: styleSatoshiRegular(size: 14, color: color5E5E5E),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    style: styleSatoshiMedium(size: 14, color: color212121),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Container chipBox({required String name}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        border: Border.all(width: 0.5, color: color4B164C.withOpacity(0.20)),
        color: Colors.transparent),
    padding: const EdgeInsets.all(10),
    child: Text(
      name,
      style: styleSatoshiMedium(size: 16, color: color4B164C),
    ),
  );
}

GestureDetector buildProfileRow({
  required String image,
  required String title,
  required String text,
  required Function() onTap,
}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(right: 18.0, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SvgPicture.asset(
              image,
              height: 48,
              width: 48,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: styleSatoshiMedium(size: 14, color: color6C7378),
                ),
                SizedBox(
                  width: 280,
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: styleSatoshiBold(size: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
