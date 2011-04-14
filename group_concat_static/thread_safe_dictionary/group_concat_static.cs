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
    public struct group_concat_static : IBinarySerialize
    {
        readonly static ThreadSafeDictionary<Guid, List<string>> theLists = 
            new ThreadSafeDictionary<Guid,List<string>>();
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

        public void Merge(group_concat_static Group)
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
            Guid g = new Guid(r.ReadBytes(16));

            try
            {
                this.values = theLists[g];
            }
            finally
            {
                theLists.Remove(g);
            }
        }

        public void Write(BinaryWriter w)
        {
            Guid g = Guid.NewGuid();

            try
            {
                theLists.Add(g, this.values);

                w.Write(g.ToByteArray());
            }
            catch
            {
                if (theLists.ContainsKey(g))
                    theLists.Remove(g);
            }
        }
    }
}