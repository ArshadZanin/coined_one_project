import 'package:coined_one/core/contants.dart';
import 'package:coined_one/domain/schedules/models/schedule_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ISchedulesRepo)
class ISchedulesRepo {
  Future<void> setSchedule({
    required String name,
    required String startTime,
    required String endTime,
    required String date,
  }) async {
    try {
      var dio = Dio();
      Response response = await dio.post('${Constants.apiLink}/save/schedule',
          data: {
            "name": name,
            "startTime": startTime,
            "endTime": endTime,
            "date": date
          });
      print({
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "date": date
      });

      if (response.statusCode == 200) {
        Map data = response.data;
        if (data['success']) {
          print('success');
          print(data['data']);
        } else {
          print(response.statusCode);
        }
      }
    } on DioError {
      print('dio error');
    } catch (e) {
      print(e);
    }
  }

  Future<List<ScheduleModel>?> getSchedule() async {
    try {
      var dio = Dio();
      Response response = await dio.get(
        '${Constants.apiLink}/schedule',
      );
      if (response.statusCode == 200) {
        Map data = response.data;
        if (data['success']) {
          print('success');
          List<dynamic> mapData = data['data'];
          print(data['data']);
          List<ScheduleModel> models =
              mapData.map((e) => ScheduleModel.fromJson(e)).toList();
          models.sort(((a, b) => a.date!.compareTo(b.date!)));
          return models;
        }
      } else {
        print(response.statusCode);
      }
    } on DioError {
      print('dio error');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
