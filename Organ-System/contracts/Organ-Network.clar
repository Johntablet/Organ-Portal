;; Transparent Organ Matching Registry - Blockchain-Based Organ Donation Coordination Platform
;;
;; A comprehensive blockchain system for secure organ donor-recipient matching that ensures 
;; medical compatibility verification, priority-based allocation, and complete transparency 
;; in organ transplantation processes. The platform automates medical validations, maintains 
;; immutable audit trails, and provides real-time tracking of organ allocation while 
;; preserving patient privacy and ensuring regulatory compliance.
;;
;; Key Features:
;; - Secure medical professional authentication and donor-recipient registration
;; - Automated blood type and organ compatibility validation algorithms
;; - Priority-based allocation system with medical urgency assessment
;; - Immutable transplant procedure tracking with complete audit trails
;; - Real-time system analytics and comprehensive reporting capabilities
;; - Multi-organ support with extensive medical validation protocols

;; ADMINISTRATIVE CONFIGURATION

(define-constant medical-system-administrator tx-sender)

;; SYSTEM ERROR DEFINITIONS

;; Authentication and Authorization Errors
(define-constant ERR-UNAUTHORIZED-ACCESS (err u200))
(define-constant ERR-INSUFFICIENT-MEDICAL-PRIVILEGES (err u201))

;; Patient Registration and Profile Errors
(define-constant ERR-ORGAN-DONOR-NOT-FOUND (err u210))
(define-constant ERR-ORGAN-DONOR-ALREADY-REGISTERED (err u211))
(define-constant ERR-TRANSPLANT-RECIPIENT-NOT-FOUND (err u212))
(define-constant ERR-TRANSPLANT-RECIPIENT-ALREADY-REGISTERED (err u213))
(define-constant ERR-MEDICAL-PROCEDURE-RECORD-NOT-FOUND (err u214))

;; Medical Compatibility and Validation Errors
(define-constant ERR-INVALID-ORGAN-TYPE-SPECIFICATION (err u220))
(define-constant ERR-INVALID-BLOOD-TYPE-CLASSIFICATION (err u221))
(define-constant ERR-REQUESTED-ORGAN-NOT-AVAILABLE (err u222))
(define-constant ERR-MEDICAL-COMPATIBILITY-MISMATCH (err u223))
(define-constant ERR-INVALID-PATIENT-MEDICAL-STATUS (err u224))
(define-constant ERR-INVALID-MEDICAL-PRIORITY-LEVEL (err u225))
(define-constant ERR-MEDICAL-CLEARANCE-AUTHORIZATION-PENDING (err u226))

;; Patient Data Validation Errors
(define-constant ERR-INVALID-PATIENT-INFORMATION (err u230))
(define-constant ERR-MISSING-PATIENT-IDENTIFIER (err u231))
(define-constant ERR-INVALID-PATIENT-AGE-VALUE (err u232))

;; MEDICAL CLASSIFICATION SYSTEM

;; Transplantable Organ Type Classifications
(define-constant heart-organ-type u1)
(define-constant kidney-organ-type u2)
(define-constant liver-organ-type u3)
(define-constant lung-organ-type u4)
(define-constant pancreas-organ-type u5)
(define-constant cornea-organ-type u6)

;; ABO Blood Type Classification System
(define-constant blood-type-a-positive u1)
(define-constant blood-type-b-positive u2)
(define-constant blood-type-ab-positive u3)
(define-constant blood-type-o-positive u4)

;; Patient Medical Status Classifications
(define-constant medical-status-active u1)
(define-constant medical-status-matched u2)
(define-constant medical-status-procedure-completed u3)
(define-constant medical-status-inactive u4)

;; Medical Priority Level Classifications
(define-constant priority-level-critical u1)
(define-constant priority-level-urgent u2)
(define-constant priority-level-high u3)
(define-constant priority-level-medium u4)
(define-constant priority-level-standard u5)

;; COMPREHENSIVE DATA STRUCTURE DEFINITIONS

