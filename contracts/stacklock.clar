;; StackLock - Time-Locked STX Vault

(define-data-var lock-counter uint u0)

(define-map locks
  { id: uint }
  {
    owner: principal,
    amount: uint,
    unlock-block: uint,
    withdrawn: bool
  })

;; Lock STX for a period
(define-public (create-lock (amount uint) (unlock-block uint))
  (let (
        (id (var-get lock-counter))
      )
    (begin
      (asserts! (> amount u0) (err u100))
      (asserts! (> unlock-block stacks-block-height) (err u101))

      ;; Store the lock
      (map-set locks { id: id } {
        owner: tx-sender,
        amount: amount,
        unlock-block: unlock-block,
        withdrawn: false
      })

      (var-set lock-counter (+ id u1))
      (ok { lock-id: id, amount: amount, unlock: unlock-block })
    )))

;; Withdraw unlocked STX
(define-public (withdraw (lock-id uint))
  (let (
        (lock (unwrap! (map-get? locks { id: lock-id }) (err u102)))
      )
    (begin
      (asserts! (is-eq (get owner lock) tx-sender) (err u103))
      (asserts! (is-eq (get withdrawn lock) false) (err u104))
      (asserts! (>= stacks-block-height (get unlock-block lock)) (err u105))

      ;; Transfer STX
      (try! (stx-transfer? (get amount lock) (as-contract tx-sender) tx-sender))

      ;; Mark as withdrawn
      (map-set locks { id: lock-id } (merge lock { withdrawn: true }))

      (ok { status: "withdrawn", amount: (get amount lock) })
    )))

;; View a lock
(define-read-only (get-lock (lock-id uint))
  (map-get? locks { id: lock-id }))

;; View the next lock ID
(define-read-only (get-next-id) (ok (var-get lock-counter)))
