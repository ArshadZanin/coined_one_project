import 'package:bloc/bloc.dart';
import 'package:coined_one/core/contants.dart';
import 'package:coined_one/domain/schedules/i_schedules_repo.dart';
import 'package:coined_one/domain/schedules/models/schedule_model.dart';
import 'package:injectable/injectable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'schedule_list_event.dart';
part 'schedule_list_state.dart';

@injectable
class ScheduleListBloc extends Bloc<ScheduleListEvent, ScheduleListState> {
  final ISchedulesRepo schedulesRepo = ISchedulesRepo();
  ScheduleListBloc() : super(ScheduleListInitial()) {
    on<GetSchedule>((event, emit) async {
      List<ScheduleModel> scheduleList = await schedulesRepo.getSchedule() ?? [];
      return emit(ScheduleListState(schedules: scheduleList));
    });
  }

  
}
