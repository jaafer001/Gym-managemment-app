import 'dart:io';
import 'package:flutter/material.dart';
import '../models/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;

  MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/member_details', arguments: member),
      child: Card(
        child: Column(
          children: [
            member.photoPath != null ? Image.file(File(member.photoPath!), height: 100) : Icon(Icons.person, size: 100),
            Text(member.name),
            Text(member.phone),
          ],
        ),
      ),
    );
  }
}