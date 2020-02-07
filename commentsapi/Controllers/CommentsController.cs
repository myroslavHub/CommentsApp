using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using commentsapi.Models;

namespace commentsapi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CommentsController : ControllerBase
    {
        private readonly CommentsContext _context;

        public CommentsController(CommentsContext context)
        {
            _context = context;
        }

        // GET: api/Comments
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Comment>>> GetComments()
        {
            var comments = await _context.Comments.ToListAsync();
            var indexes = RemoveIds(comments);
            comments.RemoveAll(c=>indexes.Contains(c.Id));
            // foreach (var index in )
            // {
            //     if (comments.Any(c=>c.Id == index)){
            //         comments.re
            //     }
            // }
            return comments;
            return await _context.Comments.ToListAsync();
        }
        private IEnumerable<int> RemoveIds(List<Comment> comment)
        {
            var lst = new List<int>();

            foreach (var c in comment)
            {
                lst.AddRange(RemoveIds(c));
            }
            return lst;
        }
        private IEnumerable<int> RemoveIds(Comment comment, int deep = 0)
        {
            if (deep > 0)
            {
                yield return comment.Id;
            }

            for (int i = 0; i < comment.Comments.Count; i++){
                foreach (var item in RemoveIds(comment.Comments.ElementAt(i), deep + 1))
                {
                    yield return item;
                }
            }
        }

        // GET: api/Comments/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Comment>> GetComment(int id)
        {
            var comment = await _context.Comments.FindAsync(id);

            if (comment == null)
            {
                return NotFound();
            }

            return comment;
        }

        // PUT: api/Comments/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutComment(int id, Comment comment)
        {
            if (id != comment.Id)
            {
                return BadRequest();
            }

            _context.Entry(comment).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CommentExists(id))
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

        // POST: api/Comments
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for
        // more details see https://aka.ms/RazorPagesCRUD.
        [HttpPost()]
        public async Task<ActionResult<Comment>> PostComment(Comment comment)
        {
            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetComment", new { id = comment.Id }, comment);
        }

        [HttpPost("{Id}")]
        public async Task<ActionResult<Comment>> PostComment(int id, Comment comment)
        {
            var t = await _context.Comments.FindAsync(id);
            t.Comments.Add(comment);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetComment", new { id = comment.Id }, comment);
        }

        // [HttpPut("add/{id}")]
        // public async Task<IActionResult> AddComment(int id, Comment comment)
        // {
        //     var t = await _context.Comments.FindAsync(id);
        //     t.Comments.Add(comment);
        //     await _context.SaveChangesAsync();

        //     return NoContent();
        // }

        // DELETE: api/Comments/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Comment>> DeleteComment(int id)
        {
            var comment = await _context.Comments.FindAsync(id);
            if (comment == null)
            {
                return NotFound();
            }

            _context.Comments.Remove(comment);
            await _context.SaveChangesAsync();

            return comment;
        }

        private bool CommentExists(int id)
        {
            return _context.Comments.Any(e => e.Id == id);
        }
    }
}
