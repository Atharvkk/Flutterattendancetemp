
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Debt Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: AttendanceTracker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AttendanceTracker extends StatefulWidget {
  @override
  _AttendanceTrackerState createState() => _AttendanceTrackerState();
}

class _AttendanceTrackerState extends State<AttendanceTracker> {
  int days = 0;
  bool isEditing = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDays();
  }

  _loadDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      days = prefs.getInt('attendance_days') ?? 0;
    });
  }

  _saveDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('attendance_days', days);
  }

  void _addDay() {
    setState(() {
      days += 1;
    });
    _saveDays();
  }

  void _subtractDays() {
    setState(() {
      days -= 3;
    });
    _saveDays();
  }

  void _editDays() {
    _controller.text = days.toString();
    setState(() {
      isEditing = true;
    });
  }

  void _saveDaysEdit() {
    int? newValue = int.tryParse(_controller.text);
    if (newValue != null) {
      setState(() {
        days = newValue;
        isEditing = false;
      });
      _saveDays();
    }
  }

  void _cancelEdit() {
    setState(() {
      isEditing = false;
    });
  }

  Color _getDaysColor() {
    return days < 0 ? Colors.red : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Attendance Debt Tracker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Days Display Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _editDays,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: _getDaysColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getDaysColor().withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: isEditing
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 100,
                                    child: TextField(
                                      controller: _controller,
                                      keyboardType: TextInputType.numberWithOptions(signed: true),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: _getDaysColor(),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      autofocus: true,
                                      onSubmitted: (_) => _saveDaysEdit(),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: _saveDaysEdit,
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: _cancelEdit,
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Text(
                                '$days',
                                style: TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: _getDaysColor(),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'DAYS',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    if (!isEditing) ...[
                      SizedBox(height: 12),
                      Text(
                        'Tap to edit',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Buttons
              Row(
                children: [
                  // Absent Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _subtractDays,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'ABSENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '(-3 days)',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 20),
                  
                  // Present Button
                  Expanded(
                    child: GestureDetector(
                      onTap: _addDay,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'PRESENT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              '(+1 day)',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Status Indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: _getDaysColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: _getDaysColor().withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getDaysColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      days < 0 ? 'IN DEBT' : days == 0 ? 'BALANCED' : 'IN CREDIT',
                      style: TextStyle(
                        color: _getDaysColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
