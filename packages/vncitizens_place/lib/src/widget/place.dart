import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common_hcm/vncitizens_common_hcm.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/hcm_tag_resource.dart';
import 'package:vncitizens_place/src/widget/place_listview.dart';
import 'package:vncitizens_place/src/widget/place_mapview.dart';
import 'package:vncitizens_place/src/widget/tag_checkbox_listtile.dart';

class Place extends StatefulWidget {
  Place({Key? key}) : super(key: key);

  @override
  State<Place> createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  final PlaceController _placeController = Get.put(PlaceController());

  final InternetController _internetController = Get.put(InternetController());

  bool isShowDialog = false;

  @override
  void initState() {
    super.initState();
    _placeController.searchController.addListener(() {
      _placeController.keyword.value = _placeController.searchController.text;
    });
    _placeController.isPlaceLoading.stream.listen((val) {
      if (val && !isShowDialog && !_placeController.isSearch.value ||
          val && !isShowDialog && _placeController.isDefaultView.value) {
        isShowDialog = true;
        Get.dialog(
            const AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              content: SingleChildScrollView(
                child: AppLinearProgress(),
              ),
            ),
            barrierDismissible: false);
      } else if (isShowDialog) {
        isShowDialog = false;
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
              title: Obx(() {
                if (_placeController.isSearch.value) {
                  return _buildSearchTextFormField(context);
                } else {
                  return Text(
                    "dia diem".tr,
                    style: AppBarStyle.title,
                  );
                }
              }),
              actions: [
                Obx(() {
                  bool isSearch = _placeController.isSearch.value;
                  return IconButton(
                    color: Colors.black87,
                    icon: isSearch
                        ? const Icon(
                            Icons.close,
                            color: Color(0xFFFAFAFA),
                          )
                        : const Icon(Icons.search, color: Color(0xFFFAFAFA)),
                    iconSize: 32,
                    onPressed: () async {
                      await _placeController.toggleSearchOrClose();
                      if (!_placeController.isSearch.value) {
                        _clearTextForm(context);
                      }
                    },
                  );
                }),
                _placeController.configTypeView == 0
                    ? Obx(() {
                        bool isDefaultView =
                            _placeController.isDefaultView.value;
                        return IconButton(
                          color: Colors.black87,
                          icon: isDefaultView
                              ? const Icon(
                                  Icons.format_list_bulleted,
                                  color: Color(0xFFFAFAFA),
                                )
                              : const Icon(Icons.map_outlined,
                                  color: Color(0xFFFAFAFA)),
                          iconSize: 32,
                          onPressed: () {
                            _placeController.toggleView();
                            // _placeController.getPlaces(keyword: _searchController.text);
                          },
                        );
                      })
                    : Container()
              ],
              backgroundColor: Colors.blue.shade800),
          bottomNavigationBar: const MyBottomAppBar(index: -1),
          body: Obx(() {
            if (_internetController.hasConnected.value) {
              // if (_placeController.isTagLoading.value) {
              //   return Center(
              //     child: Container(
              //       margin: const EdgeInsets.symmetric(vertical: 16),
              //       child: LinearProgressIndicator(
              //         backgroundColor:
              //             AppConfig.materialMainBlueColor.withOpacity(0.2),
              //         color: AppConfig.materialMainBlueColor,
              //         minHeight: 5,
              //       ),
              //     ),
              //   );
              // } else {
              return Stack(
                children: [
                  // SizedBox(
                  //     height: Get.height * 0.075,
                  //     child: Padding(
                  //       padding:
                  //           const EdgeInsets.only(top: 10, left: 10, right: 10),
                  //       child: _buildSearchTextFormField(context),
                  //     )),
                  _placeController.configTypeView == 0
                      ? Obx(() {
                          if (_placeController.isDefaultView.value) {
                            return Container(
                                alignment: Alignment.bottomCenter,
                                height: Get.height * 0.84,
                                child: PlaceMapView());
                          } else {
                            return Container(
                                margin: EdgeInsets.only(top: Get.height * 0.07),
                                alignment: Alignment.bottomCenter,
                                height: Get.height * 0.9 - 85,
                                child: const PlaceListView());
                          }
                        })
                      : Container(
                          margin: EdgeInsets.only(top: Get.height * 0.07),
                          alignment: Alignment.bottomCenter,
                          height: Get.height * 0.9 - 85,
                          child: const PlaceListView()),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        height: Get.height * 0.07,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView(
                              controller: _placeController.hTagScrollController,
                              scrollDirection: Axis.horizontal,
                              children: _buildTagChips(),
                            ))),
                  ),
                ],
              );
              // }
            } else {
              return NoInternet(
                onPressed: () {},
              );
            }
          })),
    );
  }

  TextFormField _buildSearchTextFormField(BuildContext context) {
    return TextFormField(
      autofocus: _placeController.isSearch.value,
      cursorColor: Theme.of(context).primaryColor,
      controller: _placeController.searchController,
      style: GoogleFonts.roboto(
          color: Colors.white, fontSize: 18, letterSpacing: 0.25),
      decoration: InputDecoration(
        filled: true,
        hintText: 'nhap dia diem'.tr,
        hintStyle: GoogleFonts.roboto(color: Colors.white70, fontSize: 18),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        isDense: true,
        // suffixIcon: Obx(() {
        //   if (_placeController.keyword.value.isNotEmpty) {
        //     return IconButton(
        //       color: Colors.white,
        //       icon: const Icon(Icons.clear),
        //       onPressed: () {
        //         _clearTextForm(context);
        //         _placeController.searchPlaces('');
        //         _placeController.getPlaces();
        //       },
        //     );
        //   } else {
        //     return const SizedBox();
        //   }
        // }),
        // border: const OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(5)),
        //     borderSide: BorderSide(color: Colors.black12)),
        // focusedBorder: OutlineInputBorder(
        //     borderRadius: const BorderRadius.all(Radius.circular(5)),
        //     borderSide: BorderSide(color: Colors.blue.shade800))
      ),
      onChanged: (value) async {},
      onEditingComplete: () async {
        FocusScope.of(context).unfocus();
        await _placeController
            .searchPlaces(_placeController.searchController.text);

        // SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }

  void _clearTextForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    // _placeController.searchController.clear();
  }

  List<Widget> _buildTagChips() {
    // final _chips = <Widget>[buildMoreChip()];
    final _chips = <Widget>[];
    for (var i = 0; i < _placeController.hcmTags.length; i++) {
      _chips.add(buildChip(i));
    }
    return _chips;
  }

  Widget buildMoreChip() {
    bool isActive = _placeController.hcmTags.isNotEmpty;
    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ActionChip(
          label: Icon(
            Icons.more_horiz,
            color: isActive ? Colors.blue.shade800 : Colors.black54,
          ),
          elevation: 2,
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          // shape: StadiumBorder(
          //     side: BorderSide(
          //   width: 1,
          //   color: isActive ? Colors.blue.shade800 : Colors.black38,
          // )),
          onPressed: () {
            if (isActive) {
              buildBottomSheet();
            }
          },
        ));
  }

  Widget buildChip(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Obx(() {
        HCMTagResource _selector = _placeController.hcmTags[index];
        return ActionChip(
          label: Text(
            _selector.name,
            style: GoogleFonts.roboto(
                color: _selector.isSelected
                    ? Colors.blue.shade800
                    : Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          elevation: 2,
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          // shape: StadiumBorder(
          //     side: BorderSide(
          //   width: 1,
          //   color: _selector.isSelected ? Colors.blue.shade800 : Colors.black38,
          // )),
          onPressed: () async {
            await _placeController.toggleHCMTag(index);
          },
        );
      }),
    );
  }

  void buildBottomSheet() {
    Get.bottomSheet(
      Wrap(children: [
        SizedBox(
          height: 50,
          child: Column(
            children: <Widget>[
              Obx(() {
                return CheckboxListTile(
                  activeColor: Colors.blue.shade800,
                  dense: true,
                  secondary: InkWell(
                    child: const Icon(Icons.clear, color: Colors.black87),
                    onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      Get.back();
                    },
                  ),
                  title: Text("loai dia diem".tr,
                      style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                      textAlign: TextAlign.center),
                  value: _placeController.isSelectedAllTags.value,
                  onChanged: (bool? value) {
                    if (_placeController.isSelectedAllTags.value) {
                      _placeController.unselectAllTags();
                    } else {
                      _placeController.selectAllTags();
                    }
                  },
                );
              })
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: Obx(() {
            return ListView.separated(
              controller: _placeController.vTagScrollController,
              itemBuilder: (context, index) {
                if (index == _placeController.hcmTags.length - 1 &&
                    _placeController.isMoreAvailableTag.value == true) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return TagCheckBoxListTile(index: index);
                }
              },
              itemCount: _placeController.hcmTags.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 5,
                );
              },
            );
          }),
        ),
        SizedBox(
            height: 50,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "hien thi ket qua".tr.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 50),
      ]),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      isScrollControlled: true,
    );
  }
}
