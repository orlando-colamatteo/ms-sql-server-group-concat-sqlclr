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
    public struct group_concat_string_delim : IBinarySerialize
    {
        private StringBuilder values;
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
            this.values = new StringBuilder();
            this.delimiter = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 1)] SqlString Delimiter)
        {
            if (!Value.IsNull)
            {
                this.values.Append(Value.Value + this.delimiter);
            }
            this.Delimiter = Delimiter;
        }

        public void Merge(group_concat_string_delim Group)
        {
            this.values.Append(Group.values.ToString() + ",");
        }

        [return: SqlFacet(MaxSize = -1)]
        public SqlString Terminate()
        {
            if (values.Length > 0)
            {
                string returnString = values.ToString();
                returnString = returnString.Remove(returnString.Length - 1);
                return new SqlString(returnString); 
            }

            return null;
        }

        public void Read(BinaryReader r)
        {
            this.values = new StringBuilder(r.ReadString());
        }

        public void Write(BinaryWriter w)
        {
            w.Write(this.values.ToString());
        }
    }
}