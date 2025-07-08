# Transparent Organ Matching Registry Smart Contract

A comprehensive blockchain-based organ donation coordination platform that ensures secure, transparent, and efficient organ donor-recipient matching while maintaining complete medical compatibility verification and regulatory compliance.

## Overview

The TransparentOrganMatchingRegistry is a smart contract system built on the Stacks blockchain that revolutionizes organ transplantation coordination by providing:

- **Secure Medical Authentication**: Verified medical professional access and patient registration
- **Automated Compatibility Matching**: Advanced algorithms for blood type and organ compatibility validation
- **Priority-Based Allocation**: Medical urgency assessment and fair distribution system
- **Immutable Audit Trails**: Complete transparency in organ allocation and transplant procedures
- **Real-Time Analytics**: Comprehensive system monitoring and reporting capabilities
- **Multi-Organ Support**: Extensive support for various organ types with robust medical validation

## Key Features

### Medical Professional Authentication
- Secure administrator-level access controls
- Medical professional verification system
- Authorized personnel management

### Patient Registration System
- Comprehensive donor and recipient profile management
- Medical history and compatibility data storage
- Automated validation of patient information

### Advanced Compatibility Matching
- ABO blood type compatibility algorithms
- Organ-specific matching criteria
- Medical clearance verification
- Priority-based allocation system

### Transparency & Audit Trail
- Immutable procedure tracking
- Complete transplant history
- Real-time system analytics
- Regulatory compliance reporting

## Supported Organ Types

| Organ Type | Identifier | Description |
|------------|------------|-------------|
| Heart      | 1          | Cardiac transplantation |
| Kidney     | 2          | Renal transplantation |
| Liver      | 3          | Hepatic transplantation |
| Lung       | 4          | Pulmonary transplantation |
| Pancreas   | 5          | Pancreatic transplantation |
| Cornea     | 6          | Corneal transplantation |

## Blood Type Compatibility

| Blood Type | Identifier | Compatibility |
|------------|------------|---------------|
| A+         | 1          | Can receive from A+, A-, O+, O- |
| B+         | 2          | Can receive from B+, B-, O+, O- |
| AB+        | 3          | Universal recipient |
| O+         | 4          | Universal donor |

## Medical Priority Levels

| Priority Level | Identifier | Description |
|----------------|------------|-------------|
| Critical       | 1          | Life-threatening, immediate need |
| Urgent         | 2          | Severe condition, urgent care needed |
| High           | 3          | Serious condition, timely care required |
| Medium         | 4          | Moderate condition, routine scheduling |
| Standard       | 5          | Stable condition, standard waiting list |

## Core Functions

### Donor Management

#### `register-new-organ-donor`
Register a new organ donor in the system.

**Parameters:**
- `full-patient-name` (string-ascii 100): Patient's full name
- `patient-age-years` (uint): Patient's age in years
- `abo-blood-type` (uint): ABO blood type classification
- `available-organ-inventory` (list 10 uint): List of available organs

**Example:**
```clarity
(register-new-organ-donor "John Doe" u35 blood-type-o-positive (list heart-organ-type kidney-organ-type))
```

#### `update-donor-medical-clearance-status`
Update medical clearance status for a donor (Administrator only).

**Parameters:**
- `donor-patient-address` (principal): Donor's wallet address
- `medical-clearance-status` (bool): Clearance approval status
- `supervising-physician-identifier` (optional principal): Supervising physician's address

### Recipient Management

#### `register-new-transplant-recipient`
Register a new transplant recipient in the system.

**Parameters:**
- `full-patient-name` (string-ascii 100): Patient's full name
- `patient-age-years` (uint): Patient's age in years
- `abo-blood-type` (uint): ABO blood type classification
- `required-organ-type` (uint): Required organ type
- `medical-urgency-priority` (uint): Medical priority level

**Example:**
```clarity
(register-new-transplant-recipient "Jane Smith" u42 blood-type-a-positive heart-organ-type priority-level-critical)
```

### Transplant Coordination

#### `initiate-organ-transplant-matching`
Initiate organ matching between donor and recipient (Administrator only).

