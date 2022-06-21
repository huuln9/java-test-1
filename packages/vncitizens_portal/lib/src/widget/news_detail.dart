import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_common/html.dart';
import 'package:vncitizens_portal/src/controller/portal_controller.dart';

class NewsDetail extends GetView<PortalController> {
  NewsDetail({Key? key}) : super(key: key);

  final InternetController _internetController = Get.put(InternetController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _internetController.hasConnected.value
          ? controller.isLoadingDetail.value
              ? const Center(child: CircularProgressIndicator())
              : _detailNews()
          : NoInternet(onPressed: () => controller.onInit()),
    );
  }

  Widget _detailNews() {
    return SingleChildScrollView(
      child: Column(
        children: [
          controller.news!.thumbnail != ""
              ? Image(
                  image: NetworkImage(controller.news!.thumbnail!),
                  errorBuilder: (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) =>
                      const SizedBox.shrink())
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Text(
              controller.news!.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(controller.news!.content!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'Nguồn: ' +
                    controller.news!.resource! +
                    '\n' +
                    'Tác giả: ' +
                    controller.news!.author! +
                    '\n' +
                    'Ngày đăng: ' +
                    controller.news!.createDate,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
          )
        ],
      ),
    );
  }
}
