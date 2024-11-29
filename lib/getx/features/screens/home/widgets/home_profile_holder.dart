import 'package:bureau_couple/getx/controllers/auth_controller.dart';
import 'package:bureau_couple/getx/data/response/profile_model.dart';
import 'package:bureau_couple/getx/features/widgets/custom_button%20_widget.dart';
import 'package:bureau_couple/getx/utils/dimensions.dart';
import 'package:bureau_couple/getx/utils/theme.dart';
import 'package:bureau_couple/src/constants/shared_prefs.dart';
import 'package:bureau_couple/src/constants/sizedboxe.dart';
import 'package:bureau_couple/src/constants/string.dart';
import 'package:bureau_couple/src/constants/textstyles.dart';
import 'package:bureau_couple/src/utils/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:bureau_couple/src/models/matches_model.dart';
import 'package:intl/intl.dart';
import 'package:bureau_couple/src/models/matches_model.dart' as basicModel;

import '../../../../controllers/profile_controller.dart';
import 'package:get/get.dart';



class HomeProfileHolder extends StatelessWidget {
  final String img;
  final String name;
 final basicModel.BasicInfo basicInfo;
 final ProfileModel profileModel;
  // final String email;
  final Function() tap;


  const HomeProfileHolder(
      {super.key,
      required this.img,
      required this.name,
      /* required this.email, */ required this.tap, required this.basicInfo, required this.profileModel});

  @override
  Widget build(BuildContext context) {
  AuthController authControl = Get.find<AuthController>();
    DateTime? birthDate = DateFormat('yyyy-MM-dd').parse(
            basicInfo!.birthDate!);


   int age = DateTime.now()
       .difference(birthDate)
       .inDays ~/
       365;


    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      margin:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        color: darkBlueColor.withOpacity(0.90),
      ),
      child: Row(
        children: [
          ClipOval(
              child: CustomImageWidget(
            image: img,
            height: 60,
            width: 60,
          )),
          sizedBoxWidth15(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment:   CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringUtils.capitalize(name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleSatoshiBold(
                            size: Dimensions.fontSize20, color: Colors.white),
                      ),
                      Row(
                        children: [
                          Text(
                            "Age: ${age}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleSatoshiLight(
                                size: Dimensions.fontSize10, color: Colors.white),
                          ),
                          const SizedBox(width: 6,),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6,),
                          Text(
                            "Heighr: ${Get.find<ProfileController>().convertHeightToFeetInches(profileModel.physicalAttributes!.height.toString())}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleSatoshiLight(
                                size: Dimensions.fontSize10, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        "Profession: ${profileModel.professionName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleSatoshiLight(
                            size: Dimensions.fontSize10, color: Colors.white),
                      ),
                      Text(
                        "State: ${basicInfo.permanentAddress!.state}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: styleSatoshiLight(
                            size: Dimensions.fontSize10, color: Colors.white),
                      ),

                    ],
                  ),
                SizedBox(width: 65,),
                  CustomButtonWidget(
                    height: 50,
                    width: 100,
                    isBold: false,
                    buttonText: 'EDIT PROFILE',
                    fontSize: Dimensions.fontSize12,
                    onPressed: tap,
                  )
                ],
              ),
              // Text(StringUtils.capitalize(email),
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              //   style: styleSatoshiLight(size: Dimensions.fontSize10, color: Colors.white),),
            ],
          ),
        ],
      ),
    );
  }
}
