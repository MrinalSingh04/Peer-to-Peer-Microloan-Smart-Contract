# Peer-to-Peer Microloan Smart Contract 💰🤝

## 📌 What
A **decentralized microloan smart contract** that enables lenders 💳 and borrowers 🧑‍🌾 to connect directly on-chain without intermediaries.  
All transactions use **ERC-20 tokens** 💱, and borrowers must lock **collateral** 🔒 before receiving the loan.

The contract automates:
- 📝 Loan creation by lenders.
- 🔒 Collateral deposit by borrowers.  
- 💵 Repayment with interest before a due date.  
- 🔄 Automatic collateral return upon repayment.
- ⚠️ Collateral claim by lenders if the borrower defaults. 
 
### ✨ Key Features
- **Lender offers loan**:
  - 📍 ERC-20 token address
  - 💰 Loan amount
  - 📈 Interest rate (%)
  - ⏳ Repayment duration
- **Borrower takes loan**:
  - Locks collateral in ERC-20 tokens 💱
  - Instantly receives loan amount ⚡
- **Repayment**:
  - Pays principal + interest ✅
  - Gets collateral back 🔄
- **Default**:
  - Lender claims collateral if unpaid 🛡️

---

## 💡 Why
Traditional lending systems:
- 🏦 Rely on banks, brokers, and middlemen (extra costs 💸).
- 🕐 Involve slow manual approvals and paperwork.
- 🚫 Exclude underbanked populations.
- 😒 Sometimes have unfair or hidden fees.

This blockchain-based system:
- 🤝 Enables **trustless, peer-to-peer lending**.
- 🔍 Offers **full transparency** — all terms & repayments are public.
- 🛡️ Protects both lender and borrower with on-chain collateral.
- 🌍 Works **globally** without restrictions.
- ⚡ Executes transactions in seconds.

---

## 🔄 How It Works
1. 🏦 **Loan Creation** — Lender calls `offerLoan` 📜 and deposits loan amount into the contract.
2. 🧾 **Loan Acceptance** — Borrower calls `takeLoan` and locks required collateral.
3. 💵 **Repayment** — Borrower calls `repayLoan` before due date to pay back principal + interest. Collateral is released 🔓.
4. ⚠️ **Default Handling** — If not repaid on time ⏳, lender calls `claimCollateral` to receive borrower’s collateral.

---

## 🌱 Example Use Case
- 👨‍🌾 A farmer needs **200 USDT** to buy seeds.
- 💳 A lender offers at **5% interest** for 90 days.
- 🔒 Farmer locks **200 USDT** as collateral and receives the loan instantly.
- ✅ If repaid **210 USDT** before due date, collateral is returned.
- ❌ If not repaid, lender claims the **200 USDT** collateral.

