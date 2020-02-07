using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using commentsapi.Models;
using Microsoft.EntityFrameworkCore.Query;

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

        // GET: api/Topics
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Topic>>> GetTopics()
        {
            //return await DiveIn(_context.Topics.Include(t => t.Comments), 0).ToListAsync();
            // for (int i = 0; i<100; i++){
            //     t = t.ThenInclude(t=>t.Comments);
            // }
            // IIncludableQueryable<Topic, ICollection<Comment>> rr;

            return await _context.Topics.Include(t => t.Comments).ToListAsync();

            //return await _context.Topics.ToListAsync();
        }

        private IIncludableQueryable<Topic, ICollection<Comment>> DiveIn(IIncludableQueryable<Topic, ICollection<Comment>> topics, int number){
            for (int i = 0; i < number; i++)
            {
                topics = topics.ThenInclude(t => t.Comments);
            }
            return topics;
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

        [HttpPost("addcomment/Id")]
        public async Task<ActionResult<Comment>> PostComment(long id, Comment comment)
        {
            var t = await _context.Topics.Include(t=>t.Comments).FirstAsync(t=>t.Id == id);
            //_context.Comments.Add(comment);
            t.Comments.Add(comment);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTopic", new { id = id }, t);
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
