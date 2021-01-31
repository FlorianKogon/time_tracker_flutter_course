import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job}) : super(key: key);
  final Job job;

  static Future<void> show(BuildContext context, {Database database, Job job}) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  final Database database;

  @override
  _EditJobPageState createState() => _EditJobPageState();

}

class _EditJobPageState extends State<EditJobPage> {

  final FocusNode _jobFocusNode = FocusNode();
  final FocusNode _rateFocusNode = FocusNode();

  String _jobName;
  int _ratePerHour;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.job != null) {
      _jobName = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _jobNameEditingComplete() {
    final newFocus =
        _jobController.text.isNotEmpty ? _rateFocusNode : _jobFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_jobName)) {
          showAlertDialog(
            context,
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          );
        } else {
          final id = widget.job?.id ?? DateTime.now().toIso8601String();
          final job = Job(id: id, name: _jobName, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: _buildChildren()),
    );
  }

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        initialValue: _jobName,
        //controller: _jobController.value == null ? null : _jobController,
        focusNode: _jobFocusNode,
        onSaved: (value) => _jobName = value,
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        autofocus: true,
        keyboardType: TextInputType.text,
        onEditingComplete: _jobNameEditingComplete,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'Job Name',
          hintText: 'Blogging',
        ),
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? _ratePerHour.toString() : null,
        //controller: _rateController.value == null ? null : _rateController,
        focusNode: _rateFocusNode,
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        validator: (value) => value.isNotEmpty ? null : "Rate can't be empty",
        keyboardType: TextInputType.number,
        onEditingComplete: _submit,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Rate per hour',
          hintText: '10',
        ),
      ),
    ];
  }
}
