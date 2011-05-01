using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
using System.Collections.Generic;
using System.Text;


namespace GroupConcat
{
    [Serializable]
    [SqlUserDefinedAggregate(Format.UserDefined,
                             MaxByteSize = -1,
                             IsInvariantToNulls = true,
                             IsInvariantToDuplicates = false,
                             IsInvariantToOrder = true,
                             IsNullIfEmpty = true)]
    public struct GROUP_CONCAT_D : IBinarySerialize
    {
        private Dictionary<string, int> values;
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
            this.values = new Dictionary<string, int>();
            this.delimiter = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString VALUE,
                               [SqlFacet(MaxSize = 4)] SqlString DELIMITER)
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
            this.Delimiter = DELIMITER;
        }

        public void Merge(GROUP_CONCAT_D Group)
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
            if (this.values.Count > 0)
            {
                StringBuilder returnString = new StringBuilder();
                foreach (KeyValuePair<string, int> item in this.values)
                {
                    string key = item.Key;
                    for (int keys = 0; keys < item.Value; keys++)
                    {
                        returnString.Append(item.Key + this.delimiter);
                    }
                }
                string returnString2 = returnString.ToString();
                return new SqlString(returnString2.Substring(0, returnString2.Length - 1));
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
        }
    }
}