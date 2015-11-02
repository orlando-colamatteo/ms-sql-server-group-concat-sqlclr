using System;
using System.Data;
using System.Data.SqlClient;
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
                             Name = "GROUP_CONCAT_S",
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct GroupConcatSorted : IBinarySerialize
    {
        private Dictionary<string, int> values;
        private byte sortBy;

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
            this.sortBy = 0;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
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
                this.SortBy = SortOrder;
            }
        }

        public void Merge(GroupConcatSorted Group)
        {
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
                    string key = item.Key;
                    for (int value = 0; value < item.Value; value++)
                    {
                        returnStringBuilder.Append(key);
                        returnStringBuilder.Append(",");
                    }
                }
                return returnStringBuilder.Remove(returnStringBuilder.Length - 1, 1).ToString();
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
            w.Write(this.sortBy);
        }
    }
}
