using System;
using System.Collections.Generic;

namespace commentsapi.Models
{
    public class Comment
    {
        public Comment()
        {
            Comments = new List<Comment>();
        }
        public int Id { get; set; }
        public string Text { get; set; }
        public string Author { get; set; }

        public DateTime Date { get; set; }
        public ICollection<Comment> Comments { get; set; }
    }
}