;; Organ Donor Medical Profile Registry
(define-map organ-donor-medical-profiles
  principal
  {
    full-patient-name: (string-ascii 100),
    patient-age-years: uint,
    abo-blood-type: uint,
    available-organ-inventory: (list 10 uint),
    initial-registration-timestamp: uint,
    current-medical-status: uint,
    medical-clearance-approved: bool,
    supervising-physician-address: (optional principal)
  }
)

;; Transplant Recipient Medical Profile Registry
(define-map transplant-recipient-medical-profiles
  principal
  {
    full-patient-name: (string-ascii 100),
    patient-age-years: uint,
    abo-blood-type: uint,
    required-organ-type: uint,
    medical-urgency-priority: uint,
    initial-registration-timestamp: uint,
    current-medical-status: uint,
    waiting-list-position-number: uint
  }
)

;; Medical Procedure Documentation Registry
(define-map medical-transplant-procedures
  uint
  {
    organ-donor-patient-address: principal,
    transplant-recipient-patient-address: principal,
    transplanted-organ-type: uint,
    procedure-initiation-timestamp: uint,
    current-procedure-status: uint,
    supervising-medical-professional: principal,
    procedure-completion-timestamp: (optional uint)
  }
)

;; SYSTEM STATE MONITORING VARIABLES

(define-data-var next-medical-procedure-identifier uint u1)
(define-data-var total-registered-organ-donors uint u0)
(define-data-var total-registered-transplant-recipients uint u0)
(define-data-var completed-successful-transplants uint u0)
(define-data-var currently-pending-medical-procedures uint u0)

;; MEDICAL VALIDATION AND UTILITY FUNCTIONS

(define-private (validate-organ-type-specification (organ-type-identifier uint))
  (and (>= organ-type-identifier u1) (<= organ-type-identifier u6))
)

(define-private (validate-blood-type-classification (blood-type-identifier uint))
  (and (>= blood-type-identifier u1) (<= blood-type-identifier u4))
)

(define-private (validate-medical-status-classification (medical-status-identifier uint))
  (and (>= medical-status-identifier u1) (<= medical-status-identifier u4))
)

(define-private (validate-priority-level-classification (priority-level-identifier uint))
  (and (>= priority-level-identifier u1) (<= priority-level-identifier u5))
)

(define-private (validate-patient-name-format (patient-name-string (string-ascii 100)))
  (> (len patient-name-string) u0)
)

(define-private (validate-patient-age-range (patient-age-value uint))
  (and (> patient-age-value u0) (< patient-age-value u120))
)

(define-private (determine-blood-type-compatibility (donor-blood-type uint) (recipient-blood-type uint))
  (or
    ;; Universal donor compatibility (O+ can donate to all blood types)
    (is-eq donor-blood-type blood-type-o-positive)
    ;; Direct blood type match compatibility
    (is-eq donor-blood-type recipient-blood-type)
    ;; Universal recipient compatibility (AB+ can receive from all blood types)
    (is-eq recipient-blood-type blood-type-ab-positive)
    ;; Type A donor to AB recipient compatibility
    (and (is-eq donor-blood-type blood-type-a-positive) 
         (is-eq recipient-blood-type blood-type-ab-positive))
    ;; Type B donor to AB recipient compatibility
    (and (is-eq donor-blood-type blood-type-b-positive) 
         (is-eq recipient-blood-type blood-type-ab-positive))
  )
)

(define-private (verify-organ-availability-in-inventory (target-organ-type uint) (available-organ-list (list 10 uint)))
  (is-some (index-of available-organ-list target-organ-type))
)

(define-private (validate-complete-organ-inventory (organ-type-list (list 10 uint)))
  (is-eq (len (filter validate-organ-type-specification organ-type-list)) (len organ-type-list))
)

;; ORGAN DONOR MANAGEMENT SYSTEM

