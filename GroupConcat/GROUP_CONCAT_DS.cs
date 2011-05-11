using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace GroupConcat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct GROUP_CONCAT_DS : IBinarySerialize
    {
        private Dictionary<string, int> values;
        private string delimiter;
        private byte sortBy;

        private SqlString Delimiter
        {
            set
            {
                string newDelimiter = value.ToString();
                if (this.delimiter != newDelimiter)
                {
                    this.delimiter = newDelimiter;
                }
            }
        }

        private SqlByte SortBy
        {
            set
            {
                if (this.sortBy == 0)
                {
                    if (
                        value.Value != 1 // ASC
                        &&
                        value.Value != 2 // DESC
                        )
                    {
                        throw new Exception("Invalid SortBy value: use 1 for ASC or 2 for DESC.");
                    }
                    this.sortBy = Convert.ToByte(value.Value);
                }
            }
        }

        public void Init()
        {
            this.values = new Dictionary<string, int>();
            this.delimiter = string.Empty;
            this.sortBy = 0;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString VALUE,
                               [SqlFacet(MaxSize = 4)] SqlString DELIMITER,
                               SqlByte SORT_ORDER)
        {
            if (!VALUE.IsNull)
            {
                string key = VALUE.Value;
                if (this.values.ContainsKey(key))
                {
                    this.values[key] += 1;
                }
                else
                {
                    this.values.Add(key, 1);
                }
                this.Delimiter = DELIMITER;
                this.SortBy = SORT_ORDER;
            }
        }

        public void Merge(GROUP_CONCAT_DS Group)
        {
            foreach (KeyValuePair<string, int> item in Group.values)
            {
                string key = item.Key;
                if (this.values.ContainsKey(key))
                {
                    this.values[key] += Group.values[key];
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

                if (this.sortBy == 2)
                {
                    // iterate over the SortedDictionary in descending order
                    for (int i = (sortedValues.Count - 1); i >= 0; i--)
                    {
                        string key = sortedValues.ElementAt(i).Key;
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
            this.sortBy = r.ReadByte();
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
