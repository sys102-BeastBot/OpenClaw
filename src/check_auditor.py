"""Print the exact text of the two functions we need to patch."""
src_path = '/home/sys102/.openclaw/workspace/learning/src/logic_auditor.py'
with open(src_path) as f:
    src = f.read()

# Find and print _check_rhs_fixed_value_present
s1 = src.find('def _check_rhs_fixed_value_present')
e1 = src.find('\ndef _check_crash_guard_present', s1)
print("=== _check_rhs_fixed_value_present ===")
print(repr(src[s1:e1]))
print()

# Find and print _has_max_drawdown_condition
s2 = src.find('def _has_max_drawdown_condition')
e2 = src.find('\ndef _bil_in_non_else_branch', s2)
print("=== _has_max_drawdown_condition ===")
print(repr(src[s2:e2]))
