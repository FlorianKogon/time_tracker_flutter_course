import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      leading: Text(
        job.name,
        style: TextStyle(fontSize: 18.0),
      ),
      onTap: onTap,
    );
  }
}
