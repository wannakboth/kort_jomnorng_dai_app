import 'package:khmer_chhankitek/khmer_chhankitek.dart';

formatKhmerDate() {
  String formateDate =
      '${Chhankitek.now().solarDay} ${Chhankitek.now().solarMonth} ${Chhankitek.now().solarYear}';
  return formateDate.toString();
}
