#!/usr/bin/env python3

"""
Policy Documentation Sync Tool

This script helps maintain synchronization between policy implementations and their documentation.
It updates the policy content embedded in markdown files with the current content from the actual
policy files in the aap_policy_examples directory.

Usage:
    make tools/sync-markdown

The script expects:
1. Policy files to be in the aap_policy_examples/ directory
2. Markdown files to reference policies using the format [aap_policy_examples/policy_name]
3. Policy content to be embedded in markdown files using rego code blocks (```rego)

Example markdown format:
    ## Example Policy [aap_policy_examples/allowed_false.rego](aap_policy_examples/allowed_false.rego):
    
    ```rego
    package aap_policy_examples
    ...
    ```
"""

import os
import re
from pathlib import Path

def read_policy_file(policy_path):
    """
    Read content from a policy file.
    
    Args:
        policy_path (Path): Path to the policy file
        
    Returns:
        str: The content of the policy file, stripped of leading/trailing whitespace
    """
    with open(policy_path, 'r') as f:
        return f.read().strip()

def update_markdown_file(markdown_file, policy_name, policy_content):
    """
    Update the markdown file with the policy content from the policy file.
    
    Args:
        markdown_file (str): Path to the markdown file to update
        policy_name (str): Name of the policy file (e.g., 'allowed_false.rego')
        policy_content (str): Current content of the policy file
        
    Returns:
        bool: True if the markdown file was updated, False if no reference to the policy was found
    """
    with open(markdown_file, 'r') as f:
        content = f.read()
    
    # Find the policy reference in the markdown
    policy_ref_pattern = r'\[aap_policy_examples/' + re.escape(policy_name) + r'\]'
    if not re.search(policy_ref_pattern, content):
        print(f"Warning: No reference to policy {policy_name} found in {markdown_file}")
        return False
    
    # Replace the content in the rego code block
    # The pattern matches the opening ```rego, any content, and the closing ```
    pattern = r'(```rego\n).*?(\n```)'
    replacement = f'\\1{policy_content}\\2'
    new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)
    
    with open(markdown_file, 'w') as f:
        f.write(new_content)
    return True

def main():
    """
    Main function that orchestrates the sync process.
    
    The function:
    1. Finds all markdown files in the current directory
    2. Gets all policy files from aap_policy_examples/
    3. For each policy file, attempts to update its content in any markdown files that reference it
    """
    # Get all markdown files in the current directory
    markdown_files = [f for f in os.listdir('.') if f.endswith('.md')]
    policy_dir = Path('aap_policy_examples')
    
    # Get all policy files
    policy_files = list(policy_dir.glob('*.rego'))
    
    for md_file in markdown_files:
        print(f"\nProcessing {md_file}...")
        for policy_file in policy_files:
            policy_name = policy_file.name
            policy_content = read_policy_file(policy_file)
            
            if update_markdown_file(md_file, policy_name, policy_content):
                print(f"✓ Updated {policy_name} in {md_file}")
            # else:
                # print(f"✗ No reference to {policy_name} found in {md_file}")

if __name__ == '__main__':
    main() 