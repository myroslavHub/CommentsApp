using Microsoft.EntityFrameworkCore;

namespace commentsapi.Models
{
    public class CommentsContext : DbContext
    {
        public DbSet<Topic> Topics { get; set; }
        public DbSet<Comment> Comments { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data Source=CommentsDB.db;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Comment>()
                .HasMany(c => c.Comments)
                .WithOne()
                .HasForeignKey("ParentId").IsRequired(false).OnDelete(DeleteBehavior.Cascade);

            //modelBuilder.Entity<Comment>().HasOne(c => c.Parent).WithMany(c => c.Comments).OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<Topic>()
                .HasMany(c => c.Comments)
                .WithOne().HasForeignKey("TopicId").IsRequired(false).OnDelete(DeleteBehavior.Cascade);

        }
    }

}