import sys

def read_file_strict(filepath):
    """
    Reads a file and returns a list of lines.
    It removes the trailing whitespace of the *file* to avoid EOF issues,
    BUT it preserves internal blank lines to detect formatting errors.
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            # We strip the main content to handle the final newline of the file gracefully,
            # but we split strictly by newline to catch internal empty lines.
            lines = content.strip().split('\n')
            
            # Remove Windows return carriage '\r' just in case, but keep empty strings
            lines = [l.strip('\r') for l in lines]
            return lines
    except FileNotFoundError:
        print(f"Error: File '{filepath}' not found.")
        sys.exit(1)

def compare_strict(student_file, key_file):
    print(f"Strict Checking: '{student_file}' vs '{key_file}'")
    print("-" * 60)

    stu_lines = read_file_strict(student_file)
    key_lines = read_file_strict(key_file)

    # 1. Check Total Line Count
    # Expected format:
    # Line 0: Q1
    # Line 1: val
    # Line 2: val
    # Line 3: Q2 (NO blank line before this!)
    # Line 4: val
    # Line 5: val
    # Line 6: Q3
    # Line 7: val
    # Total = 8 lines
    EXPECTED_LINES = 8
    
    if len(stu_lines) != EXPECTED_LINES:
        print(f"❌ Format Error: Incorrect line count.")
        print(f"   Expected exactly {EXPECTED_LINES} lines.")
        print(f"   Your output has {len(stu_lines)} lines.")
        print(f"   (Did you add extra blank lines or debug prints?)")
        return

    # 2. Iterate line by line strictly
    all_passed = True
    
    # Define the expected structure for the 8 lines
    # Type: 'header' or 'value'
    structure = [
        {'idx': 0, 'type': 'header', 'val': 'Q1'},
        {'idx': 1, 'type': 'value',  'name': 'Q1 (X1 log e1)'},
        {'idx': 2, 'type': 'value',  'name': 'Q1 (X1 log s1)'},
        {'idx': 3, 'type': 'header', 'val': 'Q2'},
        {'idx': 4, 'type': 'value',  'name': 'Q2 (F English)'},
        {'idx': 5, 'type': 'value',  'name': 'Q2 (F Spanish)'},
        {'idx': 6, 'type': 'header', 'val': 'Q3'},
        {'idx': 7, 'type': 'value',  'name': 'Q3 (Posterior)'},
    ]

    for item in structure:
        i = item['idx']
        stu_line = stu_lines[i]
        key_line = key_lines[i]

        # Strict Blank Line Check
        if not stu_line.strip():
            print(f"❌ Line {i+1}: Found an EMPTY line!")
            print(f"   Expected: {item.get('val') if item['type'] == 'header' else 'Number'}")
            print(f"   (Rule: 'Do not add additional blank lines between your outputs')")
            all_passed = False
            continue

        # Check Headers (Q1, Q2, Q3)
        if item['type'] == 'header':
            if stu_line.strip() == item['val']:
                print(f"✅ Line {i+1}: Header '{stu_line}' matches.")
            else:
                print(f"❌ Line {i+1}: Header Mismatch.")
                print(f"   Student:  '{stu_line}'")
                print(f"   Expected: '{item['val']}'")
                all_passed = False

        # Check Numeric Values
        elif item['type'] == 'value':
            try:
                val_stu = float(stu_line)
                val_key = float(key_line)
                
                # Check accuracy (using exact match as requested, or small epsilon)
                # Since Gradescope uses strict float comparison, we do too.
                if val_stu == val_key:
                    print(f"✅ Line {i+1}: {item['name']} matches ({val_stu})")
                else:
                    print(f"❌ Line {i+1}: {item['name']} Value Mismatch.")
                    print(f"   Student:  {val_stu}")
                    print(f"   Expected: {val_key}")
                    print(f"   Diff:     {val_stu - val_key}")
                    all_passed = False
            except ValueError:
                print(f"❌ Line {i+1}: Format Error. Expected number for {item['name']}.")
                print(f"   Found text: '{stu_line}'")
                all_passed = False

    print("-" * 60)
    if all_passed:
        print("🎉 All strict checks PASSED!")
    else:
        print("⚠️ Checks FAILED.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 compare_hw2.py <your_output.txt> <answer_key.txt>")
    else:
        compare_strict(sys.argv[1], sys.argv[2])