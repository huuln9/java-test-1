# vncitizens_common

Package chứa các thư viện dùng chung cho sản phẩm vnCitizens.
`LLD`: https://docs.google.com/document/d/1EFlVSTTZ3ZUsASviD1b7gHVlEL8X_k_q/edit

## Hướng dẫn

Import package:

```bash
flutter pub add vncitizens_common
```

### Danh sách Controller

`InternetController`: Kiểm tra tình trạng kết nối mạng

### Danh sách Widget

`MyBottomAppBar`: Thành phần bottomAppBar của ứng dụng
`MyFloatingActionButton`: Thành phần FloatingActionButton của ứng dụng

### Dependencies

#### Danh sách

```yaml
digo_common:
    git: https://mnhai@scm.devops.vnpt.vn/egov.pm4.digo/flutter_common.git
iscs_common:
    git: https://mnhai@scm.devops.vnpt.vn/egov.pm4.digo/flutter_iscs_common.git
get: ^4.6.1
get_storage: ^2.0.3
url_launcher: ^6.0.20
intl: ^0.17.0
geolocator: ^8.1.1
weather: ^2.0.1
hive: ^2.0.5
carousel_slider: ^4.0.0
internet_connection_checker: ^0.0.1+3
google_fonts: ^2.3.1
```

#### Bổ sung dependencies

1. Thêm dependencies vào file `pubspec.yaml`.
2. Export dependencies vừa thêm ở file `vncitizens_common.dart`.

**Lưu ý:** Nếu có 2 dependencies có trùng class thì có thể tạo file dart cùng cấp với `vncitizens_common.dart` và export dependency đó. Ví dụ `get` và `http` trùng `MultipartFile` và `Response` nên không thể export cả 2 trong file `vncitizens_common.dart`

- Tạo file `vncitizens_common/http.dart`:
```dart
export 'package:http/http.dart';
```
- Khi package khác sử dụng dependency `http`
```dart
import 'package:vncitizens_common/http.dart';
```