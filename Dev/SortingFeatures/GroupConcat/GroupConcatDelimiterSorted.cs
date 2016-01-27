/*
GROUP_CONCAT string aggregate for SQL Server - https://groupconcat.codeplex.com
Copyright (C) 2011  Orlando Colamatteo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or 
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See http://www.gnu.org/licenses/ for a copy of the GNU General Public 
License.
*/

using System;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;
using GroupConcat.Compare.Decimal;
using GroupConcat.Compare.String;

namespace GroupConcat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             Name = "GROUP_CONCAT_DS",
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct GroupConcatDelimiterSorted : IBinarySerialize
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
                        value.Value != 1 // ASC as String
                        &&
                        value.Value != 2 // DESC as String
                        &&
                        value.Value != 3 // ASC as Number
                        &&
                        value.Value != 4 // DESC as Number
                        )
                    {
                        throw new Exception("Invalid SortBy value: use 1 for ASC string, 2 for DESC string, 3 for ASC numeric or 4 for DESC numeric.");
                    }
                    this.sortBy = Convert.ToByte(value.Value);
                }
            }
        }

        public void Init()
        {
            this.values = new Dictionary<string, int>(StringComparer.InvariantCulture);
            this.delimiter = string.Empty;
            this.sortBy = 0;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 4)] SqlString Delimiter,
                               SqlByte SortOrder)
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
                this.Delimiter = Delimiter;
                this.SortBy = SortOrder;
            }
        }

        public void Merge(GroupConcatDelimiterSorted Group)
        {
            if (string.IsNullOrEmpty(this.delimiter))
            {
                this.delimiter = Group.delimiter;
            }
            if (this.sortBy == 0)
            {
                this.sortBy = Group.sortBy;
            }

            foreach (KeyValuePair<string, int> item in Group.values)
            {
                string key = item.Key;
                if (this.values.ContainsKey(key))
                {
                    this.values[key] += Group.values[key];
                }
                else
                {
                    this.values.Add(key, Group.values[key]);
                }
            }
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (this.values != null && this.values.Count > 0)
            {
                SortedDictionary<string, int> sortedValues;
                StringBuilder returnStringBuilder = new StringBuilder();

                // create SortedDictionary
                switch (this.sortBy)
                {
                    case 4:
                        sortedValues = new SortedDictionary<string, int>(values, new Compare.Decimal.ReverseComparer());
                        break;
                    case 3:
                        sortedValues = new SortedDictionary<string, int>(values, new Compare.Decimal.Comparer());
                        break;
                    case 2:
                        sortedValues = new SortedDictionary<string, int>(values, new Compare.String.ReverseComparer());
                        break;
                    default:
                        sortedValues = new SortedDictionary<string, int>(values);
                        break;
                }

                // iterate over the SortedDictionary
                foreach (KeyValuePair<string, int> item in sortedValues)
                {
                    for (int value = 0; value < item.Value; value++)
                    {
                        returnStringBuilder.Append(item.Key);
                        returnStringBuilder.Append(this.delimiter);
                    }
                }

                // remove trailing delimiter as we return the result
                return returnStringBuilder.Remove(returnStringBuilder.Length - this.delimiter.Length, this.delimiter.Length).ToString();
            }

            return null;
        }

        public void Read(BinaryReader r)
        {
            int itemCount = r.ReadInt32();
            this.values = new Dictionary<string, int>(itemCount, StringComparer.InvariantCulture);
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
