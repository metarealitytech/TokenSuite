
# Gravitons, Digital Oxygen, Digital Carbon — ERC-20 Token Suite
[![Audit Ready](https://img.shields.io/badge/audit-ready-brightgreen)](./Audit_Submission_Brief.md)


This repository contains the full source code, deployment scripts, and tests for three Ethereum-based tokens:
- 🌀 **Gravitons (GRAVI)**
- 🌬️ **Digital Oxygen (NEEV)**
- 🌱 **Digital Carbon (cNEEV)**

All contracts are:
- ✅ Fully ERC-20 compliant
- ✅ Immutable (no upgradeability)
- ✅ Fixed supply
- ✅ Support EIP-2612 (permit), ERC-1363 (transferAndCall), and burn functionality
- ✅ Verified on Sepolia and ready for Mainnet

---

## 📄 Contracts Overview

| Token            | Symbol | Sepolia Address                                                              | Mainnet Address        |
|------------------|--------|------------------------------------------------------------------------------|------------------------|
| Gravitons        | GRAVI  | `0xeB6d2892c34fE57FfdAE7E7778571664903b7501`                                  | *(TBD)*                |
| Digital Oxygen   | NEEV   | `0x559610D54a183a172b3ed298d9f7a6F7883b468D`                                  | *(TBD)*                |
| Digital Carbon   | cNEEV  | `0xC500cfF81cB2b851202992b05a3bEFa0B8069365`                                  | *(TBD)*                |

After deploying to mainnet, replace each `TBD` with the live Ethereum address.

---

## 📦 Project Structure

```
/Gravitons
/DigitalOxygen
/DigitalCarbon
audit-checklist.md
Audit_Submission_Brief.md
README.md
LICENSE
```

Each token has its own contract, deploy script, and test suite.

---

## 🚀 How to Deploy

1. Clone the repo  
2. Fill in `.env` using `.env.example`  
3. Install dependencies:

```bash
npm install
```

4. Compile contracts:

```bash
npx hardhat compile
```

5. Deploy to Sepolia or Mainnet:

```bash
npx hardhat run scripts/deploy.ts --network sepolia
npx hardhat run scripts/deploy.ts --network mainnet
```

---

## 🔍 How to Verify

```bash
npx hardhat verify --network sepolia <contract-address>
npx hardhat verify --network mainnet <contract-address>
```

---

## 🧪 How to Run Tests

```bash
npx hardhat test
```

---

## 📬 For Auditors

- `contracts/*.sol` – Full single-file token code with ASCII art
- `audit-checklist.md` – Pre-flight compliance
- `Audit_Submission_Brief.md` – Scope + security goals
- `README.md` – Project + deployment docs

---

## 🧠 License

MIT © 2025
