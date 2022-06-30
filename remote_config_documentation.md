# Ứng dụng công dân số vnCitizens v2: Remote Config Documentation

Tài liệu hướng dẫn tạo hoặc cập nhật remote config cho app vnCitizens.

Một số lưu ý chung:

* Các tham số kiểu Object (ngoại trừ giá trị là Array) cũng được mô tả chi tiết đến từng trường cụ thể. Người cấu hình có thể linh động chuyển sang kiểu Object trong quá trình định nghĩa bằng giao diện hoặc tạo file import.
* Những tham số, trường thông tin không được đề cập có thể đặt tự do. 
* Các kiểu dữ liệu chấp nhận gồm String, Boolean, Integer, Double, Object (trường hợp giá trị là Array)

## Tạo cấu hình chung

Các trường thông tin chung:

* Mã cấu hình: Phụ thuộc vào giá trị được đặt cho biến môi trường `REMOTE_CONFIG_URL`.
* Nhóm cấu hình: Là các domain cần truy cập không bao gồm giao thức. Ví dụ `demo.digigov.vn`.
* Trạng thái: Mở
* Công khai: Có

**Ứng dụng (flutter_vncitizens)**

Danh sách tham số bắt buộc

| KEY                                              | DATA TYPE | DESCRIPTION       |
| ------------------------------------------------ | --------- | ----------------- |
| flutter_vncitizens.androidFirebaseOptions.apiKey | String    | Android FCM key   |
| flutter_vncitizens.iosFirebaseOptions.apiKey     | String    | IOS FCM key       |
| flutter_vncitizens.initialRoute                  | String    | App default route |

Danh sách tham số tùy chỉnh

| KEY                             | DATA TYPE | DESCRIPTION                       |
| ------------------------------- | --------- | --------------------------------- |
| flutter_vncitizens.requireLogin | Boolean   | Yêu cầu đăng nhập khi sử dụng App |
| flutter_vncitizens.copyright    | String    | Thông tin bản quyền               |



**Module Common (vncitizens_common)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Home (vncitizens_home)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_home.menu | Object | Danh sách menu động |
| vncitizens_home.is_group_menu | Boolean | Xác định nhóm menu hay không |
| vncitizens_home.banner | Object | Danh sách hình ảnh banner |
| vncitizens_home.app | Object | Thông tin app và xác định bắt buộc cập nhật hay không |

**Lưu ý: Xem cấu hình chi tiết tại `packages/vncitizens_home/README.md`**

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Quét mã QR (vncitizens_qrcode)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Cổng thông tin (vncitizens_portal)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_portal.newsResources | Array | Danh sách nguồn tin |
| vncitizens_portal.newsResources.name | String | Tên nguồn tin |
| vncitizens_portal.newsResources.tokenEndpoint | String | Token endpoint |
| vncitizens_portal.newsResources.apiEndpoint | String | API endpoint |
| vncitizens_portal.newsResources.username | String | Tài khoản Basic Auth |
| vncitizens_portal.newsResources.password | String | Mật khẩu Basic Auth |
| vncitizens_portal.newsResources.active | Boolean | Mặc định load tin từ nguồn này (True: có, False: không) |
| vncitizens_portal.newsResources.defaultCategories | Array | Danh sách các chuyên mục mặc định (Mặc định load tin từ các chuyên mục này nếu vncitizens_portal.newsResources.active = true) |
| vncitizens_portal.newsResources.defaultCategories.ChuyenMucID | Integer | Mã chuyên mục |
| vncitizens_portal.newsResources.defaultCategories.TenChuyenMuc | String | Tên chuyên mục |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Cổng thông tin (vncitizens_garbage_schedule)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_garbage_schedule.place | Object | Địa điểm mặc định đang triển khai |
| vncitizens_garbage_schedule.place.province | Object | Tỉnh mặc định đang triển khai |
| vncitizens_garbage_schedule.place.province.id | String | Mã tỉnh mặc định đang triển khai |
| vncitizens_garbage_schedule.place.province.name | String | Tên tỉnh mặc định đang triển khai |
| vncitizens_garbage_schedule.place.nation | Object | Quốc gia mặc định đang triển khai |
| vncitizens_garbage_schedule.place.nation.id | String | Mã quốc gia mặc định đang triển khai |
| vncitizens_garbage_schedule.place.nation.name | String | Tên quốc gia mặc định đang triển khai |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Thông báo nhanh (vncitizens_notification)**

