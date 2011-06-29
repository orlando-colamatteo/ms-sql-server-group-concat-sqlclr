/*
 Full credit for this class goes to Adam Machanic. It was copied verbatim
 * from book "Expert SQL Server 2005 Development" and the content of this
 * class is freely available on the internet through Google Books.
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace group_concat
{
    public class ThreadSafeDictionary<K, V>
    {
        private readonly Dictionary<K, V> dict = new Dictionary<K, V>();
        private readonly ReaderWriterLock theLock = new ReaderWriterLock();

        public void Add(K key, V value)
        {
            theLock.AcquireWriterLock(2000);

            try
            {
                dict.Add(key, value);
            }
            finally
            {
                theLock.ReleaseLock();
            }
        }

        public V this[K key]
        {
            get
            {
                theLock.AcquireReaderLock(2000);
                try
                {
                    return (this.dict[key]);
                }
                finally
                {
                    theLock.ReleaseLock();
                }
            }

            set{theLock.AcquireWriterLock(2000);
                try
                {
                    dict[key] = value;
                }
                finally
                {
                    theLock.ReleaseLock();
                }
            }
        }

        public bool Remove (K key)
        {
            theLock.AcquireWriterLock(2000);
            try
            {
                return (dict.Remove(key));
            }
            finally
            {
                theLock.ReleaseLock();
            }
        }

        public bool ContainsKey(K key)
        {
            theLock.AcquireReaderLock(2000);
            try
            {
                return (dict.ContainsKey(key));
            }
            finally
            {
                theLock.ReleaseLock();
            }
        }
    }
}
