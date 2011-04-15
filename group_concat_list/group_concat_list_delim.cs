using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;

namespace group_concat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct group_concat_list_delim : IBinarySerialize
    {
        private List<string> values;
        private string delimiter;

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

        public void Init()
        {
            this.values = new List<string>();
            this.delimiter = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 1)] SqlString Delimiter)
        {
            if (!Value.IsNull)
            {
                this.values.Add(Value.Value);
            }
            this.Delimiter = Delimiter;
        }

        public void Merge(group_concat_list_delim Group)
        {
            this.values.AddRange(values.ToArray());

            //if (!string.IsNullOrEmpty(Group.delimiter) && string.IsNullOrEmpty(this.delimiter))
            //    this.Delimiter = Group.delimiter;
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (values.Count > 0)
            {
                return new SqlString(string.Join(this.delimiter, this.values.ToArray()));
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
            this.delimiter = r.ReadString();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.Count);
            foreach (string s in this.values)
            {
                w.Write(s);
            }
            w.Write(this.delimiter);
        }

    }
}