using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare.KeyValuePairStringString
{
    public class DecimalComparer : IEqualityComparer<KeyValuePair<string, string>>, IComparer<KeyValuePair<string, string>>
    {
        public int Compare(KeyValuePair<string, string> x, KeyValuePair<string, string> y)
        {
            // Compare values of x and y
            return Convert.ToDecimal(x.Value).CompareTo(Convert.ToDecimal(y.Value));
        }

        public bool Equals(KeyValuePair<string, string> x, KeyValuePair<string, string> y)
        {
            return x.Key == y.Key && Convert.ToDecimal(x.Value) == Convert.ToDecimal(y.Value);
        }

        public int GetHashCode(KeyValuePair<string, string> obj)
        {
            return (obj.Key.ToLower() + Convert.ToDecimal(obj.Value).ToString()).GetHashCode();
        }
    }
}
