import 'package:intl/intl.dart';

class Converter{

  static DateFormat _dayFormatWithSecondsTimeZone = new DateFormat("EEE, dd MMM yyyy HH:mm:ss zzz");
  static DateFormat _dayFormatWithSeconds = new DateFormat("EEE, dd MMM yyyy HH:mm:ss");
  static DateFormat _dayFormatWithHour = new DateFormat("EEE, dd MMM yyyy hh:mm a");
  static DateFormat _dayFormat = new DateFormat("EEE, dd MMM yyyy");
  static DateFormat _monthFormat = new DateFormat("MMM yyyy");
  static DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");
  static DateFormat _hourFormat = new DateFormat("hh:mm a");
  final formatCurrency = NumberFormat.simpleCurrency(
    locale: 'IDR',
    decimalDigits: 0,
  );

  static List<DateFormat> _dateFormatArray = [null, _dayFormatWithSecondsTimeZone, _dayFormatWithSeconds, _dayFormatWithHour,_dayFormat, _dateFormat];

  static __dateConverterForEach(String time, DateFormat source){
    if (time != null){
      try {
        DateTime dateTime = source!=null?source.parse(time):DateTime.parse(time);
        DateTime dateConverted = dateTime.add(Duration(hours: 7));
        return dateConverted;
      } on Exception catch (_) {

      }
    }
    return null;
  }

  static __dateConverter(String time){
    var result;
    for (final dt in _dateFormatArray){
      result = __dateConverterForEach(time, dt);
      if(result!=null){
        return result;
      }
    }
    return result;
  }

  static int daysLeft(String targetTime, {DateTime startTime}){
    DateTime _targetTime = __dateConverter(targetTime)??DateTime.now();
    DateTime _startTime = startTime??DateTime.now();

    if (_targetTime.isAfter(_startTime))
      return _targetTime.difference(_startTime).inDays;
    else
      return 0;
  }

  static String depositExpired(String paymentAt, {longMonth=false}){
    try {
      int depositExpiredinHours = 24;
      DateTime paymentdt = __dateConverter(paymentAt);
      DateTime dt = paymentdt.add(Duration(hours: depositExpiredinHours));
      return _day[dt.weekday%7]+", "+
          dt.day.toString()+" "+
          (longMonth?_longMonth[dt.month-1]:_shortMonth[dt.month-1])+" "+
          dt.year.toString()+" "+
          _hourFormat.format(dt);
    } catch (e) {
    }
    return null;
  }

  static bool isOTPExpired(String lastKnownOTP){
    int minutesExpiredinMinutes = 15;
    try {
      DateTime lastOTPTime = DateTime.parse(lastKnownOTP);
      Duration difference = DateTime.now().difference(lastOTPTime);
      if (difference.inMinutes < minutesExpiredinMinutes){
        return false;
      }else{
        return true;
      }
    } catch (e) {
      return true;
    }
  }

  static int safeInt(String number){
    try {
      return int.parse(number);
    } catch (e) {
      return 0;
    }
  }

  static dayHour(String time){
    DateTime dt = __dateConverter(time);
    return dt!=null?Converter._dayFormatWithHour.format(dt):time;
  }

  static monthOnly(String time){
    DateTime dt = __dateConverter(time);
    return dt!=null?Converter._monthFormat.format(dt):time;
  }

  static dayOnly(String time){
    DateTime dt = __dateConverter(time);
    return dt!=null?Converter._dayFormat.format(dt):time;
  }

  static dollar(double number){
    return number!=null?("\$"+NumberFormat("###,###,###,###").format(number)):'-';
  }

  static rupiah(double number){
    return number!=null?"Rp. ${dotFormat(number)}":'-';
  }

  static dotFormat(double number){
    return number!=null?swapDot(NumberFormat("###,###,###,###").format(number)):'';
  }

  static dotFormatWithDecimal(double number){
    return number!=null?swapDot(NumberFormat("###,###,###,###.##").format(number)):'';
  }

  static swapDot(String value){
    return value.replaceAll('.', '//').replaceAll(',', '.').replaceAll('//', ',');
  }



   String priceFormat(double price) {
    return formatCurrency.format(price);
  }

  static simplifyNumber(double number){
    if(number != null){
      if (number < 1000000){
        return dotFormat(number);
      }
      // juta
      else if(number < 1000000000){
        return dotFormatWithDecimal((number/1000000)) + ' jt ';
      }
      // miliyar
      else if(number < 1000000000000){
        return dotFormatWithDecimal((number/1000000000)) + ' M ';
      }
      // triliun
      else {
        return dotFormatWithDecimal((number/1000000000000)) + ' T ';
      }
    }
    return 0;
  }


  static List<String> _day = ['Minggu',"Senin","Selasa","Rabu","Kamis","Jum'at","Sabtu"];
  static List _longMonth = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  static List _shortMonth = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  static List _roman = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII"];

  static dayHourIndo(String time, {longMonth: false}){
    DateTime dt = __dateConverter(time);
    return dt==null?time:(
        _day[dt.weekday%7]+", "+
            dt.day.toString()+" "+
            (longMonth?_longMonth[dt.month-1]:_shortMonth[dt.month-1])+" "+
            dt.year.toString()+" "+
            _hourFormat.format(dt)
    );
  }

  static dayOnlyIndo(String time, {longMonth: false}){
    DateTime dt = __dateConverter(time);
    return dt==null?time:(
        _day[dt.weekday%7]+", "+
            dt.day.toString()+" "+
            (longMonth?_longMonth[dt.month-1]:_shortMonth[dt.month-1])+" "+
            dt.year.toString());
  }

  static timeToStringIndo(DateTime time,{longMonth:false}){
    String result;
    if(time.day<10){
      if(!longMonth)
      result = "0${time.day} ${_shortMonth[time.month-1]} ${time.year}";
      else
        result = "0${time.day} ${_longMonth[time.month-1]} ${time.year}";
    } else {
      if(!longMonth)
        result = "${time.day} ${_shortMonth[time.month-1]} ${time.year}";
      else
        result = "${time.day} ${_longMonth[time.month-1]} ${time.year}";
    }
    return result;
  }
  static timeToStringIndoMonthOnly(DateTime time,{longMonth:false}){
    String result;
    if(time.day<10){
      if(!longMonth)
      result = "0${time.day} ${_shortMonth[time.month-1]}";
      else
        result = "0${time.day} ${_longMonth[time.month-1]}";
    } else {
      if(!longMonth)
        result = "${time.day} ${_shortMonth[time.month-1]}";
      else
        result = "${time.day} ${_longMonth[time.month-1]}";
    }
    return result;
  }

  static dayOnlyIndoDateTimePicker(String time, {longMonth: false}){
    return __dateConverter(time);
  }

  static monthOnlyIndo(String time, {longMonth: false}){
    DateTime dt = __dateConverter(time);
    return dt==null?time:(
        (longMonth?_longMonth[dt.month-1]:_shortMonth[dt.month-1])+" "+
            dt.year.toString());
  }

  static monthId(String time){
    DateTime dt = __dateConverter(time);
    return DateFormat('yyyy-MM').format(dt);
  }

  static longMonthID(String month){
    try {
      DateTime dt = DateFormat('yyyy-MM').parse(month);
      return DateFormat('MMM yyyy').format(dt);
    } catch (e) {
      return month;
    }
  }

  static String getRoman(int n){
    return _roman[n>0?(n-1):n];
  }
}