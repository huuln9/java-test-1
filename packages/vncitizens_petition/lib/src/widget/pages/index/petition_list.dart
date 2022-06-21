import 'package:flutter/material.dart';
import 'package:vncitizens_account/vncitizens_account.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/widget/pages/index/petition_list_app_bar.dart';
import 'package:vncitizens_petition/src/widget/pages/index/petition_public_list_content.dart';
import 'package:vncitizens_petition/src/widget/pages/index/petition_personal_list_content.dart';

class PetitionList extends StatefulWidget {
  const PetitionList({Key? key}) : super(key: key);

  @override
  _PetitionListState createState() => _PetitionListState();
}

class _PetitionListState extends State<PetitionList>
    with SingleTickerProviderStateMixin {
  late TabController _controller =
      TabController(length: tabContents.length, vsync: this);

  List<Widget> tabContents = [
    PetitionPublicListContent(),
    PetitionPersonalListContent()
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabContents.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PetitionListAppBar(
          controller: _controller,
        ),
        body: TabBarView(
          controller: _controller,
          children: tabContents,
        ),
        bottomNavigationBar: const MyBottomAppBar(index: -1),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed('/vncitizens_petition/create');
            }));
  }
}
