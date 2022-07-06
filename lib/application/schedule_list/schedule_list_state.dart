part of 'schedule_list_bloc.dart';

class ScheduleListState {
  List<ScheduleModel> schedules;
  ScheduleListState({required this.schedules});
}

class ScheduleListInitial extends ScheduleListState {
  ScheduleListInitial() : super(schedules: []);
}
