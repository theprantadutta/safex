import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransferScreen extends StatefulWidget {
  static const String kRouteName = '/transfer';
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customContactController =
      TextEditingController();

  String selectedTransactionType = 'Send';
  String selectedContact = '';
  String selectedContactType = 'contacts';
  String selectedBank = '';
  String selectedCrypto = '';
  bool showQRGenerator = false;
  bool showQRScanner = false;
  int currentPage = 0;

  // Transaction type configurations
  final Map<String, TransactionConfig> transactionConfigs = {
    'Send': TransactionConfig(
      title: 'Send Money',
      description: 'Transfer money to friends, family, business',
      color: Color(0xFF6366F1),
      icon: Icons.send_rounded,
      options: ['contacts', 'email', 'phone', 'qr'],
    ),
    'Receive': TransactionConfig(
      title: 'Receive Money',
      description: 'Generate QR code or share your details',
      color: Color(0xFF10B981),
      icon: Icons.call_received_rounded,
      options: ['qr', 'bank_details', 'crypto_wallet'],
    ),
    'Request': TransactionConfig(
      title: 'Request Money',
      description: 'Ask someone to send you money',
      color: Color(0xFFF59E0B),
      icon: Icons.request_quote_rounded,
      options: ['contacts', 'email', 'phone', 'link'],
    ),
    'Withdraw': TransactionConfig(
      title: 'Withdraw Funds',
      description: 'Transfer money to your bank or crypto wallet',
      color: Color(0xFFEF4444),
      icon: Icons.account_balance_rounded,
      options: ['bank_account', 'crypto_wallet', 'atm'],
    ),
  };

  // Enhanced data
  final List<Contact> contacts = [
    Contact(
      '001',
      'john.doe@email.com',
      'John Doe',
      'email',
      'JD',
      Color(0xFF8B5CF6),
    ),
    Contact(
      '002',
      '+1 (555) 123-4567',
      'Sarah Wilson',
      'phone',
      'SW',
      Color(0xFF06B6D4),
    ),
    Contact(
      '003',
      'mike.chen@email.com',
      'Mike Chen',
      'email',
      'MC',
      Color(0xFFF59E0B),
    ),
    Contact(
      '004',
      '+1 (555) 987-6543',
      'Emma Davis',
      'phone',
      'ED',
      Color(0xFFEF4444),
    ),
    Contact(
      '005',
      'alex.smith@email.com',
      'Alex Smith',
      'email',
      'AS',
      Color(0xFF10B981),
    ),
    Contact(
      '006',
      '+1 (555) 456-7890',
      'Lisa Johnson',
      'phone',
      'LJ',
      Color(0xFFEC4899),
    ),
  ];

  final List<BankAccount> bankAccounts = [
    BankAccount('Chase Bank', '**** 1234', 'checking', Icons.account_balance),
    BankAccount('Wells Fargo', '**** 5678', 'savings', Icons.savings),
    BankAccount(
      'Bank of America',
      '**** 9012',
      'checking',
      Icons.account_balance,
    ),
  ];

  final List<CryptoWallet> cryptoWallets = [
    CryptoWallet('Bitcoin', 'bc1q...x7k9', 'BTC', Color(0xFFF7931A)),
    CryptoWallet('Ethereum', '0x42...8f3c', 'ETH', Color(0xFF627EEA)),
    CryptoWallet('USDC', '0x89...2a1b', 'USDC', Color(0xFF2775CA)),
  ];

  final List<Transaction> recentTransactions = [
    Transaction(
      'John Doe',
      250.00,
      DateTime.now().subtract(Duration(hours: 2)),
      'sent',
      Color(0xFF8B5CF6),
    ),
    Transaction(
      'Sarah Wilson',
      150.50,
      DateTime.now().subtract(Duration(days: 1)),
      'received',
      Color(0xFF06B6D4),
    ),
    Transaction(
      'Mike Chen',
      75.25,
      DateTime.now().subtract(Duration(days: 2)),
      'sent',
      Color(0xFFF59E0B),
    ),
    Transaction(
      'Emma Davis',
      320.00,
      DateTime.now().subtract(Duration(days: 3)),
      'received',
      Color(0xFFEF4444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTransactionTypeSelector(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentPage = index),
                children: [_buildTransferForm(), _buildConfirmationScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final config = transactionConfigs[selectedTransactionType]!;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: config.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(config.icon, color: config.color, size: 24),
              ),
              Spacer(),
              IconButton(
                onPressed: () => setState(() => showQRScanner = !showQRScanner),
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () =>
                    setState(() => showQRGenerator = !showQRGenerator),
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            config.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            config.description,
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3);
  }

  Widget _buildTransactionTypeSelector() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: transactionConfigs.keys.map((type) {
          final isSelected = selectedTransactionType == type;
          final config = transactionConfigs[type]!;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                selectedTransactionType = type;
                selectedContactType = config.options.first;
                selectedContact = '';
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? config.color : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      config.icon,
                      color: isSelected ? Colors.white : Color(0xFF64748B),
                      size: 20,
                    ),
                    SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF64748B),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: -0.2);
  }

  Widget _buildTransferForm() {
    if (showQRScanner) return _buildQRScanner();
    if (showQRGenerator) return _buildQRGenerator();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          if (selectedTransactionType != 'Receive') _buildAmountInput(),
          if (selectedTransactionType != 'Receive') SizedBox(height: 20),
          _buildOptionsSection(),
          SizedBox(height: 20),
          if (selectedTransactionType != 'Receive') _buildNoteInput(),
          if (selectedTransactionType != 'Receive') SizedBox(height: 30),
          _buildActionButton(),
          SizedBox(height: 20),
          _buildRecentTransactions(),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.3);
  }

  Widget _buildOptionsSection() {
    final config = transactionConfigs[selectedTransactionType]!;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getOptionsSectionTitle(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(height: 16),
          _buildOptionTabs(config.options),
          SizedBox(height: 20),
          _buildOptionContent(),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3);
  }

  String _getOptionsSectionTitle() {
    switch (selectedTransactionType) {
      case 'Send':
        return 'Send To';
      case 'Receive':
        return 'Receive Options';
      case 'Request':
        return 'Request From';
      case 'Withdraw':
        return 'Withdraw To';
      default:
        return 'Options';
    }
  }

  Widget _buildOptionTabs(List<String> options) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((option) {
          final isSelected = selectedContactType == option;
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() {
                selectedContactType = option;
                selectedContact = '';
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? transactionConfigs[selectedTransactionType]!.color
                      : Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getOptionIcon(option),
                      size: 16,
                      color: isSelected ? Colors.white : Color(0xFF64748B),
                    ),
                    SizedBox(width: 6),
                    Text(
                      _getOptionLabel(option),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getOptionIcon(String option) {
    switch (option) {
      case 'contacts':
        return Icons.people_rounded;
      case 'email':
        return Icons.email_rounded;
      case 'phone':
        return Icons.phone_rounded;
      case 'qr':
        return Icons.qr_code_rounded;
      case 'bank_details':
        return Icons.account_balance_rounded;
      case 'crypto_wallet':
        return Icons.currency_bitcoin_rounded;
      case 'link':
        return Icons.link_rounded;
      case 'bank_account':
        return Icons.account_balance_rounded;
      case 'atm':
        return Icons.local_atm_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String _getOptionLabel(String option) {
    switch (option) {
      case 'contacts':
        return 'Contacts';
      case 'email':
        return 'Email';
      case 'phone':
        return 'Phone';
      case 'qr':
        return 'QR Code';
      case 'bank_details':
        return 'Bank Details';
      case 'crypto_wallet':
        return 'Crypto Wallet';
      case 'link':
        return 'Payment Link';
      case 'bank_account':
        return 'Bank Account';
      case 'atm':
        return 'ATM';
      default:
        return option;
    }
  }

  Widget _buildOptionContent() {
    switch (selectedContactType) {
      case 'contacts':
        return _buildContactsList();
      case 'email':
      case 'phone':
        return _buildCustomContactInput();
      case 'qr':
        return _buildQROption();
      case 'bank_details':
        return _buildBankDetailsDisplay();
      case 'crypto_wallet':
        return _buildCryptoWalletsList();
      case 'link':
        return _buildPaymentLinkOption();
      case 'bank_account':
        return _buildBankAccountsList();
      case 'atm':
        return _buildATMOption();
      default:
        return Container();
    }
  }

  Widget _buildContactsList() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search contacts...',
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: transactionConfigs[selectedTransactionType]!.color,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        SizedBox(height: 16),
        ...contacts
            .where((contact) {
              final query = _searchController.text.toLowerCase();
              return contact.name.toLowerCase().contains(query) ||
                  contact.identifier.toLowerCase().contains(query);
            })
            .map((contact) => _buildContactItem(contact)),
      ],
    );
  }

  Widget _buildContactItem(Contact contact) {
    final isSelected = selectedContact == contact.identifier;
    return GestureDetector(
      onTap: () => setState(() => selectedContact = contact.identifier),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? transactionConfigs[selectedTransactionType]!.color.withOpacity(
                  0.1,
                )
              : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? transactionConfigs[selectedTransactionType]!.color
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: contact.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: contact.color,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    contact.identifier,
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: transactionConfigs[selectedTransactionType]!.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomContactInput() {
    final isEmail = selectedContactType == 'email';
    return TextField(
      controller: _customContactController,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.phone,
      decoration: InputDecoration(
        hintText: isEmail ? 'Enter email address...' : 'Enter phone number...',
        prefixIcon: Icon(
          isEmail ? Icons.email_rounded : Icons.phone_rounded,
          color: Color(0xFF94A3B8),
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: transactionConfigs[selectedTransactionType]!.color,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) => setState(() => selectedContact = value),
    );
  }

  Widget _buildQROption() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 48,
            color: Color(0xFF64748B),
          ),
          SizedBox(height: 12),
          Text(
            'Scan QR Code',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Scan a QR code to quickly add recipient',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsDisplay() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_rounded,
            size: 48,
            color: transactionConfigs[selectedTransactionType]!.color,
          ),
          SizedBox(height: 16),
          _buildDetailRow('Account Number', '****-****-1234'),
          _buildDetailRow('Routing Number', '021000021'),
          _buildDetailRow('Account Name', 'Your Name'),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.share_rounded, size: 16),
            label: Text('Share Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  transactionConfigs[selectedTransactionType]!.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoWalletsList() {
    return Column(
      children: cryptoWallets
          .map((wallet) => _buildCryptoWalletItem(wallet))
          .toList(),
    );
  }

  Widget _buildCryptoWalletItem(CryptoWallet wallet) {
    final isSelected = selectedCrypto == wallet.code;
    return GestureDetector(
      onTap: () => setState(() => selectedCrypto = wallet.code),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? wallet.color.withOpacity(0.1) : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? wallet.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: wallet.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  wallet.cryptoType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: wallet.color,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    wallet.code,
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: wallet.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLinkOption() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.link_rounded,
            size: 48,
            color: transactionConfigs[selectedTransactionType]!.color,
          ),
          SizedBox(height: 12),
          Text(
            'Payment Link',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Generate a link to request payment',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => setState(() => selectedContact = 'payment_link'),
            icon: Icon(Icons.link_rounded, size: 16),
            label: Text('Generate Link'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  transactionConfigs[selectedTransactionType]!.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountsList() {
    return Column(
      children: bankAccounts
          .map((account) => _buildBankAccountItem(account))
          .toList(),
    );
  }

  Widget _buildBankAccountItem(BankAccount account) {
    final isSelected = selectedBank == account.accountNumber;
    return GestureDetector(
      onTap: () => setState(() => selectedBank = account.accountNumber),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? transactionConfigs[selectedTransactionType]!.color.withOpacity(
                  0.1,
                )
              : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? transactionConfigs[selectedTransactionType]!.color
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFF475569).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(account.icon, color: Color(0xFF475569), size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${account.accountNumber} • ${account.accountType}',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: transactionConfigs[selectedTransactionType]!.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildATMOption() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_atm_rounded,
            size: 48,
            color: transactionConfigs[selectedTransactionType]!.color,
          ),
          SizedBox(height: 12),
          Text(
            'ATM Withdrawal',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Generate a code for ATM withdrawal',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => setState(() => selectedContact = 'atm_code'),
            icon: Icon(Icons.pin_rounded, size: 16),
            label: Text('Generate Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  transactionConfigs[selectedTransactionType]!.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Note (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
                  'What\'s this ${selectedTransactionType.toLowerCase()} for?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: transactionConfigs[selectedTransactionType]!.color,
                ),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.3);
  }

  Widget _buildActionButton() {
    final config = transactionConfigs[selectedTransactionType]!;
    bool isEnabled = _isFormValid();

    return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? _handleActionButton : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: config.color,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Color(0xFFE2E8F0),
              disabledForegroundColor: Color(0xFF94A3B8),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: isEnabled ? 4 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(config.icon, size: 20),
                SizedBox(width: 8),
                Text(
                  _getActionButtonText(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms)
        .scale(begin: Offset(0.9, 0.9));
  }

  bool _isFormValid() {
    switch (selectedTransactionType) {
      case 'Send':
      case 'Request':
        return _amountController.text.isNotEmpty &&
            (selectedContact.isNotEmpty ||
                _customContactController.text.isNotEmpty);
      case 'Withdraw':
        return _amountController.text.isNotEmpty &&
            (selectedBank.isNotEmpty ||
                selectedCrypto.isNotEmpty ||
                selectedContact.isNotEmpty);
      case 'Receive':
        return true;
      default:
        return false;
    }
  }

  String _getActionButtonText() {
    switch (selectedTransactionType) {
      case 'Send':
        return 'Continue to Send';
      case 'Receive':
        return 'Generate QR Code';
      case 'Request':
        return 'Send Request';
      case 'Withdraw':
        return 'Continue to Withdraw';
      default:
        return 'Continue';
    }
  }

  void _handleActionButton() {
    if (selectedTransactionType == 'Receive') {
      setState(() => showQRGenerator = true);
    } else {
      _goToConfirmation();
    }
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: transactionConfigs[selectedTransactionType]!.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...recentTransactions
              .take(3)
              .map((transaction) => _buildTransactionItem(transaction)),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.3);
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isReceived = transaction.type == 'received';
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: transaction.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isReceived ? Icons.south_west_rounded : Icons.north_east_rounded,
              size: 20,
              color: transaction.color,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isReceived ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isReceived ? Color(0xFF10B981) : Color(0xFF0F172A),
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isReceived
                      ? Color(0xFF10B981).withOpacity(0.1)
                      : Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isReceived ? 'Received' : 'Sent',
                  style: TextStyle(
                    color: isReceived ? Color(0xFF10B981) : Color(0xFFEF4444),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationScreen() {
    final config = transactionConfigs[selectedTransactionType]!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 30,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: config.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(config.icon, size: 40, color: config.color),
                ).animate().scale(duration: 600.ms),
                SizedBox(height: 24),
                Text(
                  'Confirm $selectedTransactionType',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please review the details below',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                ),
                SizedBox(height: 32),
                _buildConfirmationItem(
                  'Amount',
                  '\$${_amountController.text}',
                  true,
                ),
                _buildConfirmationItem(
                  _getRecipientLabel(),
                  _getRecipientValue(),
                ),
                if (_noteController.text.isNotEmpty)
                  _buildConfirmationItem('Note', _noteController.text),
                _buildConfirmationItem('Transaction Fee', '\$0.00'),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  height: 1,
                  color: Color(0xFFE2E8F0),
                ),
                _buildConfirmationItem(
                  'Total',
                  '\$${_amountController.text}',
                  true,
                  true,
                  // isTotal: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _confirmTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Confirm $selectedTransactionType',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.3);
  }

  String _getRecipientLabel() {
    switch (selectedTransactionType) {
      case 'Send':
        return 'Send To';
      case 'Request':
        return 'Request From';
      case 'Withdraw':
        return 'Withdraw To';
      default:
        return 'Recipient';
    }
  }

  String _getRecipientValue() {
    if (selectedContact.isNotEmpty) return selectedContact;
    if (_customContactController.text.isNotEmpty)
      return _customContactController.text;
    if (selectedBank.isNotEmpty) return selectedBank;
    if (selectedCrypto.isNotEmpty) return selectedCrypto;
    return 'Unknown';
  }

  Widget _buildConfirmationItem(
    String label,
    String value, [
    bool isHighlight = false,
    bool isTotal = false,
  ]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? Color(0xFF0F172A) : Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: isTotal
                  ? transactionConfigs[selectedTransactionType]!.color
                  : isHighlight
                  ? transactionConfigs[selectedTransactionType]!.color
                  : Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRScanner() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => showQRScanner = false),
                icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF64748B)),
              ),
              Expanded(
                child: Text(
                  'Scan QR Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
          SizedBox(height: 32),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: transactionConfigs[selectedTransactionType]!.color,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Container(
                  color: Color(0xFF0F172A),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 80,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'QR Scanner View',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Camera would be here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => showQRScanner = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF1F5F9),
                foregroundColor: Color(0xFF64748B),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'Close Scanner',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildQRGenerator() {
    final config = transactionConfigs[selectedTransactionType]!;
    final qrData =
        'fintech://transfer?amount=${_amountController.text}&user=$selectedContact&type=$selectedTransactionType';

    return Container(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => showQRGenerator = false),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF64748B),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Your QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 30,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: config.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(config.icon, size: 30, color: config.color),
                  ),
                  SizedBox(height: 24),
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Scan to ${selectedTransactionType.toLowerCase()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 8),
                  if (_amountController.text.isNotEmpty)
                    Text(
                      // '\${_amountController.text}',
                      '\$${_amountController.text}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: config.color,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.share_rounded, size: 18),
                    label: Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: config.color),
                      foregroundColor: config.color,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.download_rounded, size: 18),
                    label: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).scale(begin: Offset(0.9, 0.9));
  }

  void _goToConfirmation() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _confirmTransaction() {
    final config = transactionConfigs[selectedTransactionType]!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: config.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: CircularProgressIndicator(
                color: config.color,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Processing ${selectedTransactionType.toLowerCase()}...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we process your transaction',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    // final config = transactionConfigs[selectedTransactionType]!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 50,
              ),
            ).animate().scale(duration: 600.ms),
            SizedBox(height: 24),
            Text(
              '$selectedTransactionType Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              _getSuccessMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSuccessMessage() {
    switch (selectedTransactionType) {
      case 'Send':
        return '\${_amountController.text} sent to ${_getRecipientValue()}';
      case 'Receive':
        return 'QR code generated successfully';
      case 'Request':
        return 'Payment request sent to ${_getRecipientValue()}';
      case 'Withdraw':
        return '\${_amountController.text} withdrawn to ${_getRecipientValue()}';
      default:
        return 'Transaction completed successfully';
    }
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _noteController.clear();
      _searchController.clear();
      _customContactController.clear();
      selectedContact = '';
      selectedBank = '';
      selectedCrypto = '';
      currentPage = 0;
    });
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

// Enhanced Models
class TransactionConfig {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final List<String> options;

  TransactionConfig({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.options,
  });
}

class Transaction {
  final String name;
  final String type; // 'sent' or 'received'
  final double amount;
  final DateTime date;
  final Color color;

  Transaction(this.name, this.amount, this.date, this.type, this.color);
}

class Bank {
  final String name;
  final String code;
  final String icon;
  final String type; // 'bank' or 'crypto'
  final String accountNumber;

  Bank({
    required this.name,
    required this.code,
    required this.icon,
    required this.type,
    required this.accountNumber,
  });
}

class Contact {
  final String identifier;
  final String name;
  final String phoneNumber;
  final String email;
  final String initials;
  final Color color;
  // Contact('john.doe@email.com', 'John Doe', 'email', 'JD', Color(0xFF8B5CF6)),
  Contact(
    this.identifier,
    this.email,
    this.name,
    this.phoneNumber,
    this.initials,
    this.color,
  );
}

class Account {
  final String name;
  final String accountNumber;
  final String type; // 'bank' or 'crypto'

  Account({
    required this.name,
    required this.accountNumber,
    required this.type,
  });
}

class Crypto {
  final String name;
  final String code;
  final String icon;
  final String accountNumber;

  Crypto({
    required this.name,
    required this.code,
    required this.icon,
    required this.accountNumber,
  });
}

class CryptoWallet {
  final String name;
  final String code;
  final String cryptoType; // 'BTC', 'ETH', etc.
  final Color color;

  // CryptoWallet('Bitcoin', 'bc1q...x7k9', 'BTC', Color(0xFFF7931A)),
  CryptoWallet(this.name, this.code, this.cryptoType, this.color);
}

class CryptoTransaction {
  final String name;
  final String type; // 'sent' or 'received'
  final double amount;
  final DateTime date;
  final Color color;

  CryptoTransaction({
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
    required this.color,
  });
}

class BankAccount {
  final String name;
  final String accountType;
  final IconData icon;
  final String accountNumber;

  // BankAccount('Chase Bank', '**** 1234', 'checking', Icons.account_balance),

  BankAccount(this.name, this.accountNumber, this.accountType, this.icon);
}
