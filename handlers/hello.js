export const main = async (event, context) => {
  console.log({ event });

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Hello world!!! testing uat stage 1 Mar 12.32',
      },
      null,
      2
    ),
  };
};
