import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/document_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import 'fullscreen_circular_loading.dart';

class Document extends GetView<DocumentController> {
  const Document({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(controller.uppercaseFirstLetter(controller.documentModel.cardType)),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// image
                        _buildImage(context),

                        /// group 1
                        _buildGroupOne(context),

                        const Divider(thickness: 10, color: Color.fromRGBO(229, 229, 229, 1)),

                        /// group 2
                        _buildGroupTwo(context),

                        const Divider(thickness: 10, color: Color.fromRGBO(229, 229, 229, 1)),

                        /// group 3
                        _buildGroupThree(context),

                        /// buttons
                        _buildButtons(context),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() => controller.loading.value ? const FullScreenCircularLoading() : const SizedBox())
            ],
          )),
    );
  }

  Widget _buildImage(BuildContext context) {
    return CarouselSlider(
      items: [
        Image.memory(controller.frontSide, fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
        Image.memory(controller.backSide, fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
      ],
      options: CarouselOptions(aspectRatio: 16 / 9, viewportFraction: 1, autoPlay: false, enableInfiniteScroll: false),
    );
  }

  Widget _buildGroupOne(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ho ten
          TextFormField(
            controller: controller.fullnameController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "ho va ten".tr + " *",
            ),
            validator: (value) => controller.fullNameValidator(value),
          ),
          const SizedBox(height: 20),

          /// gioi tinh
          controller.documentType == 2
              ? const SizedBox()
              : DropdownButtonFormField(
                  isExpanded: true,
                  value: controller.genderSelected,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                    border: const OutlineInputBorder(),
                    labelText: "gioi tinh".tr + " *",
                  ),
                  items: controller.genders.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => controller.genderValidator(value as String?),
                  onChanged: (String? newValue) => controller.onChangeGender(newValue),
                ),
          controller.documentType == 2 ? const SizedBox() : const SizedBox(height: 20),

          /// ngay sinh
          TextFormField(
            readOnly: true,
            controller: controller.birthdayController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "ngay sinh".tr + " *",
            ),
            validator: (value) => controller.emptyValidator(value),
            onTap: () => controller.onTapBirthday(context),
          ),
          const SizedBox(height: 20),

          /// so cccd / cmnd / ho chieu
          TextFormField(
            controller: controller.cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: controller.getCardNumberName(),
            ),
            validator: (value) => controller.cardNumberValidator(value),
          ),
          const SizedBox(height: 20),

          /// ngay cap
          TextFormField(
            readOnly: true,
            controller: controller.issueDateController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "ngay cap".tr + " *",
            ),
            validator: (value) => controller.emptyValidator(value),
            onTap: () => controller.onTapIssueDate(context),
          ),
          const SizedBox(height: 20),

          /// noi cap
          Obx(
            () => DropdownButtonFormField(
              isExpanded: true,
              value: controller.issuePlaceIdSelected != "" ? controller.issuePlaceIdSelected : null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                border: const OutlineInputBorder(),
                labelText: "noi cap".tr + " *",
              ),
              items: controller.issuePlaces.map((value) {
                return DropdownMenuItem(
                  value: value.id,
                  child: Text(value.name),
                );
              }).toList(),
              validator: (value) => controller.genderValidator(value as String?),
              onChanged: (String? newValue) => controller.onChangeIssuePlace(newValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupTwo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// title
          Text(
            "que quan".tr,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),

          /// quoc gia
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: controller.originNationSelected,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  border: const OutlineInputBorder(),
                  labelText: "quoc gia".tr + " *",
                ),
                items: controller.nations.map((value) {
                  return DropdownMenuItem(
                    value: value.id,
                    child: Text(value.name),
                  );
                }).toList(),
                validator: (value) => controller.emptyValidator(value as String?),
                onChanged: (String? newValue) => controller.onChangeOriginNation(newValue),
              ),
            ),
          ),

          /// level 1
          Obx(
            () => controller.originPlaceTypeLevels.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.originAddressLevels1Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.originPlaceTypeLevels[0].name != null
                            ? (controller.originPlaceTypeLevels[0].name as String) + " *"
                            : "*",
                      ),
                      items: controller.originAddressLevels1.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeOriginLevel1(newValue),
                    ),
                  ),
          ),

          /// level 2
          Obx(
            () => controller.originPlaceTypeLevels.length < 2
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Obx(
                      () => DropdownButtonFormField(
                        isExpanded: true,
                        value: controller.originAddressLevels2Selected?.id,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                          border: const OutlineInputBorder(),
                          labelText: controller.originPlaceTypeLevels[1].name != null
                              ? (controller.originPlaceTypeLevels[1].name as String) + " *"
                              : "*",
                        ),
                        items: controller.originAddressLevels2.map((value) {
                          return DropdownMenuItem(
                            value: value.id,
                            child: Text(value.name),
                          );
                        }).toList(),
                        validator: (value) => controller.emptyValidator(value as String?),
                        onChanged: (String? newValue) => controller.onChangeOriginLevel2(newValue),
                      ),
                    ),
                  ),
          ),

          /// level 3
          Obx(
            () => controller.originPlaceTypeLevels.length < 3
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.originAddressLevels3Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.originPlaceTypeLevels[2].name != null
                            ? (controller.originPlaceTypeLevels[2].name as String) + " *"
                            : "*",
                      ),
                      items: controller.originAddressLevels3.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeOriginLevel3(newValue),
                    ),
                  ),
          ),

          /// level 4
          Obx(
            () => controller.originPlaceTypeLevels.length < 4
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.originAddressLevels4Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.originPlaceTypeLevels[3].name != null
                            ? (controller.originPlaceTypeLevels[3].name as String) + " *"
                            : "*",
                      ),
                      items: controller.originAddressLevels4.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeOriginLevel4(newValue),
                    ),
                  ),
          ),

          /// dia chi
          TextFormField(
            controller: controller.originAddressDetailController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "dia chi".tr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupThree(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// title
          Text(
            "noi thuong tru".tr,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),

          /// quoc gia
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DropdownButtonFormField(
                isExpanded: true,
                value: controller.recentNationSelected,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                  border: const OutlineInputBorder(),
                  labelText: "quoc gia".tr + " *",
                ),
                items: controller.nations.map((value) {
                  return DropdownMenuItem(
                    value: value.id,
                    child: Text(value.name),
                  );
                }).toList(),
                validator: (value) => controller.emptyValidator(value as String?),
                onChanged: (String? newValue) => controller.onChangeRecentNation(newValue),
              ),
            ),
          ),

          /// level 1
          Obx(
            () => controller.recentPlaceTypeLevels.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.recentAddressLevels1Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.recentPlaceTypeLevels[0].name != null
                            ? (controller.recentPlaceTypeLevels[0].name as String) + " *"
                            : "*",
                      ),
                      items: controller.recentAddressLevels1.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeRecentLevel1(newValue),
                    ),
                  ),
          ),

          /// level 2
          Obx(
            () => controller.recentPlaceTypeLevels.length < 2
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.recentAddressLevels2Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.recentPlaceTypeLevels[1].name != null
                            ? (controller.recentPlaceTypeLevels[1].name as String) + " *"
                            : "*",
                      ),
                      items: controller.recentAddressLevels2.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeRecentLevel2(newValue),
                    ),
                  ),
          ),

          /// level 3
          Obx(
            () => controller.recentPlaceTypeLevels.length < 3
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.recentAddressLevels3Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.recentPlaceTypeLevels[2].name != null
                            ? (controller.recentPlaceTypeLevels[2].name as String) + " *"
                            : "*",
                      ),
                      items: controller.recentAddressLevels3.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeRecentLevel3(newValue),
                    ),
                  ),
          ),

          /// level 4
          Obx(
            () => controller.recentPlaceTypeLevels.length < 4
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      value: controller.recentAddressLevels4Selected?.id,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                        border: const OutlineInputBorder(),
                        labelText: controller.recentPlaceTypeLevels[3].name != null
                            ? (controller.recentPlaceTypeLevels[3].name as String) + " *"
                            : "*",
                      ),
                      items: controller.recentAddressLevels4.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      validator: (value) => controller.emptyValidator(value as String?),
                      onChanged: (String? newValue) => controller.onChangeRecentLevel4(newValue),
                    ),
                  ),
          ),

          /// dia chi
          TextFormField(
            controller: controller.recentAddressDetailController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "dia chi".tr,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: OutlinedButton(
              onPressed: () => controller.reScan(),
              style: OutlinedButton.styleFrom(side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cached),
                  const SizedBox(width: 4),
                  Text(
                    "quet lai".tr.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )),
        ),
        const SizedBox(width: 15),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: ElevatedButton(
              onPressed: () => controller.submit(),
              child: Text(
                controller.userInfo == null ? "tiep tuc".tr.toUpperCase() : "luu lai".tr.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
        ),
      ],
    );
  }
}
