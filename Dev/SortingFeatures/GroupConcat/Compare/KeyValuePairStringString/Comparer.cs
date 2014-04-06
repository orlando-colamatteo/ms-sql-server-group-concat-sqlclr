using System;
using System.Collections.Generic;
using System.Text;

namespace GroupConcat.Compare.KeyValuePairStringString
{
    public class Comparer : IEqualityComparer<KeyValuePair<string, string>>, IComparer<KeyValuePair<string, string>>
    {
        public int Compare(KeyValuePair<string, string> x, KeyValuePair<string, string> y)
        {
            // Compare values of x and y
            return ((x.Key + x.Value).ToLower()).CompareTo(((y.Key + y.Value).ToLower()));
        }

        public bool Equals(KeyValuePair<string, string> x, KeyValuePair<string, string> y)
        {
            return x.Key.ToLower() == y.Key.ToLower() && x.Value.ToLower() == y.Value.ToLower();
        }

        public int GetHashCode(KeyValuePair<string, string> obj)
        {
            return (obj.Key.ToLower() + obj.Value.ToLower()).ToLower().GetHashCode();
        }
    }
}
