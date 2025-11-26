# Select Primary Account Feature

This feature allows users to select which deposit account should be their primary account.

## Files

- `select_primary_account_screen.dart` - Main screen for selecting primary account
- `logic/select_primary_account_state.dart` - State class for the feature
- `logic/select_primary_account_notifier.dart` - StateNotifier for managing state
- `logic/select_primary_account_provider.dart` - Riverpod providers
- `README.md` - This documentation file

## Features

- **Account Display**: Shows all deposit accounts with their details
- **Primary Account Selection**: Users can click checkbox to set account as primary
- **Transaction Navigation**: Users can tap anywhere on account card to go to transactions
- **Direct Selection**: Checkbox directly selects primary account without confirmation
- **Visual Indicators**: Selected account shows green border and checkbox
- **Navigation**: Cancel button to go back, logout button to sign out
- **State Management**: Uses Riverpod for reactive state management
- **Loading States**: Shows loading indicators during API calls
- **Error Handling**: Displays error messages with retry functionality

## Usage

### Navigation

```dart
// Navigate to the select primary account screen
context.pushNamed(RouteConstants.selectPrimaryAccount);
```

### State Management

The feature uses Riverpod for state management with the following structure:

#### State Class
```dart
class SelectPrimaryAccountState {
  final List<DepositAccount> accounts;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final DepositAccount? selectedAccount;
}
```

#### Providers
```dart
// Main notifier provider
final selectPrimaryAccountNotifierProvider = StateNotifierProvider<SelectPrimaryAccountNotifier, SelectPrimaryAccountState>((ref) {
  return SelectPrimaryAccountNotifier();
});

// Individual state providers
final selectPrimaryAccountAccountsProvider = Provider<List<DepositAccount>>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).accounts;
});

final selectPrimaryAccountSelectedProvider = Provider<DepositAccount?>((ref) {
  return ref.watch(selectPrimaryAccountNotifierProvider).selectedAccount;
});
```

### Data Model

The screen uses a `DepositAccount` model with the following properties:

```dart
class DepositAccount {
  final String accountType;      // Account type (e.g., "ບັນຊີເງິນຝາກປະຢັດ (LAK)")
  final String accountName;      // Account holder name
  final String accountNumber;    // Account number
  final double balance;          // Account balance
  final bool isPrimary;          // Whether this is the primary account
  final String currency;         // Currency (default: LAK)
}
```

### Customization

- **Colors**: Uses `AppColors.color1` for primary account selection
- **Styling**: Responsive design using `flutter_screenutil`
- **Language**: Supports Lao language text
- **Icons**: Uses Material Design icons

## API Integration

The feature now integrates with multiple API endpoints using your existing `DioClient` directly in the notifier:

### Primary Endpoint - Account Linkage
- **GET** `/v1/act/get_linkage?link_type=DPT`
- **Base URL**: `https://fund.nbb.com.la/api/`
- **Purpose**: Get list of linked deposit accounts
- **Authorization**: Automatically handled by existing `DioClient` with Bearer Token

### Secondary Endpoint - Account Details
- **GET** `/v1/act/get_fund_account_core/?acno={account_number}`
- **Purpose**: Get detailed account information (name, balance, type)
- **Called for each account** to populate real data

### API Response Structures

#### Account Linkage Response
```json
{
  "message": "Success",
  "data": [
    {
      "user_link_id": 2196,
      "link_type": "DPT",
      "user_id": 1044,
      "link_value": "0201010000205444001",
      "link_detail": null,
      "pass_sts": "N",
      "create_date": "2025-07-15T15:18:07.150Z"
    }
  ],
  "verify": true
}
```

#### Account Details Response
```json
{
  "message": "Success",
  "isHave": true,
  "isEmpty": false,
  "data": [
    {
      "ACNO": "0201010000205444001",
      "ACNAME": "ໄຊຍະເດດ ພຸດທະລາ",
      "Balance": 1699731.94,
      "Intpbl": 3071.6,
      "catname": "ເງິນຝາກປະຢັດ (ບຸກຄົນ, ວິສາຫະກິດ) - LAK - 2T - No Fee01",
      "mphone": {
        "HP": "95205783",
        "FP": "",
        "CP": ""
      },
      "MINAMT": 10000
    }
  ]
}
```

### Authentication
The notifier directly uses your existing `DioClient` which:
- Handles Bearer token authentication
- Automatically refreshes expired tokens
- Manages secure storage of access/refresh tokens
- No additional configuration needed

## Future Enhancements

- [x] API integration for real account data
- [x] Real account names and balances from API
- [x] Detailed account type information
- [ ] Account balance updates
- [ ] Transaction history integration
- [ ] Account type filtering
- [ ] Search functionality
