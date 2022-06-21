# vncitizens_home

Module Home của sản phẩm vnCitizens.

## Hướng dẫn sử dụng

Import package:

```yaml
vncitizens_home: 
  git: https://scm.devops.vnpt.vn/egov.ptpm.g038/flutter_vncitizens
  path: packages/vncitizens_home
```

Thiết lập package (nên gọi hàm này cùng với quá trình khởi động của ứng dụng):

```dart
await initPackage();
```

### Quyền yêu cầu
#### Android
`android/app/src/main/AndroidManifest.xml`
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```
`android/app/build.gradle`
```
android {
  compileSdkVersion 31

  ...
}
```
#### IOS
`Info.plist`
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

### Cấu hình với GetStorage
#### Menu
Cấu hình thông tin menu
- Box name: `vncitizens_home`.
- Key: `menu`.
- Cấu trúc dữ liệu:
```json
[
  {
    "groupName": "example",
    "menu": [
      {
        "icon": "packages/vncitizens_home/assets/icon/camera.png",
        "name": "Camera",
        "requiredLogin": true,
        "route": "/camera"
      },
      {
        "icon": "packages/vncitizens_home/assets/icon/asxh.png",
        "name": "Bảo hiểm xã hội",
        "requiredLogin": false,
        "webUrl": "https://baohiemxahoi.gov.vn/Pages/default.aspx"
      },
      {
        "networkIcon": "https://iscsstaticdev.digigov.vn/icon/youtube.png",
        "name": "Youtube",
        "deeplink": "https://youtube.com"
      },
      {
        "networkIcon": "https://iscsstaticdev.digigov.vn/icon/5x-5x/pcd_covid19.png",
        "name": "Covid 19",
        "inAppBrowserUrl": "https://pccovid.gov.vn/"
      },
      {
        "networkIcon": "https://example.com/menu_icon.png",
        "name": "SMS",
        "sms": "0987654321"
      },
      {
        "networkIcon": "https://example.com/menu_icon.png",
        "name": "Email",
        "email": "example@vnpt.vn"
      },
      {
        "networkIcon": "https://iscsstaticdev.digigov.vn/icon/5x-5x/pcd_covid19.png",
        "name": "call",
        "call": "0987654321"
      },
      {
        "networkIcon": "https://iscsstaticdev.digigov.vn/icon/5x-5x/pcd_covid19.png",
        "name": "Covid 19",
        "child": [
          {
            "networkIcon": "https://iscsstaticdev.digigov.vn/icon/example.png",
            "name": "Example",
            "deeplink": "https://youtube.com"
          },
        ]
      }
    ]
  }
]
```

Nếu không tìm thấy dữ liệu trong GetStorage một danh sách các menu mặc định sẽ được hiển thị. Xem chi tiết các menu mặc định tại `lib/src/config/app_config.dart`.

#### Open Weather
Cấu hình thông tin OpenWeather
- Box name: `vncitizens_home`.
- Key: `weather`.
- Cấu trúc dữ liệu:
```json
{
  "key": "856822fd8e22db5e1ba48c0e7d65566a"
}
```

#### Group Menu
Dùng để chỉ định giao diện có gom nhóm menu hay không
- Box name: `vncitizens_home`.
- Key: `is_group_menu`.
- Kiểu dữ liệu `boolean`: 
  - `true`: gom nhóm
  - `false`: không gom nhóm

#### Banner
Dùng để cấu hình danh sách hình ảnh hiển thị trên đầu màn hình HOME
- Box name: `vncitizens_home`.
- Key: `banner`.
- Cấu trúc dữ liệu:
```json
{
  "images": [
    "https://cdn.pixabay.com/photo/2019/05/03/14/24/landscape-4175978_960_720.jpg",
    "https://www.flyhigh.edu.vn/uploads/tu-vung-ve-mien-que-countryside.jpg",
    "https://i.pinimg.com/550x/96/f7/33/96f733006534aa2da5b48aeaa24aa5a4.jpg"
  ]
}
```

#### App
Dùng để hỗ trợ kiểm tra phiên bản và yêu cầu cập nhật phần mêm
- Box name: `vncitizens_home`.
- Key: `app`.
- Cấu trúc dữ liệu:
```json
{
  "version": "1.0.1",
  "updateRequired": true
}
```

### Menu VNPT PAY
- Trang chủ VNPT PAY
```json
{
  "icon": "packages/vncitizens_home/assets/images/menu/vnpt_pay.png",
  "name": "VNPT PAY",
  "route": "/vncitizens_payment"
}
```
- Các dịch vụ
```json
[
  {
      "icon": "packages/vncitizens_home/assets/images/menu/vnpt_pay_electronic.png",
      "name": "Tiền điện",
      "route": "/vncitizens_payment/pay_electronic"
  },
  {
      "icon": "packages/vncitizens_home/assets/images/menu/vnpt_pay_water.png",
      "name": "Tiền nước",
      "route": "/vncitizens_payment/pay_water"
  },
  {
      "icon": "packages/vncitizens_home/assets/images/menu/vnpt_pay_telecom_data.png",
      "name": "Cước viễn thông",
      "route": "/vncitizens_payment/pay_telecom_data"
  },
  {
      "icon": "packages/vncitizens_home/assets/images/menu/vnpt_pay_fee.png",
      "name": "Học phí",
      "route": "/vncitizens_payment/pay_fee"
  }
]
```

### Menu Danh bạ
- **Danh sách**
```json
{
  "icon": "packages/vncitizens_home/assets/images/menu/danh_ba_khan_cap.png",
  "name": "Danh bạ",
  "route": "/vncitizens_emergency_contact"
}
```
- **Group in**
```json
{
  "icon": "packages/vncitizens_home/assets/images/menu/danh_ba_khan_cap.png",
  "name": "Số khẩn cấp",
  "route": "/vncitizens_emergency_contact/group-in/62182e092e28fa5c81b5363a"
}
```
- **Group not in**
```json
{
  "icon": "packages/vncitizens_home/assets/images/menu/danh_ba_khan_cap.png",
  "name": "Trừ số khẩn cấp",
  "route": "/vncitizens_emergency_contact/group-exclude/62182e092e28fa5c81b5363a"
}
```

### Danh sách route
`/vncitizens_home`:  Màn hình home
