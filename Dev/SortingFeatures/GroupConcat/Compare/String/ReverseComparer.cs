using System.Collections.Generic;

namespace GroupConcat.Compare.String
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
