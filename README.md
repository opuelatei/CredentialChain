# CredentialChain - Decentralized Academic Credential Registry

A blockchain-based solution for secure academic credential management using Stacks (STX) and Bitcoin.

## Overview

CredentialChain is a sophisticated smart contract system designed to revolutionize academic credential management through blockchain technology. Built on Stacks for smart contract functionality and anchored to Bitcoin for ultimate security, this system enables:

- Tamper-proof credential issuance
- Decentralized verification
- Institutional reputation tracking
- Cross-organizational endorsements
- Secure credential transfers

## Key Features

### Institutional Management

- STX-based registration with minimum stake
- Reputation scoring system
- Delegate authorization controls
- Activity monitoring & suspension handling

### Credential Operations

- Cryptographic credential issuance
- Expiry and revocation controls
- Batch processing (up to 50 credentials)
- Rich metadata support (IPFS/Arweave URLs)

### Verification System

- Multi-party endorsements
- Weighted validation system
- Permanent audit trails
- Real-time status checks

### Transfer Mechanism

- Owner-initiated transfers
- Time-bound transfer requests
- Transfer type categorization
- Transaction history tracking

## Smart Contract Details

### Data Structures

#### Institutions

```clarity
{
    name: (string-ascii 64),
    stake-amount: uint,
    credentials-issued: uint,
    reputation-score: uint,
    active: bool,
    suspension-status: bool,
    registration-date: uint,
    last-update: uint
}
```

#### Credentials

```clarity
{
    institution: principal,
    degree: (string-ascii 64),
    year: uint,
    verified: bool,
    validation-level: uint,
    endorsements: uint,
    metadata-url: (string-ascii 256),
    expiry-date: uint,
    revoked: bool,
    category: (string-ascii 32),
    issue-date: uint,
    last-endorsed: uint
}
```

## Core Functions

### Institution Registration

```clarity
(register-institution (name (string-ascii 64)))
```

- Requires 1,000,000 uSTX stake
- Establishes institutional identity
- Initializes reputation score at 100

### Credential Issuance

```clarity
(issue-credential
    (credential-id (string-ascii 64))
    (student principal)
    (degree (string-ascii 64))
    (year uint)
    (metadata-url (string-ascii 256))
    (expiry-date uint)
    (category (string-ascii 32)))
```

- Creates immutable credential record
- Sets expiration timeline
- Categorizes credential type
- Links to external metadata

### Endorsement System

```clarity
(endorse-credential-extended
    (credential-id (string-ascii 64))
    (student principal)
    (weight uint)
    (comment (string-ascii 256))
    (endorser-type (string-ascii 32)))
```

- Weighted endorsement (1-100)
- Comment field for qualitative feedback
- Endorser type classification
- Automatic reputation updates

## Error Codes

| Code | Constant                 | Description                        |
| ---- | ------------------------ | ---------------------------------- |
| 100  | ERR-NOT-AUTHORIZED       | Unauthorized access attempt        |
| 101  | ERR-ALREADY-REGISTERED   | Duplicate institution registration |
| 102  | ERR-INSUFFICIENT-STAKE   | Minimum stake requirement not met  |
| 103  | ERR-CREDENTIAL-NOT-FOUND | Invalid credential reference       |
| 104  | ERR-ALREADY-VERIFIED     | Redundant verification attempt     |
| 105  | ERR-INVALID-STATUS       | Illegal state transition           |
| 106  | ERR-EXPIRED              | Expired credential operation       |
| 107  | ERR-BATCH-FAILED         | Batch operation partial failure    |
| 108  | ERR-TRANSFER-FAILED      | Credential transfer rejection      |
| 109  | ERR-INVALID-BATCH-SIZE   | Exceeds maximum batch capacity     |
| 110  | ERR-INVALID-DELEGATION   | Invalid delegate configuration     |
| 111  | ERR-ALREADY-ENDORSED     | Duplicate endorsement attempt      |
| 112  | ERR-INVALID-EXPIRY       | Invalid timestamp configuration    |
| 113  | ERR-INVALID-INPUT        | Malformed input data               |
| 120  | ERR-EMPTY-STRING         | Required string field missing      |

## Security Features

1. **Bitcoin Finality**: All transactions secured by Bitcoin's blockchain
2. **STX Staking**: Economic incentives for proper behavior
3. **Input Validation**: Comprehensive data sanitization
4. **Delegate Expiry**: Time-bound access controls
5. **Revocation System**: Immediate credential invalidation

## Workflow Examples

### Institutional Onboarding

1. Transfer 1,000,000 uSTX to contract
2. Call `register-institution` with metadata
3. Begin issuing credentials after confirmation

### Credential Lifecycle

1. Institution issues credential with `issue-credential`
2. Third-parties add endorsements via `endorse-credential-extended`
3. Student initiates transfer with `request-credential-transfer`
4. Automatic expiration at specified block height
