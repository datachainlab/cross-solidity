module.exports = async ({ github, context, header, body }) => {
  const body2 = body
    .replaceAll("%8D", "\r")
    .replaceAll("%0A", "\n")
    .replaceAll("%25", "%");
  const comment = [header, body2].join("\n");

  const { data: comments } = await github.rest.issues.listComments({
    owner: context.repo.owner,
    repo: context.repo.repo,
    issue_number: context.payload.number,
  });

  const botComment = comments.find(
    (comment) =>
      // github-actions bot user
      comment.user.id === 41898282 && comment.body.startsWith(header)
  );

  const requestBody = {
    owner: context.repo.owner,
    repo: context.repo.repo,
    body: comment,
  };
  if (botComment) {
    requestBody.comment_id = botComment.id;
    await github.rest.issues.updateComment(requestBody);
  } else {
    requestBody.issue_number = context.payload.number;
    await github.rest.issues.createComment(requestBody);
  }
};
