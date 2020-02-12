using System;

namespace commentsapi.Dto
{
    public class TopicDto
    {
        public TopicDto()
        {
        }

        public long Id { get; set; }
        public string Author { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public int CommentsCount{ get; set; }
        public DateTime Date { get; set; }
    }
}