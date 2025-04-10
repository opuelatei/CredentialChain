;; Title: CredentialChain - Decentralized Academic Credential Registry
;; 
;; Summary:
;; A robust and secure smart contract system for managing, verifying, and 
;; transferring academic credentials on the Stacks blockchain, leveraging 
;; Bitcoin's security model.
;;
;; Description:
;; This contract implements a comprehensive credential management system that enables:
;; - Educational institutions to register and manage their digital presence
;; - Secure issuance of verifiable academic credentials
;; - Multi-stakeholder endorsement system for credential validation
;; - Delegated authority management for institutional operations
;; - Secure credential transfer mechanisms with expiry controls
;; - Reputation scoring system for participating institutions
;;
;; The system is designed with Bitcoin finality guarantees and Stacks Layer 2
;; scalability in mind, making it suitable for large-scale academic credential
;; management while maintaining the highest security standards.

;; Constants
(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-INSUFFICIENT-STAKE (err u102))
(define-constant ERR-CREDENTIAL-NOT-FOUND (err u103))
(define-constant ERR-ALREADY-VERIFIED (err u104))
(define-constant ERR-INVALID-STATUS (err u105))
(define-constant ERR-EXPIRED (err u106))
(define-constant ERR-BATCH-FAILED (err u107))
(define-constant ERR-TRANSFER-FAILED (err u108))
(define-constant ERR-INVALID-BATCH-SIZE (err u109))
(define-constant ERR-INVALID-DELEGATION (err u110))
(define-constant ERR-ALREADY-ENDORSED (err u111))
(define-constant MINIMUM-STAKE u1000000)
(define-constant MAX-BATCH-SIZE u50)

;; Data Variables
(define-data-var transfer-counter uint u0)
(define-data-var total-institutions uint u0)
(define-data-var governance-token-address principal 'SP000000000000000000002Q6VF78)

;; Data Maps
(define-map institutions 
    principal 
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
)

(define-map credentials
    {id: (string-ascii 64), student: principal}
    {
        institution: principal,
        degree: (string-ascii 64),
        year: uint,
        verified: bool,
        endorsements: uint,
        metadata-url: (string-ascii 256),
        expiry-date: uint,
        revoked: bool,
        category: (string-ascii 32),
        issue-date: uint,
        last-endorsed: uint
    }
)

(define-map endorsements
    {credential-id: (string-ascii 64), endorser: principal}
    {
        timestamp: uint,
        weight: uint,
        comment: (string-ascii 256),
        endorser-type: (string-ascii 32)
    }
)

(define-map institution-delegates
    {institution: principal, delegate: principal}
    {
        active: bool,
        permissions: (list 10 (string-ascii 32)),
        added-at: uint,
        expiry: uint
    }
)

(define-map transfer-requests
    uint
    {
        credential-id: (string-ascii 64),
        old-owner: principal,
        new-owner: principal,
        status: (string-ascii 16),
        request-time: uint,
        expiry-time: uint,
        transfer-type: (string-ascii 32)
    }
)

;; Institution Management Functions

(define-public (register-institution (name (string-ascii 64)))
    (let ((caller tx-sender))
        (asserts! (not (default-to false (get active (map-get? institutions caller)))) ERR-ALREADY-REGISTERED)
        (try! (stx-transfer? MINIMUM-STAKE caller (as-contract tx-sender)))
        
        (map-set institutions caller {
            name: name,
            stake-amount: MINIMUM-STAKE,
            credentials-issued: u0,
            reputation-score: u100,
            active: true,
            suspension-status: false,
            registration-date: block-height,
            last-update: block-height
        })
        
        (var-set total-institutions (+ (var-get total-institutions) u1))
        (ok true)
    )
)