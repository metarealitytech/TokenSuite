
# Audit Submission Brief: Gravitons, Digital Oxygen, Digital Carbon

## Project Name
Gravitons (GRAVI), Digital Oxygen (NEEV), Digital Carbon (cNEEV)

## Description
This project includes three fixed-supply, non-upgradeable ERC-20 tokens intended for long-term public utility in DeFi, GameFi, and cross-chain ecosystems.

## Audit Scope
The scope of this audit submission includes the following contracts:
- Gravitons.sol
- DigitalOxygen.sol
- DigitalCarbon.sol

Each token contract:
- Is implemented in a single Solidity file
- Contains all interface declarations inline (no external imports)
- Uses Solidity version 0.8.19
- Is non-upgradeable and has no ownership, admin, or privileged roles

## Standards Implemented
- ERC-20 (`IERC20`, `IERC20Metadata`)
- EIP-2612 Permit (`IERC20Permit`)
- ERC-1363 (`transferAndCall`, `approveAndCall`)
- Burnable (`burn`, `burnFrom`)

## Security Objectives
- No upgrade proxies or mutable access control
- No minting beyond initial supply
- No ability to pause, freeze, or censor token transfers
- No reentrancy hazards or vulnerable fallback logic
- Full support for modern integrations (DEXs, bridges, indexers)

## Deployment Strategy
- Tokens will be deployed to Ethereum Mainnet using Hardhat
- Deployment is automated via TypeScript and `.env` configs
- Token verification will be completed via Etherscan
- Tokens will be bridged to Base and Optimism using Supermigrate.xyz

## Deliverables
- Single file `.sol` contracts for each token
- README.md for setup, deployment, and verification
- audit-checklist.md for compliance documentation
- LICENSE: MIT

## Intended Use Cases
- Gravitons: Governance + onchain game utility
- Digital Oxygen: Long-term DeFi asset
- Digital Carbon: Burn-based offset tracking and staking

## Auditor Notes
All contracts are designed to live onchain indefinitely with no external upgrade mechanism. This makes them fully decentralized from the moment of deployment.

## Contact
GitHub: https://github.com/<your-org-or-username>
Contact: <email or TG handle>
Submitted by: <Your name or project name>
Date: 2025
