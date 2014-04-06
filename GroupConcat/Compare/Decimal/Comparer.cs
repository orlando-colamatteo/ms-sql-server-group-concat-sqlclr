using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare.Decimal
{
    public class Comparer : IComparer<string>
    {
        public int Compare(string x, string y)
        {
            // Compare x to y as decimals
            return Convert.ToDecimal(x).CompareTo(Convert.ToDecimal(y));
        }
    }
}
