import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool)? onThemeChanged;
  final Function(Locale)? onLanguageChanged;
  final Locale? currentLocale;

  SettingsScreen({this.onThemeChanged, this.onLanguageChanged, this.currentLocale});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isListView = true;
  String sortBy = 'newest';
  String selectedLanguage = 'en';
  
  final Map<String, String> languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'ja': '日本語',
    'ru': 'Русский',
    'ko': '한국어',
    'es': 'Español',
  };

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      isListView = prefs.getBool('isListView') ?? true;
      sortBy = prefs.getString('sortBy') ?? 'newest';
      selectedLanguage = widget.currentLocale?.languageCode ?? prefs.getString('languageCode') ?? 'en';
    });
  }

  void saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('isListView', isListView);
    await prefs.setString('sortBy', sortBy);
    
    // Apply theme change immediately
    if (widget.onThemeChanged != null) {
      widget.onThemeChanged!(isDarkMode);
    }
    
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsSaved))
    );
  }

  void _changeLanguage(String languageCode) async {
    setState(() {
      selectedLanguage = languageCode;
    });
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    
    if (widget.onLanguageChanged != null) {
      widget.onLanguageChanged!(Locale(languageCode));
    }
    
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsSaved))
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';
    
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: Text(l10n.darkMode),
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
                saveSettings(); // Save immediately when toggled
              },
            ),
            SwitchListTile(
              title: Text(l10n.listView),
              value: isListView,
              onChanged: (value) {
                setState(() => isListView = value);
                saveSettings();
              },
            ),
            SizedBox(height: 16),
            Text(l10n.translate('language'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                labelText: l10n.translate('select_language'),
                border: OutlineInputBorder(),
              ),
              items: languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: sortBy,
              decoration: InputDecoration(
                labelText: l10n.translate('sort_by'),
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 'newest', child: Text(l10n.translate('newest'))),
                DropdownMenuItem(value: 'oldest', child: Text(l10n.translate('oldest'))),
                DropdownMenuItem(value: 'alphabetical', child: Text(l10n.translate('alphabetical'))),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => sortBy = value);
                  saveSettings();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}