using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare.KeyValuePairStringString
{
    public class DecimalReverseComparer : IEqualityComparer<KeyValuePair<string, string>>, IComparer<KeyValuePair<string, string>>
    {
        public int Compare(KeyValuePair<string, string> x, KeyValuePair<string, string> y)
        {
            // Compare values of y and x
            return Convert.ToDecimal(y.Value).CompareTo(Convert.ToDecimal(x.Value));
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
