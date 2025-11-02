import 'dart:io';
import 'package:flutter/material.dart';
import '../models/member.dart';

class MemberListItem extends StatelessWidget {
  final Member member;

  MemberListItem({required this.member});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: member.photoPath != null ? CircleAvatar(backgroundImage: FileImage(File(member.photoPath!))) : CircleAvatar(child: Icon(Icons.person)),
      title: Text(member.name),
      subtitle: Text(member.phone),
      onTap: () => Navigator.pushNamed(context, '/member_details', arguments: member),
    );
  }
}