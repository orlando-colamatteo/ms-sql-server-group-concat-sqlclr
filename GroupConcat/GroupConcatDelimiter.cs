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
    public struct GroupConcatDelimiter : IBinarySerialize
    {
        private Dictionary<string, int> values;
        private string delimiter;

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

        public void Init()
        {
            this.values = new Dictionary<string, int>(StringComparer.InvariantCulture);
            this.delimiter = string.Empty;
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
                this.Delimiter = DELIMITER;
            }
        }

        public void Merge(GroupConcatDelimiter Group)
        {
            if (string.IsNullOrEmpty(this.delimiter))
            {
                this.delimiter = Group.delimiter;
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
                StringBuilder returnStringBuilder = new StringBuilder();

                foreach (KeyValuePair<string, int> item in this.values)
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
                // parameter evaluation order left to right is guaranteed in C# (7.5.1.2 in the C# 4.0 spec)
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
