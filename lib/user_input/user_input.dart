import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';

class UserInput extends StatefulWidget {
  const UserInput(
      {super.key,
      required this.task,
      required this.removeM,
      required this.saveTasks});

  final Task task;
  final Function removeM;
  final Function saveTasks;

  @override
  State<UserInput> createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  late TextEditingController controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    controller = TextEditingController(text: widget.task.task);
    _focusNode = FocusNode();
    if (widget.task.task == null || widget.task.task!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color.fromARGB(255, 194, 108, 79),
      child: Dismissible(
        background: dismissibleBackground(),
        key: Key(widget.task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          widget.removeM(widget.task.id);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: widget.task.isChecked
                    ? const Color.fromARGB(160, 255, 255, 255)
                    : const Color.fromARGB(210, 255, 255, 255),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.task.isChecked
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: widget.task.isChecked
                        ? const Color.fromARGB(255, 194, 108, 79)
                        : null,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                          controller: controller,
                          focusNode: _focusNode,
                          enabled: !widget.task.isChecked,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          minLines: 1,
                          cursorColor: const Color.fromARGB(255, 194, 108, 79),
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your task',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(
                            decoration: widget.task.isChecked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor:
                                const Color.fromARGB(255, 194, 108, 79),
                          ),
                          onEditingComplete: () {
                            setState(() {
                              widget.task.task = controller.text;
                            });
                            widget.saveTasks();
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            widget.task.task = value;
                            widget.saveTasks();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onLongPress: () {
        setState(() {
          widget.task.isChecked = !widget.task.isChecked;
        });
        widget.saveTasks();
      },
    );
  }

  Container dismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFB4161B),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(2, 2),
            spreadRadius: 0,
            color: Color.fromARGB(60, 0, 0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.only(right: 24),
      child: const Icon(
        Icons.delete_rounded,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}
