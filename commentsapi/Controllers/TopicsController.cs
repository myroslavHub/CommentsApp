using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using commentsapi.Models;
using commentsapi.Dto;

namespace commentsapi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TopicsController : ControllerBase
    {
        private readonly CommentsContext _context;

        public TopicsController(CommentsContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<TopicDto>>> GetTopics()
        {
            var topics = await _context.Topics.Include(t => t.Comments).ToListAsync();
            var comments = await _context.Comments.ToListAsync();

            return topics.Select(topic=>new TopicDto(){
                Id = topic.Id,
                Author = topic.Author,
                Name = topic.Name,
                Description = topic.Description,
                Date = topic.Date,
                CommentsCount = comments.Where(com => topic.Comments.Any(c => c.Id == com.Id)).ToList().Select(GetCommentsCount).Sum()
            }).ToList();
        }

        private int GetCommentsCount(Comment comment){
            if (comment.Comments == null || comment.Comments.Count==0){
                return 1;
            }

            return comment.Comments.Select(GetCommentsCount).Sum() + 1;
        }


        [HttpGet("{topicId}/comments")]
        public async Task<ActionResult<IEnumerable<Comment>>> GetCommentsForTopic(int topicId)
        {
            var topic = await _context.Topics.Include(t => t.Comments).FirstAsync(t => t.Id == topicId);

            var comments = await _context.Comments.ToListAsync();

            return comments.Where(com => topic.Comments.Any(c => c.Id == com.Id)).ToList();
        }

        // GET: api/Topics/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Topic>> GetTopic(long id)
        {
            var topic = await _context.Topics.Include(t => t.Comments).ThenInclude(c => c.Comments).FirstAsync(t => t.Id == id); // .FindAsync(id);
            //var topic = await _context.Topics.FindAsync(id);


            if (topic == null)
            {
                return NotFound();
            }

            return topic;
        }

        // PUT: api/Topics/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTopic(long id, Topic topic)
        {
            if (id != topic.Id)
            {
                return BadRequest();
            }

            _context.Entry(topic).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TopicExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Topics
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPost]
        public async Task<ActionResult<Topic>> PostTopic(Topic topic)
        {
            _context.Topics.Add(topic);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTopic", new { id = topic.Id }, topic);
        }

        // DELETE: api/Topics/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Topic>> DeleteTopic(long id)
        {
            var topic = await _context.Topics.FindAsync(id);
            if (topic == null)
            {
                return NotFound();
            }

            _context.Topics.Remove(topic);
            await _context.SaveChangesAsync();

            return topic;
        }

        private bool TopicExists(long id)
        {
            return _context.Topics.Any(e => e.Id == id);
        }
    }
}
