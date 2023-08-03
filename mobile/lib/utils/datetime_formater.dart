import 'package:intl/intl.dart';

class DateTimeFormatterHelper {
  static String formatToDateTime(String givenTime) {
    try {
      DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
      DateTime dateTime = DateTime.parse(givenTime);
      return formatter.format(dateTime);
    } catch (e) {
      return givenTime;
    }
  }

  static String formatToDDMMYYYY(String givenTime) {
    try {
      DateFormat formatter = DateFormat('dd-MM-yyyy');
      DateTime dateTime = DateTime.parse(givenTime);
      return formatter.format(dateTime);
    } catch (e) {
      return givenTime;
    }
  }

  static String timeDifference(String givenTime) {
    try {
      // Định dạng ngày và giờ thành chuỗi
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      DateTime dateTime = DateTime.parse(givenTime);

      // Tính khoảng cách giữa thời gian hiện tại và thời gian đã cho
      Duration difference = DateTime.now().difference(dateTime);

      // Kiểm tra khoảng cách thời gian để hiển thị theo định dạng phù hợp
      if (difference.inDays >= 30) {
        // Hiển thị theo định dạng "ngày/tháng/năm"
        return formatter.format(dateTime);
      } else if (difference.inDays > 7) {
        // Hiển thị theo định dạng "mấy tuần"
        return "${difference.inDays ~/ 7} tuần trước";
      } else if (difference.inDays > 0) {
        // Hiển thị theo định dạng "mấy ngày"
        return "${difference.inDays} ngày trước";
      } else if (difference.inHours > 0) {
        // Hiển thị theo định dạng "mấy giờ"
        return "${difference.inHours} giờ trước";
      } else if (difference.inMinutes > 0) {
        // Hiển thị theo định dạng "mấy phút"
        return "${difference.inMinutes} phút ";
      } else {
        // Hiển thị theo định dạng "mấy giây"
        return "${difference.inSeconds} giây trước";
      }
    } catch (e) {
      return "errror";
    }
  }
}
