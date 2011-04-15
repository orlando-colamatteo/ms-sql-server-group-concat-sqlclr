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
    public struct group_concat_list : IBinarySerialize
    {
        private List<string> values;

        public void Init()
        {
            this.values = new List<string>();
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value)
        {
            if (!Value.IsNull)
            {
                this.values.Add(Value.Value);
            }
        }

        public void Merge(group_concat_list Group)
        {
            this.values.AddRange(values.ToArray());
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (values.Count > 0)
            {
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
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.Count);
            foreach (string s in this.values)
            {
                w.Write(s);
            }
        }
    }
}