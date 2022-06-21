# vncitizens_petition

Package phản ánh kiến nghị

## Hướng dẫn

Import package:

```yaml
vncitizens_petition:
    path: <path_to_package>
```

### Cấu hình với GetStorage

- Box name: `vncitizens_petition`.
- Key: `vcall`.
- Cấu trúc dữ liệu:

```json
{
  "avatarReceiver": "<internet-image-url>",
  "dataOptions": {
    "avatarUrl": "<internet-image-url>"
  },
  "tokenCustomer": "<token-customer-string>",
  "dest": [
    "1022"
  ],
  "desName": "Tổng đài 1022"
}
```

### Danh sách models

`vcall_model`: model thông tin vcall

### Hàm hỗ trợ gọi phản ánh

#### Đăng ký thiết bị

- Tên hàm: `registerDevice`
- Sử dụng:
```dart
import 'package:vncitizens_petition/vncitizens_petition.dart';

VCallUtil.registerDevice();
```

#### Khởi tạo cuộc gọi

- Tên hàm: `createVCall`
- Sử dụng:
```dart
import 'package:vncitizens_petition/vncitizens_petition.dart';

VCallUtil.createVCall();
```

### Danh sách route
`/vncitizens_petition`: Gọi phản ánh