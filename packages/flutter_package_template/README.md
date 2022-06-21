# flutter_package_template

Source code mẫu để phát triển Flutter package.

### Quy tắc chung

Tên project (tên package) đặt theo quy tắc snake_case. Ví dụ: flutter_example. Đối với Application,
đặt Organization theo cấu trúc: vn.vnpt.{tensanpham}. Ví dụ: vn.vnpt.vncitizens.

Tên file và folder đặt theo quy tắc snake_case. Ví dụ: home_widget.dart.

Tên class đặt theo quy tắc PascalCase. Ví dụ: HomeWidget.

Chỉ nên export model, service, translation và wigdet. Hạn chế hoặc không nên export controller và
core.

Class bên trong package nên import trực tiếp các class khác của chúng, không nên import thông qua
file main (file dùng để export, có tên là tên package).