**Parameters:**
- `donor-patient-address` (principal): Donor's wallet address
- `recipient-patient-address` (principal): Recipient's wallet address
- `transplant-organ-type` (uint): Organ type for transplant

**Returns:** Medical procedure identifier

#### `finalize-transplant-procedure-completion`
Mark a transplant procedure as completed (Administrator only).

**Parameters:**
- `medical-procedure-identifier` (uint): Procedure ID to finalize

### Query Functions

#### `retrieve-donor-medical-profile`
Get donor medical profile information.

#### `retrieve-recipient-medical-profile`
Get recipient medical profile information.

#### `retrieve-medical-procedure-record`
Get medical procedure details.

#### `generate-comprehensive-system-statistics`
Get system-wide statistics and analytics.

#### `evaluate-blood-type-compatibility`
Check blood type compatibility between donor and recipient.

## Error Codes

### Authentication Errors
- `ERR-UNAUTHORIZED-ACCESS (200)`: Unauthorized access attempt
- `ERR-INSUFFICIENT-MEDICAL-PRIVILEGES (201)`: Insufficient medical privileges

### Registration Errors
- `ERR-ORGAN-DONOR-NOT-FOUND (210)`: Organ donor not found
- `ERR-ORGAN-DONOR-ALREADY-REGISTERED (211)`: Donor already registered
- `ERR-TRANSPLANT-RECIPIENT-NOT-FOUND (212)`: Recipient not found
- `ERR-TRANSPLANT-RECIPIENT-ALREADY-REGISTERED (213)`: Recipient already registered

### Medical Validation Errors
- `ERR-INVALID-ORGAN-TYPE-SPECIFICATION (220)`: Invalid organ type
- `ERR-INVALID-BLOOD-TYPE-CLASSIFICATION (221)`: Invalid blood type
- `ERR-MEDICAL-COMPATIBILITY-MISMATCH (223)`: Medical compatibility mismatch
- `ERR-MEDICAL-CLEARANCE-AUTHORIZATION-PENDING (226)`: Medical clearance pending

### Data Validation Errors
- `ERR-INVALID-PATIENT-INFORMATION (230)`: Invalid patient information
- `ERR-MISSING-PATIENT-IDENTIFIER (231)`: Missing patient identifier
- `ERR-INVALID-PATIENT-AGE-VALUE (232)`: Invalid patient age

## Security Features

### Access Control
- **Administrator-only functions**: Critical operations require administrator privileges
- **Medical professional verification**: Supervised medical clearance process
- **Patient authentication**: Secure patient registration and profile management

### Data Integrity
- **Immutable records**: All transplant procedures are permanently recorded
- **Validation checks**: Comprehensive input validation for all functions
- **Medical compatibility verification**: Automated blood type and organ matching

### Privacy Protection
- **Minimal data exposure**: Only necessary medical information is stored
- **Secure addressing**: Patient identification through blockchain addresses
- **Optional physician linking**: Flexible medical professional association

## Deployment

### Prerequisites
- Stacks blockchain development environment
- Clarity smart contract deployment tools
- Administrator wallet setup

### Configuration
1. Deploy the smart contract to the Stacks blockchain
2. Set the medical system administrator address
3. Configure medical professional access controls
4. Initialize system parameters

## Usage Examples

### Register a Donor
```clarity
;; Register a multi-organ donor
(register-new-organ-donor 
  "Alice Johnson" 
  u28 
  blood-type-o-positive 
  (list heart-organ-type liver-organ-type kidney-organ-type))
```

### Register a Recipient
```clarity
;; Register a critical heart recipient
(register-new-transplant-recipient 
  "Bob Wilson" 
  u45 
  blood-type-a-positive 
  heart-organ-type 
  priority-level-critical)
```

### Check Compatibility
```clarity
;; Check blood type compatibility
(evaluate-blood-type-compatibility blood-type-o-positive blood-type-a-positive)
```

## System Statistics

The system maintains comprehensive analytics including:
- Total registered organ donors
- Total registered transplant recipients
- Completed successful transplants
- Currently pending medical procedures
- Next medical procedure identifier