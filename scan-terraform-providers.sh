#!/bin/bash

echo "🔍 Scanning Terraform files for unpinned or missing provider versions..."

found_any=false

# Loop over all .tf files
find . -type f -name "*.tf" | while read -r file; do
    has_block=$(grep -E "required_providers\s*{" "$file")

    if [[ -z "$has_block" ]]; then
        echo "🚨 $file: No 'required_providers' block found!"
    else
        echo "📄 Found required_providers block in: $file"
        found_any=true

        # Extract and process the required_providers block
        awk '/required_providers\s*{/,/}/' "$file" | while read -r prov_line; do
            if echo "$prov_line" | grep -q '='; then
                key=$(echo "$prov_line" | awk -F= '{print $1}' | tr -d '[:space:]')
                val=$(echo "$prov_line" | awk -F= '{print $2}' | tr -d '[:space:"{}]')

                # Skip source lines
                if [[ "$key" == "source" ]]; then
                    continue
                fi

                if [[ -z "$val" ]]; then
                    echo "❌ $file: '$key' has no version pinned!"
                elif [[ "$val" == "*" || "$val" == "~>"* || "$val" == ">="* ]]; then
                    echo "⚠️ $file: '$key' is loosely pinned: version = $val"
                else
                    echo "✅ $file: '$key' is pinned: version = $val"
                fi
            fi
        done
    fi

    echo ""
done
