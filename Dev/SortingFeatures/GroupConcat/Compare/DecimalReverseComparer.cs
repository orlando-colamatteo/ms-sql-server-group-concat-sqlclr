using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare
{
    public class DecimalReverseComparer : IComparer<string>
    {
        public int Compare(string x, string y)
        {
            // Compare x to y as decimals in reverse order.
            // supports range of values: negative 79,228,162,514,264,337,593,543,950,335 through 79,228,162,514,264,337,593,543,950,335
            return Convert.ToDecimal(y).CompareTo(Convert.ToDecimal(x));
        }
    }
}
