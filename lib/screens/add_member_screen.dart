import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../database/database_helper.dart';
import '../models/member.dart';
import '../models/Subscription.dart';
import '../l10n/app_localizations.dart';

class AddMemberScreen extends StatefulWidget {
  final Member? member;

  AddMemberScreen({this.member});

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', gender = 'male', phone = '', email = '', type = 'Monthly';
  int age = 0, duration = 30;
  File? photo;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      name = widget.member!.name;
      age = widget.member!.age;
      gender = widget.member!.gender;
      phone = widget.member!.phone;
      email = widget.member!.email ?? '';
      photo = widget.member!.photoPath != null ? File(widget.member!.photoPath!) : null;
    }
  }

  void _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseSource),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(l10n.camera),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  try {
                    final compressed = await FlutterImageCompress.compressAndGetFile(
                      pickedFile.path, pickedFile.path + '_compressed.jpg', quality: 50);
                    if (compressed != null) {
                      setState(() => photo = File(compressed.path));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.imageCompressFailed}: $e')));
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(l10n.gallery),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  try {
                    final compressed = await FlutterImageCompress.compressAndGetFile(
                      pickedFile.path, pickedFile.path + '_compressed.jpg', quality: 50);
                    if (compressed != null) {
                      setState(() => photo = File(compressed.path));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.imageCompressFailed}: $e')));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveMember() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final sub = Subscription(
          type: type,
          duration: duration,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(days: duration)),
        );
        final member = Member(
          id: widget.member?.id,
          name: name,
          age: age,
          gender: gender,
          phone: phone,
          email: email.isEmpty ? null : email,
          photoPath: photo?.path,
          subscriptions: widget.member != null ? [...widget.member!.subscriptions, sub] : [sub],
        );
        if (widget.member == null) {
          await DatabaseHelper.instance.insertMember(member);
        } else {
          await DatabaseHelper.instance.updateMember(member);
        }
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.saveMemberFailed}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.member == null ? l10n.addMember : l10n.editMember)),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: l10n.memberName),
                validator: (value) => value == null || value.isEmpty ? l10n.required : null,
                onSaved: (value) => name = value ?? '',
                onChanged: (value) => name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: age.toString(),
                decoration: InputDecoration(labelText: l10n.age),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.required;
                  final parsedAge = int.tryParse(value);
                  if (parsedAge == null || parsedAge <= 0) return l10n.enterValidAge;
                  return null;
                },
                onSaved: (value) => age = int.tryParse(value ?? '0') ?? 0,
                onChanged: (value) {
                  final parsedAge = int.tryParse(value);
                  if (parsedAge != null && parsedAge > 0) {
                    age = parsedAge;
                  }
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: l10n.gender),
                value: gender,
                items: [
                  DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                  DropdownMenuItem(value: 'female', child: Text(l10n.female)),
                ],
                onChanged: (value) => setState(() => gender = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(labelText: l10n.phone),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? l10n.required : null,
                onSaved: (value) => phone = value ?? '',
                onChanged: (value) => phone = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: l10n.subscriptionType),
                value: type,
                items: ['Monthly', 'Yearly'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (value) => setState(() => type = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: duration.toString(),
                decoration: InputDecoration(labelText: l10n.duration),
                keyboardType: TextInputType.number,
                onChanged: (value) => duration = int.tryParse(value) ?? 30,
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _pickImage, child: Text(l10n.selectImage)),
              if (photo != null) Padding(
                padding: EdgeInsets.all(16),
                child: Image.file(photo!, height: 200),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _saveMember, child: Text(l10n.save)),
            ],
          ),
        ),
      ),
    );
  }
}