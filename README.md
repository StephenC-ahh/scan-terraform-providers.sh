# scan-terraform-providers.sh

A simple Bash script to scan Terraform `.tf` files for missing or unpinned provider versions.

## 🔍 What It Does

- Finds all Terraform files recursively in the current directory.
- Detects whether each file has a `required_providers` block.
- Checks each declared provider for:
  - ❌ Missing version pin
  - ⚠️ Loosely pinned versions (`*`, `~>`, `>=`)
  - ✅ Properly pinned versions
- Skips `source` lines to avoid false positives.

## 🛠️ Usage

Make the script executable and run it from your repo's root:

```bash
chmod +x scan-terraform-providers.sh
./scan-terraform-providers.sh
``` 


🔍 Scanning Terraform files for unpinned or missing provider versions...

🚨 ./main.tf: No 'required_providers' block found!

📄 Found required_providers block in: ./modules/network/main.tf
❌ ./modules/network/main.tf: 'aws' has no version pinned!
⚠️ ./modules/network/main.tf: 'azurerm' is loosely pinned: version = ~>3.0
✅ ./modules/network/main.tf: 'google' is pinned: version = 4.61.0

📁 Requirements
Bash
Common Unix tools: grep, awk, tr
📌 Notes
This script does not validate .terraform.lock.hcl
It only inspects required_providers blocks and their version attributes
Useful for CI checks, code hygiene, and compliance audits