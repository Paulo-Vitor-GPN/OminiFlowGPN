import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/scheduling_model.dart';

class SchedulingScreen extends StatefulWidget {
  const SchedulingScreen({Key? key}) : super(key: key);

  @override
  State<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<Appointment> _appointments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(context),
            const SizedBox(height: 30),
            _buildAppointmentList(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAppointmentSheet(context),
        backgroundColor: AppTheme.accentGold,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 400,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: AppTheme.textPrimary),
          weekendTextStyle: TextStyle(color: AppTheme.textSecondary),
          selectedTextStyle: TextStyle(color: AppTheme.background),
          selectedDecoration: BoxDecoration(
            color: AppTheme.accentGold,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.accentBlue.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: AppTheme.textPrimary),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppTheme.textPrimary),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(BuildContext context) {
    final selectedAppointments = _appointments.where((appointment) {
      return _selectedDay != null && isSameDay(appointment.dateTime, _selectedDay!);
    }).toList();

    return GlassCard(
      width: double.infinity,
      height: 200,
      child: selectedAppointments.isEmpty
          ? Center(
              child: Text(
                _selectedDay == null
                    ? 'Selecione uma data para ver os agendamentos.'
                    : 'Nenhum agendamento para esta data.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          : ListView.builder(
              itemCount: selectedAppointments.length,
              itemBuilder: (context, index) {
                final appointment = selectedAppointments[index];
                return ListTile(
                  title: Text(appointment.serviceName, style: TextStyle(color: AppTheme.textPrimary)),
                  subtitle: Text(
                    '${appointment.customerName} - ${DateFormat('HH:mm').format(appointment.dateTime)}',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary),
                  onTap: () {
                    // TODO: Implement appointment details view
                  },
                );
              },
            ),
    );
  }

  void _showAddAppointmentSheet(BuildContext context) {
    final TextEditingController _customerNameController = TextEditingController();
    final TextEditingController _serviceNameController = TextEditingController();
    DateTime _selectedDate = _selectedDay ?? DateTime.now();
    TimeOfDay _selectedTime = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Novo Agendamento',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Cliente',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                ),
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: 'Serviço',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                ),
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text(
                  'Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                trailing: Icon(Icons.calendar_today, color: AppTheme.accentGold),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: AppTheme.accentGold, // header background color
                            onPrimary: AppTheme.background, // header text color
                            onSurface: AppTheme.textPrimary, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.accentGold, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(
                  'Hora: ${_selectedTime.format(context)}',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                trailing: Icon(Icons.access_time, color: AppTheme.accentGold),
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: AppTheme.accentGold, // header background color
                            onPrimary: AppTheme.background, // header text color
                            onSurface: AppTheme.textPrimary, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.accentGold, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != _selectedTime) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newAppointment = Appointment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    customerName: _customerNameController.text,
                    serviceName: _serviceNameController.text,
                    dateTime: DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      _selectedTime.hour,
                      _selectedTime.minute,
                    ),
                  );
                  setState(() {
                    _appointments.add(newAppointment);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Adicionar Agendamento'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
