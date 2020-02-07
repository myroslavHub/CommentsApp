using System;
using System.Collections.Generic;

namespace commentsapi.Models
{
    public class Topic
    {
        public Topic()
        {
            Comments = new List<Comment>();
        }

        public long Id { get; set; }
        public string Author { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }

        public ICollection<Comment> Comments { get; set; }
    }
}