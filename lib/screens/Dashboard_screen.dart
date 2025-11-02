import 'package:flutter/material.dart' hide Badge;
import 'package:badges/badges.dart';
import '../database/database_helper.dart';
import '../models/member.dart';
import '../widgets/stat_card.dart';
import '../widgets/member_list_item.dart';
import '../widgets/member_card.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Member> members = [];
  List<Member> filteredMembers = [];
  bool isListView = true;
  TextEditingController searchController = TextEditingController();
  int totalMembers = 0, activeSubs = 0, expiredSubs = 0, newSubs = 0, expiredNotifications = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void loadData() async {
    members = await DatabaseHelper.instance.getMembers();
    // Calculate stats
    totalMembers = members.length;
    activeSubs = members.where((m) => m.subscriptions.any((s) => s.isActive)).length;
    expiredSubs = members.where((m) => m.subscriptions.any((s) => !s.isActive)).length;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));
    newSubs = members.where((m) => 
      m.subscriptions.any((s) => s.startDate.isAfter(sevenDaysAgo))
    ).length;
    
    // Count expired subscriptions for notifications
    expiredNotifications = members.where((m) => 
      m.subscriptions.any((s) => !s.isActive && s.endDate.isBefore(now))
    ).length;
    
    if (mounted) {
      setState(() {
        filteredMembers = members;
      });
    }
  }

  void _filterMembers() {
    setState(() {
      filteredMembers = members.where((member) =>
          member.name.toLowerCase().contains(searchController.text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.dashboard),
          actions: [
            IconButton(
              icon: expiredNotifications > 0
                  ? Badge(
                      badgeContent: Text(expiredNotifications.toString()),
                      child: Icon(Icons.notifications),
                    )
                  : Icon(Icons.notifications),
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/notifications');
                if (result == true) {
                  loadData(); // Refresh when returning
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: l10n.settings,
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/settings');
                if (result == true) {
                  // Reload data if needed after settings change
                  loadData();
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(child: StatCard(title: l10n.total, value: totalMembers.toString())),
                Expanded(child: StatCard(title: l10n.active, value: activeSubs.toString())),
                Expanded(child: StatCard(title: l10n.expired, value: expiredSubs.toString())),
                Expanded(child: StatCard(title: l10n.newMembers, value: newSubs.toString())),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(hintText: l10n.searchMembers),
              ),
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.list), onPressed: () => setState(() => isListView = true)),
                IconButton(icon: Icon(Icons.grid_view), onPressed: () => setState(() => isListView = false)),
              ],
            ),
            Expanded(
              child: isListView
                  ? ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) => MemberListItem(member: filteredMembers[index]),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) => MemberCard(member: filteredMembers[index]),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/add_member');
            if (result == true) {
              loadData(); // Refresh when returning
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}