Danh sách tham số bắt buộc (**Cần cấu hình JSON file cho từng nền tảng tại source project để nhận được thông báo nhanh*)

| KEY                                                     | DATA TYPE | DESCRIPTION          |
| ------------------------------------------------------- | --------- | -------------------- |
| vncitizens_notification.targetAndroid                   | Object    | Cấu hình FCM Android |
| vncitizens_notification.targetAndroid.apiKey            | String    | FCM Android Key      |
| vncitizens_notification.targetAndroid.appId             | String    | App ID               |
| vncitizens_notification.targetAndroid.messagingSenderId | String    | Project number       |
| vncitizens_notification.targetAndroid.projectId         | String    | Project Id           |
| vncitizens_notification.targetAndroid.storageBucket     | String    | Storage Bucket       |
| vncitizens_notification.targetIOS                       | Object    | Cấu hình FCM IOS     |
| vncitizens_notification.targetIOS.apiKey                | String    | FCM IOS Key          |
| vncitizens_notification.targetIOS.appId                 | String    | App ID               |
| vncitizens_notification.targetIOS.messagingSenderId     | String    | Project number       |
| vncitizens_notification.targetIOS.projectId             | String    | Project Id           |
| vncitizens_notification.targetIOS.storageBucket         | String    | Storage Bucket       |
| vncitizens_notification.targetIOS.iosClientId           | String    | IOS Client Id        |
| vncitizens_notification.targetIOS.iosBundleId           | String    | IOS Bundle Id        |

Danh sách tham số tùy chỉnh

| KEY                               | DATA TYPE     | DESCRIPTION                                                  |
| --------------------------------- | ------------- | ------------------------------------------------------------ |
| vncitizens_notification.fcmTopics | Array<String> | Danh sách topic nhận thông báo nhanh. Mặc định lắng nghe từ topic *vncitizens_notification* |



**Module Dịch vụ công (vncitizens_...)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Bắt số xếp hàng (vncitizens_queue)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_queue.api_endpoint.api | String       | Đường dẫn api endpint         |
| vncitizens_queue.api_endpoint.sso | String       | Đường dẫn api  token         |
| vncitizens_queue.api_endpoint.client_id | String       | client_id lấy token         |
| vncitizens_queue.api_endpoint.client_secret | String       | client_secret lấy token         |
| vncitizens_queue.api_endpoint.agency-id | String       |  mã đơn vị         |
| vncitizens_queue.api_endpoint.parent-id | String       |  mã đơn vị cha         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Đánh giá cán bộ (vncitizens_...)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module chức năng Phản ánh kiến nghị (vncitizens_petition)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_petition.vcall.avatarReceiver | String | Avatar người nhận |
| vncitizens_petition.vcall.dataOptions.avatarUrl | String | Avatar hiển thị khi gọi |
| vncitizens_petition.vcall.tokenCustomer | String | Token khách hàng |
| vncitizens_petition.vcall.dest | Array(String) | Danh sách số điện thoại tổng đài |
| vncitizens_petition.vcall.desName | String | Tên hiển thị khi gọi |

Danh sách tham số tùy chỉnh

| KEY                               | DATA TYPE | DESCRIPTION                                                  |
| --------------------------------- | --------- | ------------------------------------------------------------ |
| vncitizens_petition.tagCategoryId | String    | Mã loại nhãn PAKN. Giá trị mặc định là 5f3a491c4e1bd312a6f00003 |
| vncitizens_petition.exceptStatus  | String    | Các trạng thái muốn ẩn trong tab Tất cả DS PAKN. Ví dụ: 1,2,3 |



**Module Tài khoản cá nhân (vncitizens_account)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_account.citizenIssuerTagId | String | Mã nhãn cơ quan cấp CMND |
| vncitizens_account.placeTypeCategoryId | String | Mã loại nhãn địa điểm hành chính |
| vncitizens_account.defaultNationId | String | Mã quốc gia mặc định |
| vncitizens_account.loginConfig.x | Int | Số lần đăng nhập sai (mức 1) |
| vncitizens_account.loginConfig.p | Int | Thời gian khóa đăng nhập (mức 1) |
| vncitizens_account.loginConfig.y | Int | Số lần đăng nhập sai (mức 2) |
| vncitizens_account.loginConfig.q | Int | Thời gian khóa đăng nhập (mức 2) |
| vncitizens_account.config.loginLogoUrl | String | Cấu hình logo đăng nhập mặc định |
| vncitizens_account.config.requireEmail | String | Cấu hình bắt buộc email khi đăng ký |

