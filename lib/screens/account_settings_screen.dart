import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // Settings state
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _marketingEmails = true;
  String _language = 'Русский';
  String _currency = '₸ (Тенге)';

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => _ChangePasswordDialog(),
    );
  }

  void _changeEmail() {
    showDialog(
      context: context,
      builder: (context) => _ChangeEmailDialog(),
    );
  }

  void _changeName() {
    showDialog(
      context: context,
      builder: (context) => _ChangeNameDialog(),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'УДАЛИТЬ АККАУНТ?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        content: const Text(
          'Это действие необратимо. Все ваши данные будут удалены без возможности восстановления.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ОТМЕНА', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(child: Text('Для удаления аккаунта свяжитесь с поддержкой')),
                    ],
                  ),
                  backgroundColor: const Color(0xFFFF6B6B),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('УДАЛИТЬ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'НАСТРОЙКИ АККАУНТА',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Профиль
            _buildSection('ПРОФИЛЬ'),
            _buildMenuItem(
              'Изменить имя',
              'Alexey Ivanov',
              Icons.person,
              const Color(0xFF00FF87),
              _changeName,
            ),
            _buildMenuItem(
              'Email',
              'alexey@mail.com',
              Icons.email,
              const Color(0xFF00D9FF),
              _changeEmail,
            ),
            _buildMenuItem(
              'Телефон',
              '+7 777 123 45 67',
              Icons.phone,
              const Color(0xFFFFE66D),
                  () {},
            ),
            _buildMenuItem(
              'Изменить пароль',
              '••••••••',
              Icons.lock,
              const Color(0xFF4ECDC4),
              _changePassword,
            ),

            const SizedBox(height: 24),

            // Уведомления
            _buildSection('УВЕДОМЛЕНИЯ'),
            _buildSwitchTile(
              'Email уведомления',
              'Получать письма о заказах и акциях',
              Icons.email,
              const Color(0xFF00FF87),
              _emailNotifications,
                  (value) => setState(() => _emailNotifications = value),
            ),
            _buildSwitchTile(
              'Push уведомления',
              'Уведомления в приложении',
              Icons.notifications,
              const Color(0xFF00D9FF),
              _pushNotifications,
                  (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'SMS уведомления',
              'СМС о статусе заказа',
              Icons.sms,
              const Color(0xFFFFE66D),
              _smsNotifications,
                  (value) => setState(() => _smsNotifications = value),
            ),
            _buildSwitchTile(
              'Маркетинговые рассылки',
              'Новинки, скидки и персональные предложения',
              Icons.local_offer,
              const Color(0xFF4ECDC4),
              _marketingEmails,
                  (value) => setState(() => _marketingEmails = value),
            ),

            const SizedBox(height: 24),

            // Предпочтения
            _buildSection('ПРЕДПОЧТЕНИЯ'),
            _buildDropdownMenuItem(
              'Язык',
              _language,
              Icons.language,
              const Color(0xFF00FF87),
              ['Русский', 'English', 'Қазақша'],
                  (value) => setState(() => _language = value!),
            ),
            _buildDropdownMenuItem(
              'Валюта',
              _currency,
              Icons.attach_money,
              const Color(0xFF00D9FF),
              ['₸ (Тенге)', '\$ (Dollar)', '€ (Euro)'],
                  (value) => setState(() => _currency = value!),
            ),

            const SizedBox(height: 24),



            // Опасная зона
            _buildSection('ОПАСНАЯ ЗОНА', color: const Color(0xFFFF6B6B)),
            _buildDangerMenuItem(
              'Удалить аккаунт',
              'Безвозвратное удаление всех данных',
              Icons.delete_forever,
              _deleteAccount,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, {Color color = const Color(0xFF00FF87)}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[900]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[700], size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[900]!, width: 1),
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        value: value,
        activeColor: color,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownMenuItem(
      String title,
      String value,
      IconData icon,
      Color color,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[900]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          underline: Container(),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00FF87)),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDangerMenuItem(
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3), width: 2),
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_forever, color: Color(0xFFFF6B6B), size: 24),
        ),
        title: const Text(
          'Удалить аккаунт',
          style: TextStyle(
            color: Color(0xFFFF6B6B),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFF6B6B), size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Диалог изменения пароля
class _ChangePasswordDialog extends StatefulWidget {
  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'ИЗМЕНИТЬ ПАРОЛЬ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: _obscureCurrent,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Текущий пароль',
                labelStyle: const TextStyle(color: Color(0xFF00FF87)),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility),
                  color: Colors.grey[600],
                  onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                filled: true,
                fillColor: const Color(0xFF0A0A0A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Введите текущий пароль' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Новый пароль',
                labelStyle: const TextStyle(color: Color(0xFF00FF87)),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                  color: Colors.grey[600],
                  onPressed: () => setState(() => _obscureNew = !_obscureNew),
                ),
                filled: true,
                fillColor: const Color(0xFF0A0A0A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Введите новый пароль';
                if (value!.length < 6) return 'Минимум 6 символов';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Подтвердите пароль',
                labelStyle: const TextStyle(color: Color(0xFF00FF87)),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  color: Colors.grey[600],
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                filled: true,
                fillColor: const Color(0xFF0A0A0A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value != _newPasswordController.text) return 'Пароли не совпадают';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ОТМЕНА', style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF00FF87)),
                      SizedBox(width: 12),
                      Text('Пароль успешно изменен'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF1A1A1A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF87),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('СОХРАНИТЬ'),
        ),
      ],
    );
  }
}

// Диалог изменения email
class _ChangeEmailDialog extends StatefulWidget {
  @override
  State<_ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<_ChangeEmailDialog> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'ИЗМЕНИТЬ EMAIL',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      content: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Новый email',
          labelStyle: TextStyle(color: Color(0xFF00FF87)),
          filled: true,
          fillColor: Color(0xFF0A0A0A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ОТМЕНА', style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF00FF87)),
                    SizedBox(width: 12),
                    Text('Email успешно изменен'),
                  ],
                ),
                backgroundColor: const Color(0xFF1A1A1A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF87),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('СОХРАНИТЬ'),
        ),
      ],
    );
  }
}

// Диалог изменения имени
class _ChangeNameDialog extends StatefulWidget {
  @override
  State<_ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<_ChangeNameDialog> {
  final _nameController = TextEditingController(text: 'Alexey Ivanov');

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'ИЗМЕНИТЬ ИМЯ',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      content: TextFormField(
        controller: _nameController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          labelText: 'Имя и фамилия',
          labelStyle: TextStyle(color: Color(0xFF00FF87)),
          filled: true,
          fillColor: Color(0xFF0A0A0A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('ОТМЕНА', style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF00FF87)),
                    SizedBox(width: 12),
                    Text('Имя успешно изменено'),
                  ],
                ),
                backgroundColor: const Color(0xFF1A1A1A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FF87),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('СОХРАНИТЬ'),
        ),
      ],
    );
  }
}