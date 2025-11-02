import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/member.dart';
import '../l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Member> expiredMembers = [];

  @override
  void initState() {
    super.initState();
    loadExpiredMembers();
  }

  void loadExpiredMembers() async {
    final members = await DatabaseHelper.instance.getMembers();
    final now = DateTime.now();
    if (mounted) {
      setState(() {
        expiredMembers = members.where((m) => 
          m.subscriptions.any((s) => !s.isActive && s.endDate.isBefore(now))
        ).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.notifications)),
        body: expiredMembers.isEmpty
            ? Center(child: Text(l10n.noNotifications))
            : ListView.builder(
                itemCount: expiredMembers.length,
                itemBuilder: (context, index) {
                  final member = expiredMembers[index];
                  final expiredSub = member.subscriptions.firstWhere(
                    (s) => !s.isActive && s.endDate.isBefore(DateTime.now()),
                    orElse: () => member.subscriptions.first,
                  );
                  return ListTile(
                    title: Text(member.name),
                    subtitle: Text('${l10n.expiredSubscription}: ${expiredSub.type} - ${expiredSub.endDate.toLocal().toString().split(' ')[0]}'),
                    onTap: () async {
                      final result = await Navigator.pushNamed(context, '/member_details', arguments: member);
                      if (result == true) {
                        loadExpiredMembers(); // Refresh when returning
                      }
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() => expiredMembers.clear()); // Mark as read
            Navigator.pop(context, true); // Return to refresh parent
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }
}