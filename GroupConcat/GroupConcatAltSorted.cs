using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;
using GroupConcat.Compare.Decimal;
using GroupConcat.Compare.KeyValuePairStringString;
using GroupConcat.Compare.String;

namespace GroupConcat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             Name = "GROUP_CONCAT_AS",
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct GroupConcatAltSorted : IBinarySerialize
    {
        private Dictionary<KeyValuePair<string, string>, int> values;
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
            this.values = new Dictionary<KeyValuePair<string, string>, int>(new Compare.KeyValuePairStringString.Comparer());
            this.sortBy = 0;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 4000)] SqlString AltSortValue,
                               SqlByte SortOrder)
        {
            if (!Value.IsNull && !AltSortValue.IsNull)
            {
                KeyValuePair<string, string> key = new KeyValuePair<string, string>(Value.Value, AltSortValue.Value);
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

        public void Merge(GroupConcatAltSorted Group)
        {
            if (this.sortBy == 0)
            {
                this.sortBy = Group.sortBy;
            }

            foreach (KeyValuePair<KeyValuePair<string, string>, int> item in Group.values)
            {
                KeyValuePair<string, string> key = item.Key;
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
                SortedDictionary<KeyValuePair<string, string>, int> sortedValues;
                StringBuilder returnStringBuilder = new StringBuilder();

                // create SortedDictionary
                switch (this.sortBy)
                {

                    case 4:
                        // number desc
                        sortedValues = new SortedDictionary<KeyValuePair<string, string>, int>(values, new Compare.KeyValuePairStringString.DecimalReverseComparer());
                        break;
                    case 3:
                        // number asc
                        sortedValues = new SortedDictionary<KeyValuePair<string, string>, int>(values, new Compare.KeyValuePairStringString.DecimalComparer());
                        break;
                    case 2:
                        // string desc
                        sortedValues = new SortedDictionary<KeyValuePair<string, string>, int>(values, new Compare.KeyValuePairStringString.ReverseComparer());
                        break;
                    default:
                        // string asc
                        sortedValues = new SortedDictionary<KeyValuePair<string, string>, int>(values, new Compare.KeyValuePairStringString.Comparer());
                        break;
                }

                // iterate over the SortedDictionary
                foreach (KeyValuePair<KeyValuePair<string, string>, int> item in sortedValues)
                {
                    KeyValuePair<string, string> key = item.Key;
                    for (int value = 0; value < item.Value; value++)
                    {
                        //returnStringBuilder.Append(key.Key);
                        returnStringBuilder.Append(key.Value); // bug fix from alendar
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
            this.values = new Dictionary<KeyValuePair<string, string>, int>(itemCount, new Compare.KeyValuePairStringString.Comparer());
            for (int i = 0; i <= itemCount - 1; i++)
            {
                this.values.Add(new KeyValuePair<string, string>(r.ReadString(), r.ReadString()), r.ReadInt32());
            }
            this.sortBy = r.ReadByte();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.Count);
            foreach (KeyValuePair<KeyValuePair<string, string>, int> s in this.values)
            {
                w.Write(s.Key.Key);
                w.Write(s.Key.Value);
                w.Write(s.Value);
            }
            w.Write(this.sortBy);
        }
    }
}
