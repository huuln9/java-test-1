import 'package:get/get.dart';

class ViTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'vi': {
      'xin chao ten': 'Xin chào @name',
      'dang nhap': 'Đăng nhập',
      'dang xuat': 'Đăng xuất',
      'ban chua dang nhap': 'Bạn chưa đăng nhập',
      'thong tin nguoi dung': 'Thông tin người dùng',
      'tai khoan/so dien thoai/email *': 'Tài khoản/Số điện thoại/Email *',
      'mat khau *': 'Mật khẩu *',
      'quen mat khau?': 'Quên mật khẩu?',
      'dang ky': 'Đăng ký',
      'hoac': 'Hoặc',
      'dang nhap bang khuon mat': 'Đăng nhập bằng khuôn mặt',
      'thong tin dang nhap chua dung!': 'Thông tin đăng nhập chưa đúng!',
      'ho ten *': 'Họ tên *',
      'so dien thoai *': 'Số điện thoại *',
      'nhap lai mat khau *': 'Nhập lại mật khẩu *',
      'xac nhan mat khau *': 'Xác nhận mật khẩu *',
      'chup chan dung va quet giay to ca nhan cua ban de dang ky': "Chụp chân dung hoặc quét giấy tờ cá nhân của bạn để đăng ký",
      'vui long nhap ho ten': "Vui lòng nhập họ tên",
      'do dai toi da 64 ky tu': "Độ dài tối đa 64 ký tự",
      'vui long nhap so dien thoai': "Vui lòng nhập số điện thoại",
      'so dien thoai khong hop le': "Số điện thoại không hợp lệ",
      'do dai toi da 128 ki tu': "Độ dài tối đa 128 ký tự",
      'email khong hop le': "Email không hợp lệ",
      'vui long nhap mat khau': "Vui lòng nhập mật khẩu",
      'mat khau it nhat 8 ky tu': 'Mật khẩu ít nhất 8 ký tự',
      'mat khau nhap khong khop': 'Mật khẩu nhập không khớp',
      "chua cap nhat": "Chưa cập nhật",
      'quan ly tai khoan': "Quản lý tài khoản",
      "them giay to ca nhan": "Thêm giấy tờ cá nhân",
      "doi mat khau": "Đổi mật khẩu",
      "thanh cong": "Thành công",
      "that bai": "Thất bại",
      "dang ky tai khoan thanh cong": "Đăng ký tài khoản thành công",
      "dang ky tai khoan that bai": "Đăng ký tài khoản thất bại",
      "ma xac thuc se het han sau": "Mã xác thực sẽ hết hạn sau",
      "giay": "giây",
      "ma xac thuc da duoc gui den so dien thoai": "Mã xác thực đã được gửi đến số điện thoại",
      "nhap ma xac thuc": "Nhập mã xác thực",
      "ma xac thuc otp khong dung hoac da het han su dung": "Mã xác thực OTP không đúng hoặc đã hết hạn sử dụng",
      "dong y": "Đồng ý",
      "gui lai ma": "Gửi lại mã",
      "xac thuc otp": "Xác thực OTP",
      "luu lai": "Lưu lại",
      "cap nhat thong tin thanh cong": "Cập nhật thông tin thành công",
      "cap nhat thong tin that bai": "Cập nhật thông tin thất bại",
      "mat khau hien tai": "Mật khẩu hiện tại",
      "mat khau moi": "Mật khẩu mới",
      "nhap lai mat khau moi": "Nhập lại mật khẩu mới",
      "mat khau khong khop!": "Mật khẩu không khớp!",
      "so dien thoai khong ton tai": "Số điện thoại không tồn tại",
      "so dien thoai/email": "Số điện thoại/email",
      "quen mat khau": "Quên mật khẩu",
      "email khong ton tai": "Email không tồn tại",
      "gui ma otp": "Gửi mã otp",
      "ma xac thuc da duoc gui den email": "Mã xác thực đã gửi đến email",
      "email da ton tai": "Email đã tồn tại",
      "ban vui long lua chon loai giay to tuy than phu hop de dang ky tai khoan": "Bạn vui lòng lựa chọn loại giấy tờ tùy thân phù hợp để đăng ký tài khoản",
      "ho chieu": "Hộ chiếu",
      "chup 2 mat truoc va sau de hoan thanh xac thuc": "Chụp 2 mặt trước và sau của %s để hoàn thành xác thực",
      "tiep tuc": "Tiếp tục",
      "ho va ten": "Họ và tên",
      "quet lai": "Quét lại",
      "gioi tinh": "Giới tính",
      "nam": "Nam",
      "nu": "Nữ",
      "khong bo trong truong nay": "Không bỏ trống trường này",
      "vui long chon gioi tinh": "Vui lòng chọn giới tính",
      "so can cuoc cong dan": "Số căn cước công dân",
      "so chung minh nhan dan": "Số chứng minh nhân dân",
      "so ho chieu": "Số hộ chiếu",
      "ngay cap": "Ngày cấp",
      "noi cap": "Nơi cấp",
      "quoc gia": "Quốc gia",
      "tinh/thanh pho": "Tỉnh/Thành phố",
      "quan/huyen": "Quận/Huyện",
      "phuong/xa": "Phường/Xã",
      "dia chi": "Địa chỉ",
      "ngay sinh": "Ngày sinh",
      "que quan": "Quê quán",
      "noi thuong tru": "Nơi thường trú",
      "dang ky tai khoan": "Đăng ký tài khoản",
      "so dien thoai da ton tai": "Số điện thoại đã tồn tại",
      "giay to ca nhan": "Giấy tờ cá nhân",
      "can cuoc cong dan": "Căn cước công dân",
      "chung minh nhan dan": "Chứng minh nhân dân",
      "xac thuc khuon mat that bai": "Xác thực khuôn mặt thất bại",
      "chon vung anh dai dien": "Chọn vùng ảnh đại diện",
      "Khong the tai anh len": "Không thể tải ảnh lên",
      "tai khoan khac": "Tài khoản khác",
      "khong tim thay ma nguoi dung": "Không tìm thấy mã người dùng",
      "khong tim thay FaceID": "Không tìm thấy FaceID",
      "ban chua dang ky xac thuc bang khuon mat": "Bạn chưa đăng ký xác thực bằng khuôn mặt",
      "da xay ra loi": "Đã xảy ra lỗi",
      "dang xu ly": "Đang xử lý",
      "mat khau hien tai chua dung": "Mật khẩu hiện tại chưa đúng",
      'trung voi mat khau hien tai': "Trùng với mật khẩu hiện tại",
      'mat khau moi phai khac mat khau cu': "Mật khẩu mới phải khác mật khẩu cũ",
      "ban da nhap sai": "Bạn đã nhập sai",
      "lan": "lần",
      "vui long dang nhap lai sau": "Vui lòng đăng nhập lại sau",
      "vui long chon giay to ca nhan cap nhat": "Vui lòng chọn giấy tờ cá nhân cập nhật",
      "nhap day du thong tin tren giay to": "Nhập đầy đủ thông tin trên giấy tờ",
      "huy": "Hủy",
      "khuon mat khong khop": "Khuôn mặt không khớp",
      "thong bao": "Thông báo",
      "vui long nhap email": "Vui lòng nhập email",
      "ban da tat tinh nang dang nhap bang khuon mat": "Bạn đã tắt tính năng đăng nhập bằng khuôn mặt",
      "tai khoan cua ban da tat tinh nang dang nhap bang khuon mat": "Tài khoản của bạn đã tắt tính năng đăng nhập bằng khuôn mặt",
      "loi luu hinh anh": "Lỗi lưu hình ảnh",
      "chi cho phep ky tu so": "Chỉ cho phép ký tự số",
      "chua hop le, do dai phai 12 ky tu": "Chưa hợp lệ, độ dài phải 12 ký tự",
      "chua hop le, do dai phai 9 ky tu": "Chưa hợp lệ, độ dài phải 9 ký tự",
      "dia chi hien tai": "Địa chỉ hiện tại",
      "khong tim thay quoc gia": "Không tìm thấy quốc gia",
      "chi tiet dia chi": "Chi tiết địa chỉ",
      "vui long chon du lieu": "Vui lòng chọn dữ liệu",
      "vui long nhap du lieu": "Vui lòng nhập dữ liệu",
      "dang xu ly. vui long cho giay lat": "Đang xử lý. Vui lòng chờ giây lát",
      "cap nhat du lieu that bai": "Cập nhật dữ liệu thất bại"
    },
  };
}