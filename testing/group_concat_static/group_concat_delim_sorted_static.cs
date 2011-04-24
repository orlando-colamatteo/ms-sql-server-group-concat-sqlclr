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
    public struct group_concat_delim_sorted_static : IBinarySerialize
    {
        readonly static ThreadSafeDictionary<Guid, List<string>> theSortedLists =
            new ThreadSafeDictionary<Guid, List<string>>();

        private List<string> values;
        private string delimiter;
        private string sortBy;

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
            this.delimiter = null;
            this.sortBy = null;
        }

        public void Accumulate([SqlFacet(MaxSize = 4000)] SqlString Value,
                               [SqlFacet(MaxSize = 1)] SqlString Delimiter,
                               [SqlFacet(MaxSize = 4)] SqlString SortBy)
        {
            if (!Value.IsNull)
            {
                this.values.Add(Value.Value);
            }
            this.Delimiter = Delimiter;
            this.SortBy = SortBy;
        }

        public void Merge(group_concat_delim_sorted_static Group)
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
                    StringBuilder returnValue = new StringBuilder();
                    for (int i = (values.Count - 1); i >= 0; i--)
                    {
                        returnValue.Append(values[i]);
                        returnValue.Append(this.delimiter);
                    }
                    returnValue.Remove(returnValue.Length - 1, 1);
                    return new SqlString(returnValue.ToString());
                }
                else
                {
                    return new SqlString(string.Join(this.delimiter, this.values.ToArray()));
                }
            }

            return null;
        }

        public void Read(BinaryReader r)
        {
            Guid g = new Guid(r.ReadBytes(16));

            try
            {
                this.values = theSortedLists[g];

                this.delimiter = r.ReadString();

                this.sortBy = r.ReadString();
            }
            finally
            {
                theSortedLists.Remove(g);
            }
        }

        public void Write(BinaryWriter w)
        {
            Guid g = Guid.NewGuid();

            try
            {
                w.Write(g.ToByteArray());

                theSortedLists.Add(g, this.values);

                w.Write(this.delimiter);

                w.Write(this.sortBy);
            }
            catch
            {
                if (theSortedLists.ContainsKey(g))
                    theSortedLists.Remove(g);
            }
        }
    }
}