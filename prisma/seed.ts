import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function seedData() {
  const names = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eve']; // Replace with Indian names if desired
  const tagNames = ['Women\'s Empowerment', 'Women in STEM', 'Women\'s Health', 'Feminism', 'Gender Equality'];

  // Function to generate random date within the past year
  function getRandomPastDate() {
    const pastYear = new Date();
    pastYear.setFullYear(pastYear.getFullYear() - 1);
    const randomOffset = Math.floor(Math.random() * (Date.now() - pastYear.getTime()));
    return new Date(pastYear.getTime() + randomOffset);
  }

  // Pre-seed tags (ensures unique names)
  const tags = [];
  for (const tagName of tagNames) {
    const existingTag = await prisma.tag.findUnique({
      where: { name: tagName },
    });

    if (!existingTag) {
      const tag = await prisma.tag.create({
        data: {
          name: tagName,
        },
      });
      tags.push(tag);
    } else {
      tags.push(existingTag);
    }
  }

  for (let i = 0; i < 100; i++) {
    const randomNameIndex = Math.floor(Math.random() * names.length);
    const name = names[randomNameIndex];
    const location = 'India'; // Can specify a state or randomize within India
    const age = Math.floor(Math.random() * (35 - 18 + 1)) + 18;

    const user = await prisma.user.create({
      data: {
        name,
        location,
        age,
        dateofjoining :getRandomPastDate()
      },
    });

    // Create a random number of posts between 1 and 3 for each user
    const numPosts = Math.floor(Math.random() * 3) + 1;
    for (let j = 0; j < numPosts; j++) {
      const postTitle = `Post ${j + 1} by ${name}`;
      const postLink = `https://example.com/post/${user.id}-${j}`;
      const uploadedAt = getRandomPastDate();
      const language = ['English', 'Hindi'][Math.floor(Math.random() * 2)]; // Adjust languages as needed

      const post = await prisma.post.create({
        data: {
          name: postTitle,
          link: postLink,
          uploadedAt,
          language,
          creator: { connect: { id: user.id } },
        },
      });

      // Assign all pre-seeded tags (women-centric) to each post
      for (const tag of tags) {
        try {
          await prisma.postTag.create({
            data: {
              postId: post.id,
              tagId: tag.id,
            },
          });
        } catch (error) {
          if (error.code === 'P2002') {
            // Unique constraint violation (shouldn't occur here)
            console.warn(`Skipping duplicate association for post ${post.id} and tag ${tag.id}`);
          } else {
            throw error;
          }
        }
      }
    }
  }

  console.log('Seeded 100 users with posts, women-centric tags, and timestamps over a year');
}

seedData()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
