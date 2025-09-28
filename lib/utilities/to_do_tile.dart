import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final bool taskCompleted;
  final bool isHighPriority;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  final int timerInSeconds;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.isHighPriority,
    required this.timerInSeconds,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  late int _remainingTime;
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _remainingTime = 0;
    if (widget.isHighPriority && widget.timerInSeconds > 0) {
      int now = DateTime.now().millisecondsSinceEpoch;
      _remainingTime = ((widget.timerInSeconds - now) / 1000).floor();

      if (_remainingTime > 0) {
        _startTimer();
      } else {
        _remainingTime = 0;
      }
    }
  }

  @override
  void didUpdateWidget(covariant ToDoTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.taskCompleted) {
      _timer?.cancel();
    } else if (!widget.taskCompleted &&
        widget.isHighPriority &&
        _remainingTime > 0 &&
        !(_timer?.isActive ?? false)) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: widget.deleteFunction,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          height: 100, // fixed height so bg image looks better
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/download (5).jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),


              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Row(
                  children: [
                    Checkbox(
                        value: widget.taskCompleted,
                        onChanged: widget.onChanged),
                    Expanded(
                      child: Text(
                        widget.taskName,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          decoration: widget.taskCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!widget.taskCompleted && widget.isHighPriority)
                      _remainingTime > 0
                          ? Flexible(
                        child: Text(
                          "⏱ ${_remainingTime ~/ 60} : ${_remainingTime % 60}",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                          : const Expanded(
                        child: Text(
                          "⚠",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
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
