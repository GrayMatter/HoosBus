"""
Add directories to the module search path.
"""

import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), 'app'))
sys.path.append(os.path.join(os.path.dirname(__file__), 'vendor'))