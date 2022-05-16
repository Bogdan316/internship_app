import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import '../base_widgets/custom_elevated_button.dart';
import '../services/internship_service.dart';
import '../models/internship.dart';
import '../models/user.dart';

class ParticipantsSlider extends FormField<double> {
  // Builds a slider for the number of participants to be used as a
  // custom form field

  ParticipantsSlider(
      {Key? key,
      double initialValue = 0,
      required bool autovalidate,
      required BuildContext context,
      required void Function(double?) onSaved})
      : super(
          key: key,
          // if the validation condition is not met this ternary operator
          // ensures that the error message disappears once the user
          // changes the value of the slider
          autovalidateMode: autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (val) =>
              val == 0 ? "The number of participants can't be 0" : null,
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (state) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  // adds the grey border around the slider and text to
                  // match the other fields
                  decoration: BoxDecoration(
                    border: Border.all(
                      // sets the color of the border in case the validation
                      // fails
                      color: state.hasError
                          ? Theme.of(context).errorColor
                          : Theme.of(context).disabledColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Number of participants: ${state.value!.round()}',
                        style: TextStyle(
                          // sets the color of the
                          color: state.hasError
                              ? Theme.of(context).errorColor
                              // sets the color of the text in case the validation
                              // fails
                              : const Color(
                                  0xff595959,
                                ),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        label: state.value!.round().toString(),
                        // the max number of participants
                        max: 30,
                        min: 0,
                        // one for every participant
                        divisions: 30,
                        value: state.value!,
                        onChanged: (values) => state.didChange(values),
                      ),
                    ],
                  ),
                ),
                // if the validation fails an error message is showed
                // under the container like for the default form fields
                if (state.hasError)
                  RichText(
                    text: TextSpan(
                      text: state.errorText as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}

class CustomFormField extends StatelessWidget {
  // Builds a custom row containing a TextFormField for user input
  final String labelText;
  final Icon? icon;
  final TextEditingController? controller;
  final Color? color;
  final int? minLines;
  final int? maxLines;
  final bool autovalidate;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  const CustomFormField(
      {required this.labelText,
      required this.autovalidate,
      this.onTap,
      this.icon,
      this.controller,
      this.color,
      this.minLines,
      this.maxLines = 1,
      this.validator,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: TextFormField(
        onTap: onTap,
        minLines: minLines,
        maxLines: maxLines,
        // if the validation condition is not met this ternary operator
        // ensures that the error message disappears once the user
        // starts entering text
        autovalidateMode: autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is mandatory';
          }

          if (validator != null) {
            return validator!(value);
          }

          return null;
        },
        style: TextStyle(
          fontSize: 15,
          color: color,
        ),
        controller: controller,
        // the rest of the styling ensures that the field matches the theme
        // of the app
        decoration: InputDecoration(
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.all(10),
          floatingLabelStyle: const TextStyle(fontSize: 20),
          label: Text(
            labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTagDropDownFormField extends StatelessWidget {
  // Builds a custom dropdown field containing the possible internship tags
  // to be used as a form field
  final bool autovalidate;
  final void Function(Tag?)? onSaved;
  const CustomTagDropDownFormField(
      {required this.autovalidate, required this.onSaved, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
      child: DropdownButtonFormField<Tag>(
        // if the validation condition is not met this ternary operator
        // ensures that the error message disappears once the user
        // selects another value
        autovalidateMode: autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        validator: (tag) {
          if (tag == null) {
            return 'This field is mandatory';
          } else {
            return null;
          }
        },
        // the styling ensures that the field matches the theme
        // of the app
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(10),
          floatingLabelStyle: TextStyle(fontSize: 20),
          label: Text(
            'Tag',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        onSaved: onSaved,
        // converts the tag values into dropdown items
        items: Tag.values
            .mapIndexed(
              (idx, value) => DropdownMenuItem<Tag>(
                value: value,
                child: Text(
                  // formats the value of the enum into displayable text
                  TagUtil.convertTagValueToString(value),
                ),
              ),
            )
            .toList(),
        onChanged: (_) {},
      ),
    );
  }
}

class AddNewInternshipPage extends StatefulWidget {
  // Page holding the form used by the company to add a new internship

  static const String namedRoute = '/add-new-internship-page';

  final InternshipService _internshipService;
  const AddNewInternshipPage(this._internshipService, {Key? key})
      : super(key: key);

  @override
  State<AddNewInternshipPage> createState() => _AddNewInternshipPageState();
}

class _AddNewInternshipPageState extends State<AddNewInternshipPage> {
  // used for form submission and form validation
  final _formKey = GlobalKey<FormState>();
  // used for toggling the error messages of the fields when the
  // submit button is pressed
  var _autovalidate = false;

  // controllers and other containers that will hold the data
  // that needs to be inserted into the db
  final _titleCtr = TextEditingController();
  final _descriptionCtr = TextEditingController();
  final _requirementsCtr = TextEditingController();
  final _fromDateCtr = TextEditingController();
  final _toDateCtr = TextEditingController();
  double? _participantsNum;
  Tag? _internshipTag;

  @override
  void dispose() {
    super.dispose();
    _titleCtr.dispose();
    _descriptionCtr.dispose();
    _requirementsCtr.dispose();
    _fromDateCtr.dispose();
    _toDateCtr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the current company accessing the page
    var crtCompany = ModalRoute.of(context)!.settings.arguments as Company;

    return GestureDetector(
      // ensures that when the user taps outside a FormField the
      // FormFiled will lose focus
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Internship'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomFormField(
                    labelText: 'Title',
                    autovalidate: _autovalidate,
                    controller: _titleCtr,
                  ),
                  CustomFormField(
                    labelText: 'Description',
                    autovalidate: _autovalidate,
                    controller: _descriptionCtr,
                    minLines: 10,
                    maxLines: 50,
                  ),
                  CustomFormField(
                    labelText: 'Requirements',
                    autovalidate: _autovalidate,
                    controller: _requirementsCtr,
                    minLines: 10,
                    maxLines: 50,
                  ),
                  ParticipantsSlider(
                    autovalidate: _autovalidate,
                    context: context,
                    onSaved: (val) => _participantsNum = val,
                  ),
                  // the next two form fields are used as buttons to show
                  // a date picker instead of being used as text input,
                  // the date will be inserted in the form's controller
                  CustomFormField(
                    labelText: 'From Date',
                    autovalidate: _autovalidate,
                    controller: _fromDateCtr,
                    onTap: () async {
                      // takes the focus away from the text input
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        _fromDateCtr.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      }
                    },
                  ),
                  CustomFormField(
                    labelText: 'To Date',
                    autovalidate: _autovalidate,
                    controller: _toDateCtr,
                    validator: (value) {
                      if (_fromDateCtr.text.isNotEmpty) {
                        var fromDate =
                            DateFormat('dd/MM/yyyy').parse(_fromDateCtr.text);
                        var toDate =
                            DateFormat('dd/MM/yyyy').parse(_toDateCtr.text);
                        if (fromDate.isAfter(toDate)) {
                          return 'The To Date needs to be after the From Date';
                        }
                      }
                      return null;
                    },
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        _toDateCtr.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      }
                    },
                  ),
                  CustomTagDropDownFormField(
                    autovalidate: _autovalidate,
                    onSaved: (val) => _internshipTag = val,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                    child: CustomElevatedButton(
                      label: 'Submit',
                      primary: Theme.of(context).primaryColorDark,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          var internship = Internship(
                            companyId: crtCompany.getUserId,
                            title: _titleCtr.text,
                            description: _descriptionCtr.text,
                            fromDate: DateFormat('dd/MM/yyyy')
                                .parse(_fromDateCtr.text),
                            toDate:
                                DateFormat('dd/MM/yyyy').parse(_toDateCtr.text),
                            participantsNum: _participantsNum!.round(),
                            tag: _internshipTag,
                            isOngoing: true,
                          );
                          await widget._internshipService
                              .addInternship(internship);

                          // reset the form
                          _formKey.currentState!.reset();

                          // clears the current values of the form
                          setState(() {
                            _titleCtr.clear();
                            _descriptionCtr.clear();
                            _requirementsCtr.clear();
                            _fromDateCtr.clear();
                            _toDateCtr.clear();
                            _participantsNum = null;
                            _internshipTag = null;
                            _autovalidate = false;
                          });
                        } else {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
