class ResponseBody {
  final String status;
  final String? message;
  final dynamic data;

  ResponseBody({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponseBody.fromJson(Map<String, dynamic> json) {
    return ResponseBody(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
