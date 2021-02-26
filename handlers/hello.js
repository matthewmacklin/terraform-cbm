export const main = async (event, context) => {
  console.log({ event });

  return {
    statusCode: 200,
    body: JSON.stringify(
      {
        message: 'Hello world!!! testing 3.48',
      },
      null,
      2
    ),
  };
};
