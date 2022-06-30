library vncitizens_common_hcm;

export 'src/core/package_init.dart';

// Widget
// Service

// Controller

// Model

// Style

// Util
export 'src/util/timezone_helper.dart';
export 'src/util/dashed_rect.dart';
export 'src/util/ui_helper.dart';
export 'src/widget/error/no_data.dart';
export 'src/widget/error/empty_reload_data.dart';
export 'src/widget/app_linear_progress.dart';

export 'src/service/hcm_resource_service.dart';
export 'src/core/package_init.dart';
export 'src/service/hcm_sos_location_call_service.dart';

// ============ EXPORT DEPENDENCIES =============
// Nếu có 2 package trùng class thì có thể tạo file dart cùng cấp với vncitizens_common.dart và export package đó
// Ví dụ get và http trùng MultipartFile và Response thì có thể tạo file http.dart để export package http

export 'package:geocoding/geocoding.dart' hide Location;
export 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
