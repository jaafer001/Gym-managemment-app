import 'dart:io';
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/member.dart';
import '../models/Subscription.dart';
import 'add_member_screen.dart';
import '../l10n/app_localizations.dart';

class MemberDetailsScreen extends StatelessWidget {
  final Member member;

  MemberDetailsScreen({required this.member});

  void _deleteMember(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteMember),
        content: Text(l10n.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(l10n.cancel)
          ),
          TextButton(
            onPressed: () async {
              try {
                await DatabaseHelper.instance.deleteMember(member.id!);
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to parent with refresh flag
              } catch (e) {
                Navigator.pop(context); // Close dialog on error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.deleteFailed}: $e')));
              }
            }, 
            child: Text(l10n.delete)
          ),
        ],
      ),
    );
  }

  void _renewSubscription(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Logic to renew subscription
      final newSub = Subscription(
        type: member.subscriptions.isNotEmpty ? member.subscriptions.last.type : 'Monthly',
        duration: member.subscriptions.isNotEmpty ? member.subscriptions.last.duration : 30,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: member.subscriptions.isNotEmpty ? member.subscriptions.last.duration : 30)),
      );
      
      // Create updated member with new subscription
      final updatedMember = Member(
        id: member.id,
        name: member.name,
        age: member.age,
        gender: member.gender,
        phone: member.phone,
        email: member.email,
        photoPath: member.photoPath,
        subscriptions: [...member.subscriptions, newSub],
      );
      
      await DatabaseHelper.instance.updateMember(updatedMember);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.renewSuccess)));
      Navigator.pop(context, true); // Return to trigger refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.renewFailed}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(member.name)),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            if (member.photoPath != null) Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Image.file(File(member.photoPath!), height: 200, fit: BoxFit.cover),
            ),
            Text('${l10n.age}: ${member.age}'),
            SizedBox(height: 8),
            Text('${l10n.gender}: ${member.gender == 'male' ? l10n.male : l10n.female}'),
            SizedBox(height: 8),
            Text('${l10n.phone}: ${member.phone}'),
            if (member.email != null) ...[
              SizedBox(height: 8),
              Text('${l10n.email}: ${member.email}'),
            ],
            SizedBox(height: 16),
            Text(l10n.currentSubscriptions, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...member.subscriptions.where((s) => s.isActive).map((s) => ListTile(
              title: Text(s.type),
              subtitle: Text('${l10n.expiresOn}: ${s.endDate.toLocal()}'),
            )),
            SizedBox(height: 16),
            Text(l10n.subscriptionHistory, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...member.subscriptions.map((s) => ListTile(
              title: Text(s.type),
              subtitle: Text('${l10n.from} ${s.startDate.toLocal()} ${l10n.to} ${s.endDate.toLocal()}'),
            )),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => AddMemberScreen(member: member))
                      );
                      if (result == true) {
                        Navigator.pop(context, true); // Refresh parent screen
                      }
                    }, 
                    child: Text(l10n.edit)
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteMember(context), 
                    child: Text(l10n.delete)
                  ),
                  ElevatedButton(
                    onPressed: () => _renewSubscription(context), 
                    child: Text(l10n.renew)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}