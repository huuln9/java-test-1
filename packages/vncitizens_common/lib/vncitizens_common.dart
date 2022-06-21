library vncitizens_common;

export 'src/core/package_init.dart';

// Widget
export 'src/widget/my_bottom_appbar.dart';
export 'src/widget/my_floating_action_button.dart';
export 'src/widget/data_not_found.dart';
export 'src/widget/no_internet.dart';
export 'src/widget/data_loading.dart';
export 'src/widget/data_failed_loading.dart';
export 'src/widget/empty_data.dart';

// Service
export 'src/service/vncc_service.dart';
export 'src/service/directory_service.dart';
export 'src/service/notify_service.dart';
export 'src/service/location_service.dart';

// Controller
export 'src/controller/internet_controller.dart';
export 'src/controller/notification_counter_controller.dart';

// Model
export 'src/model/affected_row_model.dart';

// Style
export 'src/style/listtitle_style.dart';
export 'src/style/appbar_style.dart';

// Util
export 'src/util/timezone_helper.dart';
export 'src/util/char_color_helper.dart';
export 'src/util/color_util.dart';
export 'src/util/dashed_rect.dart';
export 'src/util/ui_helper.dart';

export 'src/service/oidc_service.dart';
export 'src/service/auth_service.dart';
export 'src/util/common_util.dart';
export 'src/controller/internet_controller.dart';
export 'src/core/package_init.dart';
export 'src/service/bioid_service.dart';
export 'src/service/location_service.dart';
export 'src/service/minio_service.dart';
export 'src/service/storage_service.dart';
export 'src/service/administrative_document_service.dart';
export 'src/service/igate/igate_oidc_service.dart';
export 'src/service/igate/igate_petition_service.dart';
export 'src/service/igate/igate_basecat_service.dart';
export 'src/service/igate/igate_basedata_service.dart';
export 'src/service/igate/igate_fileman_service.dart';
export 'src/service/igate/igate_placedata_service.dart';
export 'src/service/igate/igate_sysman_service.dart';

// ============ EXPORT DEPENDENCIES =============
// Nếu có 2 package trùng class thì có thể tạo file dart cùng cấp với vncitizens_common.dart và export package đó
// Ví dụ get và http trùng MultipartFile và Response thì có thể tạo file http.dart để export package http
export 'package:get/get.dart';
export 'package:get_storage/get_storage.dart';
export 'package:carousel_slider/carousel_slider.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:intl/intl.dart';
export 'package:geolocator/geolocator.dart';
export 'package:weather/weather.dart';
export 'package:hive/hive.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:digo_common/digo_common.dart';
export 'package:iscs_common/iscs_common.dart';
export 'package:internet_connection_checker/internet_connection_checker.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:photo_view/photo_view.dart';
export 'package:photo_view/photo_view_gallery.dart';
export 'package:timezone/data/latest.dart';
export 'package:timezone/standalone.dart';
export 'package:badges/badges.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:jwt_decode/jwt_decode.dart';
export 'package:email_validator/email_validator.dart';
export 'package:path_provider/path_provider.dart';
export 'package:minio/minio.dart';
export 'package:minio/io.dart';
export 'package:image_cropper/image_cropper.dart';
export 'package:image_picker/image_picker.dart';
export 'package:drishya_picker/drishya_picker.dart';
export 'package:objectid/objectid.dart';
export 'package:path/path.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_messaging/firebase_messaging.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:platform_device_id/platform_device_id.dart';
export 'package:flutter_share/flutter_share.dart';
export 'package:qr_code_scanner/qr_code_scanner.dart';
export 'package:flutter_sms/flutter_sms.dart';
export 'package:wifi_iot/wifi_iot.dart';
export 'package:file_picker/file_picker.dart';

// export 'package:dotted_border/dotted_border.dart';
export 'package:video_player/video_player.dart';
export 'package:video_thumbnail/video_thumbnail.dart';
export 'package:expandable/expandable.dart';
export 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:geocoding/geocoding.dart' hide Location;
export 'package:flutter_rating_bar/flutter_rating_bar.dart';
export 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:open_file/open_file.dart';
