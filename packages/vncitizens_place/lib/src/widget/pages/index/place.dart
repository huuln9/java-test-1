import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_place/src/config/app_config.dart';
import 'package:vncitizens_place/src/controller/place_controller.dart';
import 'package:vncitizens_place/src/model/tag_selector.dart';
import 'package:vncitizens_place/src/widget/pages/index/place_listview.dart';
import 'package:vncitizens_place/src/widget/pages/index/place_mapview.dart';
import 'package:vncitizens_place/src/widget/commons/tag_checkbox_listtile.dart';

class Place extends StatefulWidget {
  const Place({Key? key}) : super(key: key);

  @override
  _PlaceState createState() => _PlaceState();
}

class _PlaceState extends State<Place> {
  final PlaceController _placeController = Get.put(PlaceController());
  final InternetController _internetController = Get.put(InternetController());
  final TextEditingController _searchController = TextEditingController();

  Icon iconSearch = const Icon(Icons.search);
  Widget textAppBar = Text("dia diem".tr);

  @override
  Widget build(BuildContext context) {
    _searchController.addListener(() {
      _placeController.keyword.value = _searchController.text;
    });
    return Scaffold(
        appBar: AppBar(
            title: textAppBar,
            actions: [
              IconButton(
                onPressed: () => {
                  setState(() {
                    if (iconSearch.icon == Icons.search) {
                      iconSearch = const Icon(Icons.highlight_off);
                      textAppBar = _buildSearchTextFormField(context);
                    } else {
                      iconSearch = const Icon(Icons.search);
                      textAppBar = Text("dia diem".tr);
                      _clearTextForm(context);
                      _placeController.getPlaces();
                    }
                  })
                },
                icon: iconSearch,
              ),
              AppConfig.configViewMap == 1
                  ? Obx(() {
                      bool isDefaultView = _placeController.isDefaultView.value;
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
                          _placeController.getPlaces(
                              keyword: _searchController.text);
                        },
                      );
                    })
                  : const Text("")
            ],
            backgroundColor: Colors.blue.shade800),
        bottomNavigationBar: const MyBottomAppBar(index: -1),
        body: Obx(() {
          if (_internetController.hasConnected.value) {
            if (_placeController.isTagLoading.value ||
                _placeController.isPlaceLoading.value) {
              if (_placeController.isDefaultView.value) {
                return const DataLoading(message: "Đang tải bản đồ");
              } else {
                return const DataLoading(
                    message: "Đang tải danh sách địa điểm");
              }
            } else {
              if (_placeController.isDefaultView.value &&
                  AppConfig.configViewMap == 1) {
                return Stack(
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        height: Get.height,
                        child: PlaceMapView()),
                    Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                            height: Get.height * 0.085,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ListView(
                                  controller:
                                      _placeController.hTagScrollController,
                                  scrollDirection: Axis.horizontal,
                                  children: _buildTagChips(),
                                ))))
                  ],
                );
              } else {
                return Wrap(children: [
                  SizedBox(
                      height: Get.height * 0.085,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView(
                            controller: _placeController.hTagScrollController,
                            scrollDirection: Axis.horizontal,
                            children: _buildTagChips(),
                          ))),
                  Container(
                      alignment: Alignment.bottomCenter,
                      height: Get.height,
                      child: const PlaceListView())
                ]);
              }
            }
          } else {
            return DataFailedLoading(onPressed: () {});
          }
        }));
  }

  TextFormField _buildSearchTextFormField(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white, fontSize: 20),
      controller: _searchController,
      autofocus: true,
      cursorColor: Colors.red,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'nhap tu khoa'.tr,
        hintStyle:
            GoogleFonts.roboto(color: Colors.grey.shade100, fontSize: 16),
      ),
      onEditingComplete: () {
        _placeController.getPlaces(keyword: _searchController.text);
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }

  void _clearTextForm(BuildContext context) {
    FocusScope.of(context).unfocus();
    _searchController.clear();
  }

  List<Widget> _buildTagChips() {
    final _chips = <Widget>[buildMoreChip()];
    for (var i = 0; i < _placeController.tags.length; i++) {
      _chips.add(buildChip(i));
    }
    return _chips;
  }

  Widget buildMoreChip() {
    bool isActive = _placeController.tags.isNotEmpty;
    return Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ActionChip(
          label: Icon(
            Icons.more_horiz,
            color: isActive ? Colors.blue.shade800 : Colors.black38,
          ),
          backgroundColor: const Color(0xFFFAFAFA),
          shape: StadiumBorder(
              side: BorderSide(
            width: 1,
            color: isActive ? Colors.blue.shade800 : Colors.black38,
          )),
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
        TagSelector _selector = _placeController.tags[index];
        return ActionChip(
          label: Text(
            _selector.data.name,
            style: GoogleFonts.roboto(
              color:
                  _selector.isSelected ? Colors.blue.shade800 : Colors.black38,
              fontSize: 14,
            ),
          ),
          backgroundColor: const Color(0xFFFAFAFA),
          shape: StadiumBorder(
              side: BorderSide(
            width: 1,
            color: _selector.isSelected ? Colors.blue.shade800 : Colors.black38,
          )),
          onPressed: () {
            _placeController.toggleTag(index);
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
                if (index == _placeController.tags.length - 1 &&
                    _placeController.isMoreAvailableTag.value == true) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return TagCheckBoxListTile(index: index);
                }
              },
              itemCount: _placeController.tags.length,
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
