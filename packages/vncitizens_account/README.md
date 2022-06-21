# vncitizens_account

Module Tài khoản cá nhân của vnCitizens.

## Hướng dẫn sử dụng

```bash
flutter pub add vncitizens_account
```

Thiết lập package (nên gọi hàm này cùng với quá trình khởi động của ứng dụng):

```dart
await initPackage()
```

### Cấu hình với GetStorage

Box name: `vncitizens_account`.

Các tham số:

* `login_redirect_url`: url của ứng dụng redirect về sau khi đăng nhập trên hệ thống SSO. Mặc
  định: `digo://vncitizens_account/user_details`.
* `logout_redirect_url`: url của ứng dụng redirect về sau khi đăng xuất trên OP. Mặc định là giá trị
  của `login_redirect_url`.
* `authorization_endpoint`: url đăng nhập của OP. Ví
  dụ: `https://iscsoidcdev.digigov.vn/auth/realms/iscs/protocol/openid-connect/auth`.
* `token_endpoint`: url lấy access token của OP. Ví
  dụ: `https://iscsoidcdev.digigov.vn/auth/realms/iscs/protocol/openid-connect/token`.
* `end_session_endpoint`: url đăng xuất của OP. Ví
  dụ: `https://iscsoidcdev.digigov.vn/auth/realms/iscs/protocol/openid-connect/logout`.

### Danh sách route

`/vncitizens_account/user_details`: Xem chi tiết thông tin người dùng hoặc hiển thị giao
diện yêu cầu đăng nhập.