**Lưu ý: Số lần đăng nhập sai mức 2 phải lớn hơn mức 1**

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_account.smsConfigId | String | Mã cấu hình sms otp |
| vncitizens_account.emailConfigId | String | Mã cấu hình email otp |



**Module Cài đặt (vncitizens_setting)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_setting.appInfo | Object | Thông tin chia sẻ ứng dụng |
| vncitizens_setting.appInfo.shareTitle | String | Tiêu đề popup chia sẻ (Có thể để "") |
| vncitizens_setting.appInfo.shareChooserTitle | String | Tiêu đề trình chọn chia sẻ (Có thể để "") |
| vncitizens_setting.appInfo.name | String | Tên ứng dụng |
| vncitizens_setting.appInfo.linkCHPlay | String | Link CH Play (Cập nhật app, chia sẻ app) |
| vncitizens_setting.appInfo.linkAppStore | String | Link App Store (Cập nhật app, chia sẻ app) |
| vncitizens_setting.instructionLink | String | Link video youtube hướng dẫn sử dụng app |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| integratedEKYC | Boolean | Tích hợp eKYC (True: có, False: không), mặc định False |

**Module Tìm kiếm địa điểm (vncitizens_place)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_common.vietbando| Object | Cấu hình Việt bản đồ |
| vncitizens_common.vietbando.urlEndPoint| String | Url search toạ độ từ vietbando |
| vncitizens_common.vietbando.RegisterKey| String | Key đăng ký sử dụng của vietbando cung cap|
| vncitizens_common.hcm_opendata| Object | Cấu hình open data source |
| vncitizens_common.hcm_opendata.urlEndPoint| String | Url opendata source của Hồ Chí Minh |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_place.centerLocation| Object | Vị trí trung bản đồ khi vào tính năng |
| vncitizens_place.centerLocation.lat| Double | Vĩ độ |
| vncitizens_place.centerLocation.long| Double | Kinh độ |
| vncitizens_place.config_type_view | Int | Ẩn/hiện bản đồ ở màn hình danh sách (0-Hiển thị Bản đồ ở phần danh sách địa điểm, khác 0 không hiển thị map ở danh sách địa điểm.) | 
| vncitizens_place.place_detail_view_map| Boolean |  Ẩn/hiện bản đồ ở màn hình Chi tiết địa điểm |


**Module Camera (vncitizens_camera)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_camera.config.cameraTagCategoryId | String | Mã loại nhãn camera |
| vncitizens_camera.config.defaultLocation.latitude | Double | Vĩ độ mặc định |
| vncitizens_camera.config.defaultLocation.longitude | Double | Kinh độ mặc định |
| vncitizens_camera.config.enableMap | Boolean | Cho phép hiển thị bản đồ hay không |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Danh bạ (vncitizens_emergency_contact)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| vncitizens_emergency_contact.location_call | Object | Cấu hình Danh bạ khẩn cấp bản v2.0 tích hợp với hệ thống 11x |
| vncitizens_emergency_contact.location_call.urlEndPoint | String | Url api Gửi vị trí toạ độ khi thực hiện cuộc gọi khẩn cấu |
| vncitizens_emergency_contact.location_call.secert_key | String | Key mã hoá dữ liệu JWT  |
| vncitizens_emergency_contact.location_call.data | Array Object | Danh sách số điện thoại và mã dial_number tương ứng  request api|
| vncitizens_emergency_contact.location_call.data.phone | String | Đầu số danh bạ (ví dụ: 113)|
| vncitizens_emergency_contact.location_call.data.number | String | Đầu số danh bạ (ví dụ: 02836228400)|

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Thanh toán (vncitizens_...)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

**Lưu ý: Xem danh sách route cấu hình cho menu thanh toán tại `packages/vncitizens_home/README.md`**


**Module Môi trường (vncitizens_...)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Văn bản nhà nước (vncitizens_administrative_document)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |



**Module Văn bản nhà nước (vncitizens_administrative_document)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

**Module xem thời tiết chi tiết (vncitizens_weather)**

Danh sách tham số bắt buộc

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |

Danh sách tham số tùy chỉnh

| KEY  | DATA TYPE | DESCRIPTION |
| ---- | --------- | ----------- |
| .... | ...       | ...         |


## Tạo cấu hình riêng

.... (tương tự như trên)

