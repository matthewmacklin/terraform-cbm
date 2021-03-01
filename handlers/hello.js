export const main = async (event, context) => {
  console.log({ event });

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Hello world! Deploying to prod from codebuild...',
      },
      null,
      2
    ),
  };
};
