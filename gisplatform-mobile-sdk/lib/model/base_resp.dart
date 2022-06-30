class BaseResp {
  BaseResp(
    this.error,
    this.msg,
    this.result,
  );

  final int error;
  final String? msg;
  final dynamic result;
}