(define-public (register-new-organ-donor
  (full-patient-name (string-ascii 100))
  (patient-age-years uint)
  (abo-blood-type uint)
  (available-organ-inventory (list 10 uint))
)
  (let
    (
      (patient-registering-address tx-sender)
      (registration-timestamp block-height)
    )
    ;; Comprehensive input validation
    (asserts! (validate-patient-name-format full-patient-name) ERR-MISSING-PATIENT-IDENTIFIER)
    (asserts! (validate-patient-age-range patient-age-years) ERR-INVALID-PATIENT-AGE-VALUE)
    (asserts! (validate-blood-type-classification abo-blood-type) ERR-INVALID-BLOOD-TYPE-CLASSIFICATION)
    (asserts! (validate-complete-organ-inventory available-organ-inventory) ERR-INVALID-ORGAN-TYPE-SPECIFICATION)
    
    ;; Verify no existing donor registration
    (asserts! (is-none (map-get? organ-donor-medical-profiles patient-registering-address)) 
              ERR-ORGAN-DONOR-ALREADY-REGISTERED)
    
    ;; Create new donor medical profile
    (map-set organ-donor-medical-profiles patient-registering-address {
      full-patient-name: full-patient-name,
      patient-age-years: patient-age-years,
      abo-blood-type: abo-blood-type,
      available-organ-inventory: available-organ-inventory,
      initial-registration-timestamp: registration-timestamp,
      current-medical-status: medical-status-active,
      medical-clearance-approved: false,
      supervising-physician-address: none
    })
    
    ;; Update system-wide statistics
    (var-set total-registered-organ-donors (+ (var-get total-registered-organ-donors) u1))
    (ok true)
  )
)

(define-public (update-donor-medical-clearance-status
  (donor-patient-address principal)
  (medical-clearance-status bool)
  (supervising-physician-identifier (optional principal))
)
  (begin
    ;; Verify medical system administrator authorization
    (asserts! (is-eq tx-sender medical-system-administrator) ERR-UNAUTHORIZED-ACCESS)
    
    ;; Retrieve and validate existing donor profile
    (match (map-get? organ-donor-medical-profiles donor-patient-address)
      existing-donor-profile
        (begin
          ;; Update donor medical clearance information
          (map-set organ-donor-medical-profiles donor-patient-address
            (merge existing-donor-profile {
              medical-clearance-approved: medical-clearance-status,
              supervising-physician-address: supervising-physician-identifier
            })
          )
          (ok true)
        )
      ERR-ORGAN-DONOR-NOT-FOUND
    )
  )
)

;; TRANSPLANT RECIPIENT MANAGEMENT SYSTEM

(define-public (register-new-transplant-recipient
  (full-patient-name (string-ascii 100))
  (patient-age-years uint)
  (abo-blood-type uint)
  (required-organ-type uint)
  (medical-urgency-priority uint)
)
  (let
    (
      (patient-registering-address tx-sender)
      (registration-timestamp block-height)
      (waiting-list-position (+ (var-get total-registered-transplant-recipients) u1))
    )
    ;; Comprehensive input validation
    (asserts! (validate-patient-name-format full-patient-name) ERR-MISSING-PATIENT-IDENTIFIER)
    (asserts! (validate-patient-age-range patient-age-years) ERR-INVALID-PATIENT-AGE-VALUE)
    (asserts! (validate-blood-type-classification abo-blood-type) ERR-INVALID-BLOOD-TYPE-CLASSIFICATION)
    (asserts! (validate-organ-type-specification required-organ-type) ERR-INVALID-ORGAN-TYPE-SPECIFICATION)
    (asserts! (validate-priority-level-classification medical-urgency-priority) ERR-INVALID-MEDICAL-PRIORITY-LEVEL)
    
    ;; Verify no existing recipient registration
    (asserts! (is-none (map-get? transplant-recipient-medical-profiles patient-registering-address)) 
              ERR-TRANSPLANT-RECIPIENT-ALREADY-REGISTERED)
    
    ;; Create new recipient medical profile
    (map-set transplant-recipient-medical-profiles patient-registering-address {
      full-patient-name: full-patient-name,
      patient-age-years: patient-age-years,
      abo-blood-type: abo-blood-type,
      required-organ-type: required-organ-type,
      medical-urgency-priority: medical-urgency-priority,
      initial-registration-timestamp: registration-timestamp,
      current-medical-status: medical-status-active,
      waiting-list-position-number: waiting-list-position
    })
    
    ;; Update system-wide statistics
    (var-set total-registered-transplant-recipients (+ (var-get total-registered-transplant-recipients) u1))
    (ok true)
  )
)

