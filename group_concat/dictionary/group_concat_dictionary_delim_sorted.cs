using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace group_concat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct group_concat_dictionary_delim_sorted : IBinarySerialize
    {
        private Dictionary<string, int> values;
        private string delimiter;
        private string sortBy;

        private SqlString Delimiter
        {
            set
            {
                if (this.delimiter == null)
                {
                    this.delimiter = value.ToString();
                }
            }
        }

        private SqlString SortBy
        {
            set
            {
                if (this.sortBy == null)
                {
                    string sortByValue = value.ToString().Trim().ToLower();
                    if (string.Compare(sortByValue, "asc") != 0 && string.Compare(sortByValue, "desc") != 0)
                    {
                        throw new Exception("Invalid SortBy value: use ASC or DESC.");
                    }
                    this.sortBy = sortByValue;
                }
            }
        }

        public void Init()
        {
            this.values = new Dictionary<string, int>();
            this.delimiter = null;
            this.sortBy = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 1)] SqlString Delimiter,
                               [SqlFacet(MaxSize = 4)] SqlString SortBy)
        {
            if (!Value.IsNull)
            {
                string key = Value.Value;
                if (this.values.ContainsKey(key))
                {
                    this.values[key] += 1;
                }
                else
                {
                    this.values.Add(key, 1);
                }
            }
            this.Delimiter = Delimiter;
            this.SortBy = SortBy;
        }

        public void Merge(group_concat_dictionary_delim_sorted Group)
        {
            foreach (KeyValuePair<string, int> item in Group.values)
            {
                string key = item.Key;
                if (this.values.ContainsKey(key))
                {
                    this.values[key] += 1;
                }
                else
                {
                    this.values.Add(key, 1);
                }
            }
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (this.values != null && this.values.Count > 0)
            {
                StringBuilder returnStringBuilder = new StringBuilder();
                string returnString;

                SortedDictionary<string, int> sortedValues = new SortedDictionary<string, int>(values);

                if (string.Compare(this.sortBy, "desc") == 0)
                {
                    // iterate over the SortedDictionary in descending order
                    for (int i = (sortedValues.Count - 1); i >= 0; i--)
                    {
                        string key = values.ElementAt(i).Key;
                        for (int value = 0; value < values.ElementAt(i).Value; value++)
                        {
                            returnStringBuilder.Append(key + this.delimiter);
                        }
                    }
                    returnString = returnStringBuilder.ToString();
                    returnString = returnString.Remove(returnString.Length - 1, 1);
                    return new SqlString(returnString);
                }
                else
                {
                    // iterate over the SortedDictionary
                    foreach (KeyValuePair<string, int> item in sortedValues)
                    {
                        string key = item.Key;
                        for (int value = 0; value < item.Value; value++)
                        {
                            returnStringBuilder.Append(key + this.delimiter);
                        }
                    }
                    returnString = returnStringBuilder.ToString();
                    returnString = returnString.Remove(returnString.Length - 1, 1);
                    return new SqlString(returnString);
                }
            }

            return null;
        }

        public void Read(BinaryReader r)
        {
            int itemCount = r.ReadInt32();
            this.values = new Dictionary<string, int>(itemCount);
            for (int i = 0; i <= itemCount - 1; i++)
            {
                this.values.Add(r.ReadString(), r.ReadInt32());
            }
            this.delimiter = r.ReadString();
            this.sortBy = r.ReadString();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.Count);
            foreach (KeyValuePair<string, int> s in this.values)
            {
                w.Write(s.Key);
                w.Write(s.Value);
            }
            w.Write(this.delimiter);
            w.Write(this.sortBy);
        }
    }
}