using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;

namespace group_concat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct group_concat_list_sorted : IBinarySerialize
    {
        private List<string> values;
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
            this.values = new List<string>();
            this.sortBy = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 4)] SqlString SortBy)
        {
            if (!Value.IsNull)
            {
                this.values.Add(Value.Value);
            }
            this.SortBy = SortBy;
        }

        public void Merge(group_concat_list_sorted Group)
        {
            this.values.AddRange(Group.values.ToArray());
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (values.Count > 0)
            {
                this.values.Sort();

                if (string.Compare(this.sortBy, "desc") == 0)
                {
                    // StringBuilder method proved faster than this.values.Reverse();
                    StringBuilder returnValue = new StringBuilder();
                    for (int i = (values.Count - 1); i >= 0; i--)
                    {
                        returnValue.Append(values[i]);
                        returnValue.Append(",");
                    }
                    returnValue.Remove(returnValue.Length - 1, 1);
                    return new SqlString(returnValue.ToString());
                }

                return new SqlString(string.Join(",", this.values.ToArray()));
            }

            return null;
        }

        public void Read(BinaryReader r)
        {
            int itemCount = r.ReadInt32();
            this.values = new List<string>(itemCount);
            for (int i = 0; i <= itemCount - 1; i++)
            {
                this.values.Add(r.ReadString());
            }
            this.sortBy = r.ReadString();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.Count);
            foreach (string s in this.values)
            {
                w.Write(s);
            }
            w.Write(this.sortBy);
        }
    }
}