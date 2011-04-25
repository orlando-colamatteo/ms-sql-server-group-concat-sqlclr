﻿using System;
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
    public struct GROUP_CONCAT_S : IBinarySerialize
    {
        private Dictionary<string, int> values;
        private string sortBy;

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
            this.sortBy = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString VALUE,
                               [SqlFacet(MaxSize = 4)] SqlString SORT_ORDER)
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
            }
            this.SortBy = SORT_ORDER;
        }

        public void Merge(GROUP_CONCAT_S Group)
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
                        string key = sortedValues.ElementAt(i).Key;
                        for (int value = 0; value < values.ElementAt(i).Value; value++)
                        {
                            returnStringBuilder.Append(key + ",");
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
                            returnStringBuilder.Append(key + ",");
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
            w.Write(this.sortBy);
        }
    }
}