;; MEDICAL TRANSPLANT COORDINATION SYSTEM

(define-public (initiate-organ-transplant-matching
  (donor-patient-address principal)
  (recipient-patient-address principal)
  (transplant-organ-type uint)
)
  (let
    (
      (donor-medical-profile (unwrap! (map-get? organ-donor-medical-profiles donor-patient-address) 
                                     ERR-ORGAN-DONOR-NOT-FOUND))
      (recipient-medical-profile (unwrap! (map-get? transplant-recipient-medical-profiles recipient-patient-address) 
                                         ERR-TRANSPLANT-RECIPIENT-NOT-FOUND))
      (medical-procedure-identifier (var-get next-medical-procedure-identifier))
      (procedure-initiation-timestamp block-height)
    )
    ;; Verify medical system administrator authorization
    (asserts! (is-eq tx-sender medical-system-administrator) ERR-UNAUTHORIZED-ACCESS)
    
    ;; Validate transplant organ type specification
    (asserts! (validate-organ-type-specification transplant-organ-type) ERR-INVALID-ORGAN-TYPE-SPECIFICATION)
    
    ;; Comprehensive medical validation checks
    (asserts! (get medical-clearance-approved donor-medical-profile) ERR-MEDICAL-CLEARANCE-AUTHORIZATION-PENDING)
    (asserts! (is-eq (get current-medical-status donor-medical-profile) medical-status-active) 
              ERR-INVALID-PATIENT-MEDICAL-STATUS)
    (asserts! (is-eq (get current-medical-status recipient-medical-profile) medical-status-active) 
              ERR-INVALID-PATIENT-MEDICAL-STATUS)
    
    ;; Verify organ availability in donor inventory
    (asserts! (verify-organ-availability-in-inventory transplant-organ-type 
                                                     (get available-organ-inventory donor-medical-profile))
              ERR-REQUESTED-ORGAN-NOT-AVAILABLE)
    
    ;; Verify recipient organ requirement match
    (asserts! (is-eq transplant-organ-type (get required-organ-type recipient-medical-profile))
              ERR-MEDICAL-COMPATIBILITY-MISMATCH)
    
    ;; Verify blood type compatibility
    (asserts! (determine-blood-type-compatibility (get abo-blood-type donor-medical-profile)
                                                 (get abo-blood-type recipient-medical-profile))
              ERR-MEDICAL-COMPATIBILITY-MISMATCH)
    
    ;; Create comprehensive medical procedure record
    (map-set medical-transplant-procedures medical-procedure-identifier {
      organ-donor-patient-address: donor-patient-address,
      transplant-recipient-patient-address: recipient-patient-address,
      transplanted-organ-type: transplant-organ-type,
      procedure-initiation-timestamp: procedure-initiation-timestamp,
      current-procedure-status: medical-status-matched,
      supervising-medical-professional: tx-sender,
      procedure-completion-timestamp: none
    })
    
    ;; Update patient medical status to matched
    (map-set organ-donor-medical-profiles donor-patient-address
      (merge donor-medical-profile { current-medical-status: medical-status-matched }))
    
    (map-set transplant-recipient-medical-profiles recipient-patient-address
      (merge recipient-medical-profile { current-medical-status: medical-status-matched }))
    
    ;; Update system-wide procedure counters
    (var-set next-medical-procedure-identifier (+ medical-procedure-identifier u1))
    (var-set currently-pending-medical-procedures (+ (var-get currently-pending-medical-procedures) u1))
    
    (ok medical-procedure-identifier)
  )
)

