using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare
{
    public class ReverseComparer : IComparer<string>
    {
        public int Compare(string x, string y)
        {
            // Compare y and x in reverse order.
            return y.CompareTo(x);
        }
    }
}
