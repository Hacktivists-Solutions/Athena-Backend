-- CreateEnum
CREATE TYPE "Permission" AS ENUM ('ADMIN', 'SUPER_ADMIN', 'TECH', 'USER');

-- CreateTable
CREATE TABLE "User" (
    "id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "permission" "Permission" NOT NULL DEFAULT 'USER',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" BIGINT NOT NULL,
    "name" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "uploadedAt" TIMESTAMP(3) NOT NULL,
    "language" TEXT NOT NULL,
    "creatorId" BIGINT NOT NULL,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostTag" (
    "postId" BIGINT NOT NULL,
    "tagId" INTEGER NOT NULL,

    CONSTRAINT "PostTag_pkey" PRIMARY KEY ("postId","tagId")
);

-- CreateTable
CREATE TABLE "_InterestedTags" (
    "A" INTEGER NOT NULL,
    "B" BIGINT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_id_key" ON "User"("id");

-- CreateIndex
CREATE UNIQUE INDEX "User_name_key" ON "User"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Post_id_key" ON "Post"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_name_key" ON "Tag"("name");

-- CreateIndex
CREATE UNIQUE INDEX "_InterestedTags_AB_unique" ON "_InterestedTags"("A", "B");

-- CreateIndex
CREATE INDEX "_InterestedTags_B_index" ON "_InterestedTags"("B");

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTag" ADD CONSTRAINT "PostTag_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostTag" ADD CONSTRAINT "PostTag_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestedTags" ADD CONSTRAINT "_InterestedTags_A_fkey" FOREIGN KEY ("A") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestedTags" ADD CONSTRAINT "_InterestedTags_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