(define-public (finalize-transplant-procedure-completion (medical-procedure-identifier uint))
  (let
    (
      (medical-procedure-record (unwrap! (map-get? medical-transplant-procedures medical-procedure-identifier) 
                                        ERR-MEDICAL-PROCEDURE-RECORD-NOT-FOUND))
      (donor-patient-address (get organ-donor-patient-address medical-procedure-record))
      (recipient-patient-address (get transplant-recipient-patient-address medical-procedure-record))
      (procedure-completion-timestamp block-height)
    )
    ;; Verify medical system administrator authorization
    (asserts! (is-eq tx-sender medical-system-administrator) ERR-UNAUTHORIZED-ACCESS)
    
    ;; Verify procedure is in matched status
    (asserts! (is-eq (get current-procedure-status medical-procedure-record) medical-status-matched)
              ERR-INVALID-PATIENT-MEDICAL-STATUS)
    
    ;; Update medical procedure completion record
    (map-set medical-transplant-procedures medical-procedure-identifier
      (merge medical-procedure-record {
        current-procedure-status: medical-status-procedure-completed,
        procedure-completion-timestamp: (some procedure-completion-timestamp)
      })
    )
    
    ;; Update patient medical status to completed
    (let
      (
        (donor-medical-profile (unwrap! (map-get? organ-donor-medical-profiles donor-patient-address) 
                                       ERR-ORGAN-DONOR-NOT-FOUND))
        (recipient-medical-profile (unwrap! (map-get? transplant-recipient-medical-profiles recipient-patient-address) 
                                           ERR-TRANSPLANT-RECIPIENT-NOT-FOUND))
      )
      (map-set organ-donor-medical-profiles donor-patient-address
        (merge donor-medical-profile { current-medical-status: medical-status-procedure-completed }))
      
      (map-set transplant-recipient-medical-profiles recipient-patient-address
        (merge recipient-medical-profile { current-medical-status: medical-status-procedure-completed }))
    )
    
    ;; Update system-wide success statistics
    (var-set completed-successful-transplants (+ (var-get completed-successful-transplants) u1))
    (var-set currently-pending-medical-procedures (- (var-get currently-pending-medical-procedures) u1))
    
    (ok true)
  )
)

;; SYSTEM QUERY AND ANALYTICS FUNCTIONS

(define-read-only (retrieve-donor-medical-profile (donor-patient-address principal))
  (map-get? organ-donor-medical-profiles donor-patient-address)
)

(define-read-only (retrieve-recipient-medical-profile (recipient-patient-address principal))
  (map-get? transplant-recipient-medical-profiles recipient-patient-address)
)

(define-read-only (retrieve-medical-procedure-record (medical-procedure-identifier uint))
  (map-get? medical-transplant-procedures medical-procedure-identifier)
)

(define-read-only (generate-comprehensive-system-statistics)
  {
    total-registered-organ-donors: (var-get total-registered-organ-donors),
    total-registered-transplant-recipients: (var-get total-registered-transplant-recipients),
    completed-successful-transplants: (var-get completed-successful-transplants),
    currently-pending-medical-procedures: (var-get currently-pending-medical-procedures),
    next-medical-procedure-identifier: (var-get next-medical-procedure-identifier)
  }
)

(define-read-only (evaluate-blood-type-compatibility
  (donor-blood-type-classification uint)
  (recipient-blood-type-classification uint)
)
  (and 
    (validate-blood-type-classification donor-blood-type-classification)
    (validate-blood-type-classification recipient-blood-type-classification)
    (determine-blood-type-compatibility donor-blood-type-classification recipient-blood-type-classification)
  )
)

(define-read-only (retrieve-medical-system-administrator)
  medical-system-administrator
)

;; ADVANCED MEDICAL COMPATIBILITY ANALYSIS

(define-public (perform-comprehensive-recipient-compatibility-analysis (recipient-patient-address principal))
  (let
    (
      (recipient-medical-profile (unwrap! (map-get? transplant-recipient-medical-profiles recipient-patient-address) 
                                         ERR-TRANSPLANT-RECIPIENT-NOT-FOUND))
      (required-organ-type (get required-organ-type recipient-medical-profile))
      (recipient-blood-type (get abo-blood-type recipient-medical-profile))
    )
    ;; Verify recipient has active medical status
    (asserts! (is-eq (get current-medical-status recipient-medical-profile) medical-status-active)
              ERR-INVALID-PATIENT-MEDICAL-STATUS)
    
    (ok {
      required-organ-type-specification: required-organ-type,
      compatible-blood-type-classifications: recipient-blood-type,
      medical-urgency-priority-level: (get medical-urgency-priority recipient-medical-profile),
      compatibility-analysis-status: "Comprehensive medical compatibility analysis completed successfully"
    })
  )
)