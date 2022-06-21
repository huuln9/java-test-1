class PaymentRouteConstant {
  static const String paymentRoute = "/vncitizens_payment";
  static const String paymentElectronic = "/vncitizens_payment/pay_electronic";
  static const String paymentWater = "/vncitizens_payment/pay_water";
  static const String paymentVnptData = "/vncitizens_payment/pay_vnpt_data";
  static const String paymentHTVC = "/vncitizens_payment/pay_htvc";
  static const String paymentKplus = "/vncitizens_payment/pay_kplus";
  static const String paymentVTVCab = "/vncitizens_payment/pay_vtvcap";
  static const String paymentMyTVNet = "/vncitizens_payment/pay_mytv_net";
  static const String paymentTelecom = "/vncitizens_payment/pay_telecom";
  static const String paymentTelecomV2 = "/vncitizens_payment/pay_telecom_v2";
  static const String paymentInternet = "/vncitizens_payment/pay_internet";
  static const String paymentStaticPhone = "/vncitizens_payment/pay_static_phone";
  static const String paymentVinaIDVoucher = "/vncitizens_payment/pay_vina_id_voucher";
  static const String paymentVinaID = "/vncitizens_payment/pay_vina_id";
  static const String paymentVNEduFee = "/vncitizens_payment/pay_vnedu_fee";
  static const String paymentCastInToWallet = "/vncitizens_payment/pay_cast_into_wallet";
  static const String paymentTransferInToWallet = "/vncitizens_payment/pay_transfer_into_wallet";
  static const String paymentTelecomData = "/vncitizens_payment/pay_telecom_data";
  static const String paymentFee = "/vncitizens_payment/pay_fee";

  static const Map<String, String> paymentMethodMap = {
    paymentRoute: "openPay",
    paymentElectronic: "thanhToanTienDien",
    paymentWater: "thanhToanNuoc",
    paymentVnptData: "thanhToanVnpData",
    paymentHTVC: "thanhToanHTVC",
    paymentKplus: "thanhtoanKPlus",
    paymentVTVCab: "thanhToanVTVCab",
    paymentMyTVNet: "thanhToanMyTvNet",
    paymentTelecom: "thanhToanDonHangVnptVienThong",
    paymentTelecomV2: "thanhToanHoaDonVienThongV2",
    paymentInternet: "thanhToanInterNet",
    paymentStaticPhone: "thanhToanDienThoaiCoDinh",
    paymentVinaIDVoucher: "thanhToanVinaIDVoucher",
    paymentVinaID: "thanhToanVinaID",
    paymentVNEduFee: "thanhToanHocPhiVnedu",
    paymentCastInToWallet: "napTien",
    paymentTransferInToWallet: "chuyenTien",
    paymentTelecomData: "thanhToanCuoc",
    paymentFee: "thanhToanHocPhi"
  };

  static const List<String> paymentRoutes = [
    paymentRoute,
    paymentElectronic,
    paymentWater,
    paymentVnptData,
    paymentHTVC,
    paymentKplus,
    paymentVTVCab,
    paymentMyTVNet,
    paymentTelecom,
    paymentTelecomV2,
    paymentInternet,
    paymentStaticPhone,
    paymentVinaIDVoucher,
    paymentVinaID,
    paymentVNEduFee,
    paymentCastInToWallet,
    paymentTransferInToWallet,
    paymentTelecomData,
    paymentFee
  ];
}
