export const main = async (event, context) => {
  console.log({ event });

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Hello world!!! testing uat stage 1 Mar 10.56',
      },
      null,
      2
    ),
  };
};
