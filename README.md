 StackLock Smart Contract

 Overview
**StackLock** is a Clarity smart contract on the Stacks blockchain designed for time-locked STX transfers. It enables users to securely lock STX tokens for a specified duration (measured in block heights), ensuring that recipients can only withdraw the tokens after the lock period has expired. This is ideal for use cases such as deferred payments, vesting schedules, or savings plans.

---

 Features
-  Time-Locked Transfers: Lock STX tokens for a defined number of blocks.
-  Secure Withdrawal: Recipients can only withdraw funds after the lock period.
-  Transparency: Anyone can query lock details.
-  Security Checks: Prevents unauthorized access and premature withdrawals.

---

 Smart Contract Functions

 Public Functions
- `lock-funds (recipient principal) (amount uint) (unlock-block uint)`
  - Locks a specified `amount` of STX for a `recipient` until `unlock-block` height.
  
- `withdraw`
  - Allows the designated recipient to withdraw their locked STX once the block height condition is met.

 Read-Only Functions
- `get-lock-details (recipient principal)`
  - Retrieves the details of the locked amount, unlock block, and status for a given recipient.

---


